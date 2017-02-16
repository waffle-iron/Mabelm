module View.View exposing (..)

import Html exposing (Html, div, h3, h4, text)
import Html.Attributes exposing (id, class)

import Messages exposing (Msg(..))
import Model exposing (Model, GameObject, GameObjectChildren(GameObjectChildren))
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
                [ h3 [] [ text "Objects" ]
                , div [] (List.map displayGameObject objects)
                ]

displayGameObject : GameObject -> Html Msg
displayGameObject obj =
    let dChildren = case obj.children of
        Nothing -> 
            text ""
        Just children -> drawChildren children in

    div [ class "gameObject" ]
        [ h4 [] [ text obj.name ]
        , text obj.path
        , dChildren
        ]

drawChildren : GameObjectChildren -> Html Msg
drawChildren (GameObjectChildren children) =
    div [ class "gameObjectChildren" ]
        (List.map displayGameObject children)