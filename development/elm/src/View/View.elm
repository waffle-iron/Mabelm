module View.View exposing (..)

import Html exposing (Html, text, div, ul, li, span)
import Html.Attributes exposing (class, id)
import Material.Icons.Action exposing (build)
import Color as Color
import Svg exposing (Svg)


import Messages exposing (Msg(..))
import Model exposing (Model)

type alias MaterialIcon = (Color.Color -> Int -> Svg Msg)

view : Model -> Html Msg
view model =
    div []
        [ toolbar model
        , gameWindow model
        ]

toolbar : Model -> Html Msg
toolbar model =
    div [ class "toolbar" ]
        [ toolbar__button model build (Color.rgb 200 200 200) 50
        , toolbar__button model build (Color.rgb 200 200 200) 50
        , toolbar__button model build (Color.rgb 200 200 200) 50
        ]

toolbar__button : Model -> MaterialIcon -> Color.Color -> Int -> Html Msg
toolbar__button model icon color size =
    div [ class "toolbar__button" ]
        [ icon color size
        ]




gameWindow : Model -> Html Msg
gameWindow model =
    div [ id "gameWindow" ]
        []