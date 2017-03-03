module View.View exposing (..)

import Html exposing (Html, div, h2, text)
import Html.Attributes exposing (id, class)

import Messages exposing (Msg(..))
import Model exposing (..)
import View.Toolbar.ViewToolbar as ViewToolbar
import View.Toolbar.AvailableObjects exposing (availableObjects)
import View.GameWindow.ViewGameWindow exposing (gameWindow)

view : Model -> Html Msg
view model =
    div []
        [ ViewToolbar.toolbar model
        , gameWindow model
        , div [ id "gamePackageContainers", class "" ]
            [ div [ class "border p1" ]
                [ h2 [ class "m0" ]
                    [ text "Running Systems"
                    ]
                ]
            , availableObjects model
            ]
        ]