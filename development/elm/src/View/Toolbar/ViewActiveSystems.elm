module View.Toolbar.ViewActiveSystems exposing (viewActiveSystems)

import Html exposing (Html, div, h2, h5, text)
import Html.Attributes exposing (id, class)
import Html.Events exposing (onClick)

import Messages exposing (Msg(..))
import Model exposing (..)

viewActiveSystems : Model -> Html Msg
viewActiveSystems model =
    div [ class "border p1" ]
        [ h2 [ class "m0 disableUserSelect", onClick ToggleRunningSystems ]
            [ text "Running Systems"
            ]
        , if model.showsRunningSystems 
            then
                div []
                    (List.map viewActiveSystem model.runningSystems)
            else 
                text ""
        ]

viewActiveSystem : GameObject -> Html Msg
viewActiveSystem obj =
    div [ class "gameObject border p1" ]
        [ h5 [ class "disableUserSelect m0 mb1 mt1"]
            [ text obj.name ]
        ]