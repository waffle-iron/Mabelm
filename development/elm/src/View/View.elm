module View.View exposing (..)

import Html exposing (Html, div, h2, h3, h4, text, span, form, input, button, select, option)
import Html.Attributes exposing (id, class, disabled, placeholder, type_, checked)
import Html.Events exposing (onClick)
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
                [ displayGameObjectField obj.variables.strings displayGameObjectFieldString
                , displayGameObjectField obj.variables.integers displayGameObjectFieldInteger
                , displayGameObjectField obj.variables.floats displayGameObjectFieldFloat
                , displayGameObjectField obj.variables.booleans displayGameObjectFieldBool
                ]
            else text ""
        ]

displayGameObjectField : Maybe (List a) -> (a -> Html Msg) -> Html Msg
displayGameObjectField maybeFields displayFunc =
    case maybeFields of
        Nothing -> text ""
        Just list -> div [] (List.map displayFunc list)








displayGameObjectFieldString : FieldString -> Html Msg
displayGameObjectFieldString obj =
    div []
        [ span [] [ text (obj.pName ++ ": ") ]
        , input [ placeholder (getValueString obj.pValue) ] []
        ]

displayGameObjectFieldInteger : FieldInteger -> Html Msg
displayGameObjectFieldInteger obj =
    div []
        [ span [] [ text (obj.pName ++ ": ") ]
        , div []
            [ input [ placeholder (getValueString obj.pValue) ] []
            , button [] [ text "-" ]
            , button [] [ text "+" ]
            ]
        ]

displayGameObjectFieldFloat : FieldFloat -> Html Msg
displayGameObjectFieldFloat obj =
    div []
        [ span [] [ text (obj.pName ++ ": ") ]
        , div []
            [ input [ placeholder (getValueString obj.pValue) ] []
            , button [] [ text "-" ]
            , button [] [ text "+" ]
            ]
        ]

displayGameObjectFieldBool : FieldBool -> Html Msg
displayGameObjectFieldBool obj =
    let checkedVal = case obj.pValue of
        Nothing -> False
        Just val -> val
    in
    div []
        [ span [] [ text (obj.pName ++ ": ") ]
        , input [ type_ "checkbox", checked checkedVal ] []
        ]

getValueString : Maybe a -> String
getValueString maybeVal =
    case maybeVal of
        Nothing -> ""
        Just val -> StringExtra.unquote (toString val)