module View.GameWindow.ViewGameWindow exposing (gameWindow)

import Html exposing (Html, text, div, ul, li, span)
import Html.Attributes exposing (class, id)

import Messages exposing (Msg(..))
import Model exposing (Model)

gameWindow : Model -> Html Msg
gameWindow model =
    div [ id "gameWindow" ]
        []