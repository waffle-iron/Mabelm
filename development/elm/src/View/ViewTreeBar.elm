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


module View.ViewTreeBar exposing (viewTreeBar)

import Html exposing (Html, Attribute, div, h2, p, h5, span, text, button, select, option)
import Html.Attributes exposing (id, class)
import Messages exposing (Msg(..))
import Model exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Material.Icons.Action exposing (lock, lock_open, visibility, visibility_off, delete)
import Color as Color


viewTreeBar : Model -> Html Msg
viewTreeBar model =
    div [ id "gameTreeFooter", class "border" ]
        [ viewButtonBar model.activeSprite model.root.id
        ]


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
