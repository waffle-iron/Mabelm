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


module View.Toolbar.ViewToolbar exposing (toolbar)

import Html exposing (Html, text, div, ul, li, span)
import Html.Attributes exposing (class, id)
import Material.Icons.Action exposing (build, autorenew)
import Material.Icons.Av exposing (play_arrow, stop)
import Color as Color
import Svg exposing (Svg)
import Messages exposing (Msg(..))
import Html.Events exposing (onClick)
import Model exposing (Model)
import Util.ClassState as ClassState
import Util.Util exposing (ifThen)


type alias MaterialIcon =
    Color.Color -> Int -> Svg Msg


type alias ClassName =
    String


toolbar : Model -> Html Msg
toolbar model =
    let
        renderButton =
            ifThen model.isRendering stop play_arrow

        updateButton =
            ifThen model.isUpdating stop play_arrow

        buildButton =
            ifThen model.isCompiling autorenew autorenew

        baseClass =
            ClassState.classStateModel "toolbar__button" model
    in
        div [ class "toolbar" ]
            [ toolbar__button model baseClass "update" ToggleButtonUpdate updateButton (Color.rgb 100 100 100) 50
            , toolbar__button model baseClass "render" ToggleButtonRender renderButton (Color.rgb 100 100 100) 50
            , toolbar__button model baseClass "compile" CompileGame autorenew (Color.rgb 100 100 100) 50
            ]


toolbar__button : Model -> ClassName -> ClassName -> Msg -> MaterialIcon -> Color.Color -> Int -> Html Msg
toolbar__button model baseClass subClass msg icon color size =
    div [ class (baseClass ++ " " ++ subClass), onClick msg ]
        [ icon color size
        ]
