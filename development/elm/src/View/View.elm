module View.View exposing (..)

import Html exposing (Html, text, div, ul, li, span)
import Html.Attributes exposing (class, id)
import Material.Icons.Action exposing (account_balance)
import Color exposing (Color)
import Svg exposing (Svg)

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
    div [ id "toolbar" ]
        [ span [ class "toolbar_button" ]
            [ toolbarButton model
            ]
        ]

gameWindow : Model -> Html Msg
gameWindow model =
    div [ id "gameWindow" ]
        []

toolbarButton : Model -> Svg Msg
toolbarButton model =
    account_balance Color.charcoal 60