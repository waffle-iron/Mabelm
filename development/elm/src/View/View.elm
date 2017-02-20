module View.View exposing (..)

import Html exposing (Html, div, h3, h4, text)
import Html.Attributes exposing (id, class)

import List.Extra as ListExtra

import Messages exposing (Msg(..))
import Model exposing (Model, GameObject)
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
            let listPathLists = groupListsByPackage objects in

            div [ id "gameSystemObjects" ]
                [ h3 [] [ text "Objects" ]
                , div [] (List.map displayList listPathLists)
                ]

displayList : List GameObject -> Html Msg
displayList list =
    div [ class "gameObjectChildren" ] (List.map displayGameObject list)

displayGameObject : GameObject -> Html Msg
displayGameObject obj =
    div [ class "gameObject" ]
        [ h4 [] [ text obj.name ]
        , text obj.path
        ]

groupListsByPackage : List GameObject -> List (List GameObject)
groupListsByPackage list =
    let sortedList = sortList list in 
    ListExtra.groupWhile (\x y -> x.path == y.path) sortedList

sortList : List GameObject -> List GameObject
sortList list =
    List.sortBy .path list