module View.View exposing (..)

import Html exposing (Html, div, h2, h5, text)
import Html.Attributes exposing (id, class)

import Messages exposing (Msg(..))
import Model exposing (..)
import View.Toolbar.ViewToolbar as ViewToolbar
import View.Toolbar.ViewAvailableObjects exposing (viewAvailableObjects)
import View.Toolbar.ViewActiveSystems exposing (viewActiveSystems)
import View.GameWindow.ViewGameWindow exposing (gameWindow)
import Html.Events exposing (onClick, onInput)

view : Model -> Html Msg
view model =
    div []
        [ ViewToolbar.toolbar model
        , gameWindow model
        , div [ id "gamePackageContainers", class "" ]
            [ viewActiveSystems model
            , viewAvailableObjects model
            ]
        ]