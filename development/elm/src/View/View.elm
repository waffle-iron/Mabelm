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

import Html exposing (Html, div, h2, h5, text, button)
import Html.Attributes exposing (id, class)

import Messages exposing (Msg(..))
import Model exposing (..)
import View.Toolbar.ViewToolbar as ViewToolbar
import View.Toolbar.ViewAvailableObjects exposing (viewAvailableObjects)
import View.Toolbar.ViewActiveSystems exposing (viewActiveSystems)
import View.GameWindow.ViewGameWindow exposing (gameWindow)
import Html.Events exposing (onClick)

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
            [ h2 [ class "m1 disableUserSelect" ]
                [ text "GameTree" ]
            , showSprite model.root
            ]
        ]

showSprite : GameSprite -> Html Msg
showSprite spr =
    div [ class "border inline-block p1" ]
        [ h5 [ class "m0 disableUserSelect", onClick (ClickTreeSprite spr)  ]
            [ text spr.name ]
        , if spr.isActive 
            then showSpriteActive spr
            else text ""
        ]

showSpriteActive : GameSprite -> Html Msg
showSpriteActive spr =
    div []
        [ button []
            [ text "Add Sprite" ]
        , button []
            [ text "Add Model" ]
        ]  
                 