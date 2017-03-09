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
import Material.Icons.Editor exposing (mode_edit)
import Material.Icons.Navigation exposing (chevron_right, expand_more)
import Material.Icons.Action exposing (lock, lock_open, visibility, visibility_off)
import Color as Color
import Svg exposing (Svg)


type alias MaterialIcon =
    Color.Color -> Int -> Svg Msg


view : Model -> Html Msg
view model =
    div []
        [ ViewToolbar.toolbar model
        , gameWindow model
        , div [ id "gamePackageContainers", class "" ]
            [ viewActiveSystems model
            , viewAvailableObjects model
            ]
        , div [ id "gameTree", class "" ]
            [ h2 [ class "m0 disableUserSelect" ]
                [ text "GameTree" ]
            , div [ class "border-bottom" ]
                [ showSprite 0 model.runningSystems model.root
                ]
            ]
        ]


showSprite : Int -> List GameObject -> GameSprite -> Html Msg
showSprite level runningSystems spr =
    if spr.isExpanded then
        showSpriteExpanded level runningSystems spr
    else
        showSpriteMinimized level spr


showSpriteMinimized : Int -> GameSprite -> Html Msg
showSpriteMinimized level spr =
    let
        cName =
            if spr.isActive then
                " isActive"
            else
                ""
    in
        div []
            [ div [ class "border-top clearfix" ]
                [ iconVisible spr spr.isVisible
                , iconLocked spr spr.isLocked
                , div [ class ("col col-10" ++ cName), levelMarginLeft level ]
                    [ iconExpanded spr False
                    , p [ class ("m0 disableUserSelect"), onClick (ClickTreeSprite spr) ]
                        [ text (spr.name ++ (toString spr.id)) ]
                    ]
                ]
            ]


showSpriteExpanded : Int -> List GameObject -> GameSprite -> Html Msg
showSpriteExpanded level runningSystems spr =
    let
        cName =
            if spr.isActive then
                " isActive"
            else
                ""
    in
        div []
            [ div [ class "border-top clearfix" ]
                [ iconVisible spr spr.isVisible
                , iconLocked spr spr.isLocked
                , div [ class ("col col-10" ++ cName), levelMarginLeft level ]
                    [ iconExpanded spr True
                    , p [ class ("m0 disableUserSelect"), onClick (ClickTreeSprite spr) ]
                        [ text (spr.name ++ (toString spr.id)) ]
                    ]
                ]
            , div []
                (showSpriteChildren level runningSystems spr.children)
            ]


showSpriteChildren : Int -> List GameObject -> GameSpriteChildren -> List (Html Msg)
showSpriteChildren level runningSystems (GameSpriteChildren children) =
    (List.map (showSprite (level + 1) runningSystems) children)


iconExpanded : GameSprite -> Bool -> Html Msg
iconExpanded spr isExpanded =
    let
        icon =
            if isExpanded then
                expand_more
            else
                chevron_right
    in
        iconGeneric "" ToggleExpanded spr icon


iconLocked : GameSprite -> Bool -> Html Msg
iconLocked spr isLocked =
    let
        icon =
            if isLocked then
                lock
            else
                lock_open
    in
        iconGeneric "border-right" ToggleLocked spr icon


iconVisible : GameSprite -> Bool -> Html Msg
iconVisible spr isVisible =
    let
        icon =
            if isVisible then
                visibility
            else
                visibility_off
    in
        iconGeneric "border-right" ToggleVisiblilty spr icon


iconGeneric : String -> (GameSprite -> Msg) -> GameSprite -> MaterialIcon -> Html Msg
iconGeneric addClass msg spr icon =
    div [ class ("col col-1 " ++ addClass), onClick (msg spr) ]
        [ icon (Color.rgb 100 100 100) 20
        ]



-- showModels : GameSprite -> List GameObject -> List GameModel -> Html Msg
-- showModels spr runningSystems models =
--     div [ class "border p1" ]
--         (List.map (showModel spr runningSystems) models)
-- showModel : GameSprite -> List GameObject -> GameModel -> Html Msg
-- showModel spr runningSystems model =
--     div []
--         [ p [ class "m0", onClick (ToggleModel spr model) ]
--             [ text model.name ]
--         , if model.isActive
--             then showModelEdit runningSystems
--             else text ""
--         ]
-- showModelEdit : List GameObject -> Html Msg
-- showModelEdit runningSystems =
--     div []
--         [ mode_edit (Color.rgb 100 100 100) 20
--         , select []
--             (List.map showSystemOption runningSystems)
--         ]
-- showSystemOption : GameObject -> Html Msg
-- showSystemOption obj =
--     option []
--         [ text obj.name
--         ]


levelMarginLeft : Int -> Attribute msg
levelMarginLeft level =
    let
        levelMargin =
            12

        marginLeft =
            levelMargin * level
    in
        style
            [ ( "padding-left", (toString marginLeft) ++ "px" )
            ]
