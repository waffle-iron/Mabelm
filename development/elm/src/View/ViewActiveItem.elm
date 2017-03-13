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


module View.ViewActiveItem exposing (viewActiveItem)

import Html exposing (Html, div, h2, h5, text, p, input, button)
import Html.Attributes exposing (id, class, type_, checked, value)
import Messages exposing (Msg(..))
import Model exposing (..)
import String.Extra as StringExtra
import Material.Icons.Content exposing (create)
import Material.Icons.Navigation exposing (check)
import Color as Color
import Html.Events exposing (onClick, onInput)


viewActiveItem : Model -> Html Msg
viewActiveItem model =
    case model.activeSprite of
        Nothing ->
            text ""

        Just spr ->
            div [ class "border p1" ]
                [ displayGameObject spr
                ]


displayGameObject : GameSprite -> Html Msg
displayGameObject spr =
    div [ class "gameObject" ]
        [ displayTitle spr
        , if spr.isActive then
            div []
                [ displayFieldList spr.constructorVariables.strings (displayFieldString spr)
                , displayFieldList spr.constructorVariables.integers (displayFieldInteger spr)
                , displayFieldList spr.constructorVariables.floats (displayFieldFloat spr)
                , displayFieldList spr.constructorVariables.booleans (displayFieldBoolean spr)
                ]
          else
            text ""
        ]


displayTitle : GameSprite -> Html Msg
displayTitle spr =
    let
        title =
            case spr.uniqueName of
                Nothing ->
                    spr.name

                Just val ->
                    val
    in
        if spr.isEditingTitle then
            div []
                [ input [ class "col col-7", value title, onInput (SaveTitle spr) ] []
                , div [ class "inline-block pl1", onClick (EditTitle spr False) ] [ (check (Color.rgb 100 100 100) 20) ]
                ]
        else
            div []
                [ h2 [ class "disableUserSelect m0 inline-block" ] [ text title ]
                , div [ class "inline-block pl1", onClick (EditTitle spr True) ] [ (create (Color.rgb 100 100 100) 20) ]
                ]


displayFieldList : Maybe (List a) -> (a -> Html Msg) -> Html Msg
displayFieldList maybeFields displayFunc =
    case maybeFields of
        Nothing ->
            text ""

        Just list ->
            div [] (List.map displayFunc list)


displayFieldString : GameSprite -> FieldString -> Html Msg
displayFieldString obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-5 m0 right-align pr1 disableUserSelect" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-7", value (getValueString field.pValue) ] []
        ]


displayFieldInteger : GameSprite -> FieldInteger -> Html Msg
displayFieldInteger obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-5 m0 right-align pr1 disableUserSelect" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-5", value (getValueString field.pValue) ] []
        , button [ class "col col-1 disableUserSelect" ] [ text "-" ]
        , button [ class "col col-1 disableUserSelect" ] [ text "+" ]
        ]


displayFieldFloat : GameSprite -> FieldFloat -> Html Msg
displayFieldFloat obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-5 m0 right-align pr1 disableUserSelect" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-5", value (getValueString field.pValue) ] []
        , button [ class "col col-1 disableUserSelect" ] [ text "-" ]
        , button [ class "col col-1 disableUserSelect" ] [ text "+" ]
        ]


displayFieldBoolean : GameSprite -> FieldBool -> Html Msg
displayFieldBoolean obj field =
    let
        checkedVal =
            case field.pValue of
                Nothing ->
                    False

                Just val ->
                    val
    in
        div [ class "clearfix" ]
            [ h5 [ class "col col-5 m0 right-align pr1 disableUserSelect" ] [ text (field.pName ++ ": ") ]
            , input [ type_ "checkbox", checked checkedVal ] []
            ]


getValueString : Maybe a -> String
getValueString maybeVal =
    case maybeVal of
        Nothing ->
            ""

        Just val ->
            StringExtra.unquote (toString val)
