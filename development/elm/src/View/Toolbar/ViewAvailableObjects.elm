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

module View.Toolbar.ViewAvailableObjects exposing (..)

import Html exposing (Html, div, h2, h3, h4, h5, text, p, input, button)
import Html.Attributes exposing (id, class, type_, checked, value)
import Html.Events exposing (onClick, onInput)
import String.Extra as StringExtra

import Messages exposing (Msg(..))
import Model exposing (..)

viewAvailableObjects : Model -> Html Msg
viewAvailableObjects model =
    div [ class "border p1" ] 
        [ h2 [ class "m0 disableUserSelect", onClick ToggleAvailableObjects ]
            [ text "Available Objects"
            ]
        , if model.showsAvailableObjects
            then
                div []
                    [ case model.activeSprite of
                        Nothing -> 
                            text ""
                        Just spr ->
                            div []
                                [ displayGamePackage "Sprites" "Add to Sprite" tempFunc AddSprite model.spritePackages
                                , displayGamePackage "Models" "Add to Sprite" (filterAddedModels spr.models) AddModel model.modelPackages
                                ]
                    , displayGamePackage "Systems" "Add to Engine" tempFunc AddSystem model.systemPackages
                    ]
            else
                text ""
        ]

displayGamePackage : String -> String -> (GameObject -> Bool) -> (GameObject -> Msg) -> (Maybe GamePackageGroup) -> Html Msg
displayGamePackage title buttonText funcShow msg maybeGroupPackage =
    case maybeGroupPackage of
        Nothing ->
            text ""
        Just group ->
            div []
                [ h3 [ onClick (TogglePackageGroup group), class "disableUserSelect" ] [ text title ]
                , if group.isVisible
                    then div [] (List.map (displayListOfGameObjects buttonText funcShow msg) group.packages)
                    else text ""
                ]

displayListOfGameObjects : String -> (GameObject -> Bool) -> (GameObject -> Msg) -> GamePackage -> Html Msg
displayListOfGameObjects buttonText funcShow msg list =
    div [ class "gameObjectChildren" ]
        [ h4 [ class "disableUserSelect m0 p1", onClick (ToggleSystem list) ] [ text list.path]
        , if list.isVisible
            then div [] (List.map (displayGameObject buttonText msg) (List.filter funcShow list.objects))
            else text ""
        ]

displayGameObject : String -> (GameObject -> Msg) -> GameObject -> Html Msg
displayGameObject buttonText msg obj =
    div [ class "gameObject border p1" ]
        [ h5 [ class "disableUserSelect m0 mb1 mt1", onClick (ToggleObject obj) ] [ text obj.name ]
        , if obj.isActive 
            then div []
                [ displayFieldList obj.variables.strings (displayFieldString obj)
                , displayFieldList obj.variables.integers (displayFieldInteger obj)
                , displayFieldList obj.variables.floats (displayFieldFloat obj)
                , displayFieldList obj.variables.booleans (displayFieldBoolean obj)
                , button [ class "pl1 pr1", onClick (msg obj) ] [ text buttonText ]
                ]
            else text ""
        ]

displayFieldList : Maybe (List a) -> (a -> Html Msg) -> Html Msg
displayFieldList maybeFields displayFunc =
    case maybeFields of
        Nothing -> text ""
        Just list -> div [] (List.map displayFunc list)

displayFieldString : GameObject -> FieldString -> Html Msg
displayFieldString obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-5 m0 right-align pr1 disableUserSelect" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-7", value (getValueString field.pValue), onInput (UpdateStr field obj) ] []
        ]

displayFieldInteger : GameObject -> FieldInteger -> Html Msg
displayFieldInteger obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-5 m0 right-align pr1 disableUserSelect" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-5", value (getValueString field.pValue), onInput (UpdateInt field obj) ] []
        , button [ class "col col-1", onClick (DecrementInt field obj) ] [ text "-" ]
        , button [ class "col col-1", onClick (IncrementInt field obj) ] [ text "+" ]
        ]

displayFieldFloat : GameObject -> FieldFloat -> Html Msg
displayFieldFloat obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-5 m0 right-align pr1 disableUserSelect" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-5", value (getValueString field.pValue), onInput (UpdateFloat field obj) ] []
        , button [ class "col col-1", onClick (DecrementFloat field obj) ] [ text "-" ]
        , button [ class "col col-1", onClick (IncrementFloat field obj) ] [ text "+" ]
        ]

displayFieldBoolean : GameObject -> FieldBool -> Html Msg
displayFieldBoolean obj field =
    let checkedVal = case field.pValue of
        Nothing -> False
        Just val -> val
    in
    div [ class "clearfix" ]
        [ h5 [ class "col col-5 m0 right-align pr1 disableUserSelect" ] [ text (field.pName ++ ": ") ]
        , input [ type_ "checkbox", checked checkedVal, onClick (ToggleBool field obj) ] []
        ]

getValueString : Maybe a -> String
getValueString maybeVal =
    case maybeVal of
        Nothing -> ""
        Just val -> StringExtra.unquote (toString val)

tempFunc : GameObject -> Bool
tempFunc obj =
    True

filterAddedModels : List GameModel -> GameObject -> Bool
filterAddedModels models obj =
    List.all (\n -> not(n.name == obj.name && n.path == obj.path)) models