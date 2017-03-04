module View.View exposing (..)

import Html exposing (Html, div, h2, h5, text)
import Html.Attributes exposing (id, class)

import Messages exposing (Msg(..))
import Model exposing (..)
import View.Toolbar.ViewToolbar as ViewToolbar
import View.Toolbar.AvailableObjects exposing (availableObjects)
import View.GameWindow.ViewGameWindow exposing (gameWindow)
import Html.Events exposing (onClick, onInput)

view : Model -> Html Msg
view model =
    div []
        [ ViewToolbar.toolbar model
        , gameWindow model
        , div [ id "gamePackageContainers", class "" ]
            [ div [ class "border p1" ]
                [ h2 [ class "m0 disableUserSelect", onClick ToggleRunningSystems ]
                    [ text "Running Systems"
                    ]
                , if model.showsRunningSystems then viewSystemsAll model.runningSystems else text ""
                ]
            , availableObjects model
            ]
        ]


viewSystemsAll : List GameObject -> Html Msg
viewSystemsAll systems =
    div []
        (List.map viewSystem systems)

viewSystem : GameObject -> Html Msg
viewSystem obj =
    div [ class "gameObject border p1" ]
        [ h5 [ class "disableUserSelect m0 mb1 mt1"]
            [ text obj.name ]
        ]