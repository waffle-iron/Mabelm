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

import Html exposing (Html, div, h2, p, h5, span, text, button)
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
            [ h2 [ class "m0 disableUserSelect" ]
                [ text "GameTree" ]
            , showSprite model.root
            ]
        ]

showSprite : GameSprite -> Html Msg
showSprite spr =
    div []
        [ if spr.isActive then showSpriteActive spr else showSpriteInActive spr
        , div []
            [ showSpriteChildren spr.children
            ]
        ]

showSpriteInActive : GameSprite -> Html Msg
showSpriteInActive spr =
    div [ class "pl1 inline-block" ]
        [ p [ class ("m0 disableUserSelect"), onClick (ClickTreeSprite spr)  ]
            [ text spr.name ]
        ]

showSpriteActive : GameSprite -> Html Msg
showSpriteActive spr =
    div [ class "p1 border inline-block" ]
        [ p [ class ("m0 disableUserSelect"), onClick (ClickTreeSprite spr)  ]
            [ text spr.name ]
        , showModels spr.models
        ]

showSpriteChildren : GameSpriteChildren -> Html Msg
showSpriteChildren (GameSpriteChildren children) =
    div [ class "ml2" ]
        (List.map showSprite children)
                 
showModels : List GameModel -> Html Msg
showModels models =
    div [ class "border p1" ]
        (List.map showModel models)

showModel : GameModel -> Html Msg
showModel model =
    p [ class "m0" ]
        [ text model.name ]


-- type alias GameModel =
--     { name :String
--     , path :String
--     , id :Int
--     , variables :GameObjectAttributes
--     , uniqueName :Maybe String
--     , isActive :Bool
--     , systems :List GameSystem
--     }