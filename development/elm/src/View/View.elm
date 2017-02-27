module View.View exposing (..)

import Html exposing (Html, div, h2, h3, h4, text, span)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

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
    div [ class "gameObject", onClick (ToggleObject obj) ]
        [ h4 [ class "disableUserSelect" ] [ text obj.name ]
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
        [ span [] [ text obj.pName]
        , case obj.pValue of
            Nothing -> span [] [ text "" ]
            Just val -> span [] [ text val ]
        ]

displayGameObjectFieldInteger : FieldInteger -> Html Msg
displayGameObjectFieldInteger obj =
    div []
        [ span [] [ text obj.pName]
        , case obj.pValue of
            Nothing -> span [] [ text "" ]
            Just val -> span [] [ text (toString val) ]
        ]

displayGameObjectFieldFloat : FieldFloat -> Html Msg
displayGameObjectFieldFloat obj =
    div []
        [ span [] [ text obj.pName]
        , case obj.pValue of
            Nothing -> span [] [ text "" ]
            Just val -> span [] [ text (toString val) ]
        ]

displayGameObjectFieldBool : FieldBool -> Html Msg
displayGameObjectFieldBool obj =
    div []
        [ span [] [ text obj.pName]
        , case obj.pValue of
            Nothing -> span [] [ text "" ]
            Just val -> span [] [ text (toString val) ]
        ]