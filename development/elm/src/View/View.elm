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


module View.View exposing (..)

import Html exposing (Html, Attribute, div, h2, p, h5, span, text, button, select, option)
import Html.Attributes exposing (id, class)
import Messages exposing (Msg(..))
import Model exposing (..)
import View.Toolbar.ViewToolbar as ViewToolbar
import View.Toolbar.ViewAvailableObjects exposing (viewAvailableObjects)
import View.Toolbar.ViewActiveSystems exposing (viewActiveSystems)
import View.GameWindow.ViewGameWindow exposing (gameWindow)
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


view : Model -> Html Msg
view model =
    div []
        [ ViewToolbar.toolbar model
        , gameWindow model
        , div [ id "gamePackageContainers", class "" ]
            [ viewActiveSystems model
            , viewAvailableObjects model
            ]
        , div [ id "gameTree", class "border-left border-right border-top" ]
            [ div []
                [ showSprite model.runningSystems model.root
                ]
            ]
        , div [ id "gameTreeFooter", class "border" ]
            [ viewButtonBar model.activeSprite model.root.id
            ]
        ]


showSprite : List GameObject -> GameSprite -> Html Msg
showSprite runningSystems spr =
    div [ class "flex" ]
        [ iconGeneric div ToggleVisiblilty spr (ifThen spr.isVisible visibility visibility_off)
        , iconGeneric div ToggleLocked spr (ifThen spr.isLocked lock lock_open)
        , div [ class (ClassState.classStateGameSprite "gameSprite" spr) ]
            [ div [ class (ClassState.classStateGameSprite "gameSprite__header flex" spr) ]
                [ iconGeneric div ToggleExpanded spr (ifThen spr.isExpanded expand_more chevron_right)
                , p [ class ("m0 disableUserSelect"), onClick (ClickTreeSprite spr) ]
                    [ text (spr.name ++ (toString spr.id)) ]
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
    div []
        (List.map showModel models)


showModel : GameModel -> Html Msg
showModel model =
    text model.name


viewButtonBar : Maybe GameSprite -> Int -> Html Msg
viewButtonBar maybeSpr rootID =
    case maybeSpr of
        Nothing ->
            div [ class "ml1" ] [ delete (Color.rgb 150 150 150) 20 ]

        Just spr ->
            if spr.id == rootID then
                div [ class "ml1" ] [ delete (Color.rgb 150 150 150) 20 ]
            else
                div [ class "ml1", onClick (DeleteSprite spr) ] [ delete (Color.rgb 100 100 100) 20 ]
