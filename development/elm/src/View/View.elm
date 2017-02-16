module View.View exposing (..)

import Html exposing (Html, div, h3, h4, text)
import Html.Attributes exposing (id)

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
    div []
        [ h4 [] [ text obj.name ]
        , text obj.path
        , div [] (drawChildren obj.children)
        ]

drawChildren : (Maybe GameObjectChildren) -> List (Html Msg)
drawChildren maybeChildren =
    case maybeChildren of
        Nothing ->
            [text ""]
        Just (children) ->
            (List.map displayGameObject (extractChildren children))

extractChildren : GameObjectChildren -> (List GameObject)
extractChildren (GameObjectChildren children) =
    children