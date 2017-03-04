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

module View.GameWindow.ViewGameWindow exposing (gameWindow)

import Html exposing (Html, text, div, ul, li, span)
import Html.Attributes exposing (class, id)

import Messages exposing (Msg(..))
import Model exposing (Model)

gameWindow : Model -> Html Msg
gameWindow model =
    div [ id "gameWindow" ]
        []