module View.View exposing (..)

import Html exposing (Html, div, h4, text)
import Html.Attributes exposing (id)
import Color as Color
import Svg exposing (Svg)

import Messages exposing (Msg(..))
import Model exposing (Model)
import View.Toolbar.ViewToolbar exposing (toolbar)

type alias MaterialIcon = (Color.Color -> Int -> Svg Msg)
type alias ClassName = String

view : Model -> Html Msg
view model =
    div []
        [ toolbar model
        , gameWindow model
        , gameSystemObjects model
        ]

gameSystemObjects : Model -> Html Msg
gameSystemObjects model =
    div [ id "gameSystemObjects" ]
        [ windowToolbarHeader "Systems Objects"
        ]

windowToolbarHeader : String -> Html Msg
windowToolbarHeader title =
    div []
        [ h4 []
            [ text title ]
        ]

gameWindow : Model -> Html Msg
gameWindow model =
    div [ id "gameWindow" ]
        []