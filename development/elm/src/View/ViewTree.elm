{-
   Mabelm
   Copyright (C) 2017  Jeremy Meltingtallow

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
-}


module View.ViewTree exposing (viewTree)

import Html exposing (Html, Attribute, div, h2, p, h5, span, text, button, select, option)
import Html.Attributes exposing (id, class)
import Messages exposing (Msg(..))
import Model exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Material.Icons.Navigation exposing (chevron_right, expand_more)
import Material.Icons.Action exposing (lock, lock_open, visibility, visibility_off, delete)
import Color as Color
import Svg exposing (Svg)
import Util.ClassState as ClassState
import Util.Util exposing (ifThen)


type alias MaterialIcon =
    Color.Color -> Int -> Svg Msg


type alias Elem =
    List (Attribute Msg) -> List (Html Msg) -> Html Msg


viewTree : Model -> Html Msg
viewTree model =
    div [ id "gameTree", class "border-left border-right border-top" ]
        [ div []
            [ showSprite model.runningSystems model.root
            ]
        ]


showSprite : List GameObject -> GameSprite -> Html Msg
showSprite runningSystems spr =
    let
        title =
            case spr.uniqueName of
                Nothing ->
                    spr.name

                Just val ->
                    val
    in
        div [ class "flex" ]
            [ iconGeneric div ToggleVisiblilty spr (ifThen spr.isVisible visibility visibility_off)
            , iconGeneric div ToggleLocked spr (ifThen spr.isLocked lock lock_open)
            , div [ class (ClassState.classStateGameSprite "gameSprite" spr) ]
                [ div [ class (ClassState.classStateGameSprite "gameSprite__header flex" spr) ]
                    [ iconGeneric div ToggleExpanded spr (ifThen spr.isExpanded expand_more chevron_right)
                    , p [ class ("m0 disableUserSelect"), onClick (ClickTreeSprite spr) ]
                        [ text title ]
                    ]
                , ifThen spr.isExpanded (showModels spr.models) (text "")
                , ifThen spr.isExpanded (div [] (showSpriteChildren runningSystems spr.children)) (text "")
                ]
            ]


showSpriteChildren : List GameObject -> GameSpriteChildren -> List (Html Msg)
showSpriteChildren runningSystems (GameSpriteChildren children) =
    (List.map (showSprite runningSystems) children)


iconGeneric : Elem -> (GameSprite -> Msg) -> GameSprite -> MaterialIcon -> Html Msg
iconGeneric elem msg spr icon =
    elem [ onClick (msg spr) ]
        [ icon (Color.rgb 100 100 100) 20
        ]


showModels : List GameModel -> Html Msg
showModels models =
    if List.length models > 0 then
        div [ class "border p1" ]
            (List.map showModel models)
    else
        text ""


showModel : GameModel -> Html Msg
showModel model =
    p [ class "m0 p0 disableUserSelect" ]
        [ text model.name
        ]
