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

import Html exposing (Html, div, h2, p, h5, span, text, button, select, option)
import Html.Attributes exposing (id, class)

import Messages exposing (Msg(..))
import Model exposing (..)
import View.Toolbar.ViewToolbar as ViewToolbar
import View.Toolbar.ViewAvailableObjects exposing (viewAvailableObjects)
import View.Toolbar.ViewActiveSystems exposing (viewActiveSystems)
import View.GameWindow.ViewGameWindow exposing (gameWindow)
import Html.Events exposing (onClick)

import Material.Icons.Editor exposing (mode_edit)
import Color as Color

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
            , showSprite model.runningSystems model.root
            ]
        ]

showSprite : List GameObject -> GameSprite -> Html Msg
showSprite runningSystems spr =
    div []
        [ if spr.isActive then showSpriteActive runningSystems spr else showSpriteInActive spr
        , div []
            [ showSpriteChildren runningSystems spr.children
            ]
        ]

showSpriteInActive : GameSprite -> Html Msg
showSpriteInActive spr =
    div [ class "pl1 inline-block" ]
        [ p [ class ("m0 disableUserSelect"), onClick (ClickTreeSprite spr)  ]
            [ text spr.name ]
        ]

showSpriteActive : List GameObject -> GameSprite -> Html Msg
showSpriteActive runningSystems spr =
    div [ class "p1 border inline-block" ]
        [ p [ class ("m0 disableUserSelect"), onClick (ClickTreeSprite spr)  ]
            [ text spr.name ]
        , showModels spr runningSystems spr.models
        ]

showSpriteChildren : List GameObject -> GameSpriteChildren -> Html Msg
showSpriteChildren runningSystems (GameSpriteChildren children) =
    div [ class "ml2" ]
        (List.map (showSprite runningSystems) children)
                 
showModels : GameSprite -> List GameObject -> List GameModel -> Html Msg
showModels spr runningSystems models =
    div [ class "border p1" ]
        (List.map (showModel spr runningSystems) models)

showModel : GameSprite -> List GameObject -> GameModel -> Html Msg
showModel spr runningSystems model =
    div []
        [ p [ class "m0", onClick (ToggleModel spr model) ]
            [ text model.name ]
        , if model.isActive
            then showModelEdit runningSystems
            else text ""
        ]

showModelEdit : List GameObject -> Html Msg
showModelEdit runningSystems =
    div []
        [ mode_edit (Color.rgb 100 100 100) 20
        , select []
            (List.map showSystemOption runningSystems)
        ]

showSystemOption : GameObject -> Html Msg
showSystemOption obj =
    option []
        [ text obj.name 
        ]