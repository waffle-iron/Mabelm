module View.Toolbar.ToolbarModel exposing (gameSystemObjects)

import Html exposing (Html, div, h2, h3, h4, h5, text, p, input, button)
import Html.Attributes exposing (id, class, type_, checked, value)
import Html.Events exposing (onClick, onInput)
import String.Extra as StringExtra

import Messages exposing (Msg(..))
import Model exposing (..)


gameSystemObjects : Model -> Html Msg
gameSystemObjects model =
    case model.modelPackages of
        Nothing ->
            text ""
        Just objects ->
            div [ id "gameSystemObjects", class "p1" ]
                [ h3 [] [ text "Models" ]
                , div [] (List.map displayList objects)
                ]

displayList : GamePackage -> Html Msg
displayList list =
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
                [ displayGameObjectField obj.variables.strings (displayGameObjectFieldString obj)
                , displayGameObjectField obj.variables.integers (displayGameObjectFieldInteger obj)
                , displayGameObjectField obj.variables.floats (displayGameObjectFieldFloat obj)
                , displayGameObjectField obj.variables.booleans (displayGameObjectFieldBool obj)
                , button [ class "pl1 pr1", onClick (BuildObject obj) ] [ text "Build" ]
                ]
            else text ""
        ]

displayGameObjectField : Maybe (List a) -> (a -> Html Msg) -> Html Msg
displayGameObjectField maybeFields displayFunc =
    case maybeFields of
        Nothing -> text ""
        Just list -> div [] (List.map displayFunc list)

displayGameObjectFieldString : GameObject -> FieldString -> Html Msg
displayGameObjectFieldString obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-3 m0" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-9", value (getValueString field.pValue), onInput (UpdateStr field obj) ] []
        ]

displayGameObjectFieldInteger : GameObject -> FieldInteger -> Html Msg
displayGameObjectFieldInteger obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-3 m0" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-7", value (getValueString field.pValue), onInput (UpdateInt field obj) ] []
        , button [ class "col col-1", onClick (DecrementInt field obj) ] [ text "-" ]
        , button [ class "col col-1", onClick (IncrementInt field obj) ] [ text "+" ]
        ]

displayGameObjectFieldFloat : GameObject -> FieldFloat -> Html Msg
displayGameObjectFieldFloat obj field =
    div [ class "clearfix" ]
        [ h5 [ class "col col-3 m0" ] [ text (field.pName ++ ": ") ]
        , input [ class "col col-7", value (getValueString field.pValue), onInput (UpdateFloat field obj) ] []
        , button [ class "col col-1", onClick (DecrementFloat field obj) ] [ text "-" ]
        , button [ class "col col-1", onClick (IncrementFloat field obj) ] [ text "+" ]
        ]

displayGameObjectFieldBool : GameObject -> FieldBool -> Html Msg
displayGameObjectFieldBool obj field =
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