module View.View exposing (..)

import Html exposing (Html, div, h2, h3, h4, text, span)
import Html.Attributes exposing (id, class)

import Messages exposing (Msg(..))
import Model exposing (Model, GameObject, GameObjectList)
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
    case model.gameObjects of
        Nothing ->
            text ""
        Just objects ->
            div [ id "gameSystemObjects" ]
                [ h2 [] [ text "Objects" ]
                , div [] (List.map displayList objects)
                ]

displayList : GameObjectList -> Html Msg
displayList list =
    div [ class "gameObjectChildren" ]
        [ span [] [ text list.path]
        , div [] (List.map displayGameObject list.objects)
        ]

displayGameObject : GameObject -> Html Msg
displayGameObject obj =
    div [ class "gameObject" ]
        [ h4 [] [ text obj.name ]
        ]