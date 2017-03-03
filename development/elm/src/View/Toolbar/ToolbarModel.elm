module View.Toolbar.ToolbarModel exposing (displayGamePackage)

import Html exposing (Html, div, h2, h3, h4, h5, text, p, input, button)
import Html.Attributes exposing (id, class, type_, checked, value)
import Html.Events exposing (onClick, onInput)
import String.Extra as StringExtra

import Messages exposing (Msg(..))
import Model exposing (..)

displayGamePackage : String -> (Maybe (List GamePackage)) -> Html Msg
displayGamePackage title maybePackage =
    case maybePackage of
        Nothing ->
            text ""
        Just objects ->
            div []
                [ h3 [] [ text title ]
                , div [] (List.map displayListOfGameObjects objects)
                ]

displayListOfGameObjects : GamePackage -> Html Msg
displayListOfGameObjects list =
    div [ class "gameObjectChildren" ]
        [ h4 [ class "disableUserSelect m0 p1", onClick (ToggleSystem list) ] [ text list.path]
        , if list.isVisible
            then div [] (List.map displayGameObject list.objects)
            else text ""
        ]

displayGameObject : GameObject -> Html Msg
displayGameObject obj =
    div [ class "gameObject border p1" ]
        [ h5 [ class "disableUserSelect m0 mb1 mt1", onClick (ToggleObject obj) ] [ text obj.name ]
        , if obj.isActive 
            then div []
                [ displayFieldList obj.variables.strings (displayFieldString obj)
                , displayFieldList obj.variables.integers (displayFieldInteger obj)
                , displayFieldList obj.variables.floats (displayFieldFloat obj)
                , displayFieldList obj.variables.booleans (displayFieldBoolean obj)
                , button [ class "pl1 pr1", onClick (BuildObject obj) ] [ text "Build" ]
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
        [ h5 [ class "col col-3 m0" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-9", value (getValueString field.pValue), onInput (UpdateStr field obj) ] []
        ]

displayFieldInteger : GameObject -> FieldInteger -> Html Msg
displayFieldInteger obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-3 m0" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-7", value (getValueString field.pValue), onInput (UpdateInt field obj) ] []
        , button [ class "col col-1", onClick (DecrementInt field obj) ] [ text "-" ]
        , button [ class "col col-1", onClick (IncrementInt field obj) ] [ text "+" ]
        ]

displayFieldFloat : GameObject -> FieldFloat -> Html Msg
displayFieldFloat obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-3 m0" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-7", value (getValueString field.pValue), onInput (UpdateFloat field obj) ] []
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
        [ h5 [ class "col col-3 m0" ] [ text (field.pName ++ ": ") ]
        , input [ type_ "checkbox", checked checkedVal, onClick (ToggleBool field obj) ] []
        ]

getValueString : Maybe a -> String
getValueString maybeVal =
    case maybeVal of
        Nothing -> ""
        Just val -> StringExtra.unquote (toString val)