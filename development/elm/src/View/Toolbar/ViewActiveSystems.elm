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


module View.Toolbar.ViewActiveSystems exposing (viewActiveSystems)

import Html exposing (Html, div, h2, h5, text)
import Html.Attributes exposing (id, class)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Model exposing (..)


viewActiveSystems : Model -> Html Msg
viewActiveSystems model =
    div [ class "border p1" ]
        [ h2 [ class "m0 disableUserSelect", onClick ToggleRunningSystems ]
            [ text "Running Systems"
            ]
        , if model.showsRunningSystems then
            div []
                (List.map viewActiveSystem model.runningSystems)
          else
            text ""
        ]


viewActiveSystem : GameObject -> Html Msg
viewActiveSystem obj =
    div [ class "gameObject border p1" ]
        [ h5 [ class "disableUserSelect m0 mb1 mt1" ]
            [ text obj.name ]
        ]
