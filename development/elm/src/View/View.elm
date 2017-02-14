module View.View exposing (..)

import Html exposing (Html, text, div, ul, li, span)
import Html.Attributes exposing (class, id)


import Messages exposing (Msg(..))
import Model exposing (Model)

view : Model -> Html Msg
view model =
    div []
        [ toolbar model
        , gameWindow model
        ]

toolbar : Model -> Html Msg
toolbar model =
    div [ class "toolbar" ]
        [ toolbar__button model
        , toolbar__button model
        , toolbar__button model
        ]

toolbar__button : Model -> Html Msg
toolbar__button model =
    div [ class "toolbar__button" ]
        [
        ]




gameWindow : Model -> Html Msg
gameWindow model =
    div [ id "gameWindow" ]
        []