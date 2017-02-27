module View.View exposing (..)

import Html exposing (Html, div, h2, h3, h4, text, span, form, input, button, select, option)
import Html.Attributes exposing (id, class, disabled, placeholder, type_, checked, value)
import Html.Events exposing (onClick, onInput)
import String.Extra as StringExtra

import Messages exposing (Msg(..))
import Model exposing (..)
import View.Toolbar.ViewToolbar exposing (toolbar)
import View.GameWindow.ViewGameWindow exposing (gameWindow)

view : Model -> Html Msg
view model =
    div []
        [ toolbar model
        , gameWindow model
        , gameSystemObjects model
        ]

gameSystemObjects : Model -> Html Msg
gameSystemObjects model =
    case model.systemPackages of
        Nothing ->
            text ""
        Just objects ->
            div [ id "gameSystemObjects" ]
                [ h2 [] [ text "Objects" ]
                , div [] (List.map displayList objects)
                ]

displayList : GamePackage -> Html Msg
displayList list =
    div [ class "gameObjectChildren" ]
        [ span [ class "disableUserSelect", onClick (ToggleSystem list) ] [ text list.path]
        , if list.isVisible
            then div [] (List.map displayGameObject list.objects)
            else text ""
        ]

displayGameObject : GameObject -> Html Msg
displayGameObject obj =
    div [ class "gameObject" ]
        [ h4 [ class "disableUserSelect", onClick (ToggleObject obj) ] [ text obj.name ]
        , if obj.isActive 
            then div []
                [ displayGameObjectField obj.variables.strings (displayGameObjectFieldString obj)
                , displayGameObjectField obj.variables.integers (displayGameObjectFieldInteger obj)
                , displayGameObjectField obj.variables.floats (displayGameObjectFieldFloat obj)
                , displayGameObjectField obj.variables.booleans (displayGameObjectFieldBool obj)
                , button [ onClick (BuildObject obj) ] [ text "Build" ]
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
    div []
        [ span [] [ text (field.pName ++ ": ") ]
        , input [ value (getValueString field.pValue), onInput (UpdateStr field obj) ] []
        ]

displayGameObjectFieldInteger : GameObject -> FieldInteger -> Html Msg
displayGameObjectFieldInteger obj field =
    div []
        [ span [] [ text (field.pName ++ ": ") ]
        , div []
            [ input [ value (getValueString field.pValue), onInput (UpdateInt field obj) ] []
            , button [ onClick (DecrementInt field obj) ] [ text "-" ]
            , button [ onClick (IncrementInt field obj) ] [ text "+" ]
            ]
        ]

displayGameObjectFieldFloat : GameObject -> FieldFloat -> Html Msg
displayGameObjectFieldFloat obj field =
    div []
        [ span [] [ text (field.pName ++ ": ") ]
        , div []
            [ input [ value (getValueString field.pValue), onInput (UpdateFloat field obj) ] []
            , button [ onClick (DecrementFloat field obj) ] [ text "-" ]
            , button [ onClick (IncrementFloat field obj) ] [ text "+" ]
            ]
        ]

displayGameObjectFieldBool : GameObject -> FieldBool -> Html Msg
displayGameObjectFieldBool obj field =
    let checkedVal = case field.pValue of
        Nothing -> False
        Just val -> val
    in
    div []
        [ span [] [ text (field.pName ++ ": ") ]
        , input [ type_ "checkbox", checked checkedVal, onClick (ToggleBool field obj) ] []
        ]

getValueString : Maybe a -> String
getValueString maybeVal =
    case maybeVal of
        Nothing -> ""
        Just val -> StringExtra.unquote (toString val)