module View.View exposing (..)

import Html exposing (Html, text, div, ul, li, span)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)

import Messages exposing (Msg(..))
import Model exposing (Model)

view : Model -> Html Msg
view model =
    div [ class "clearfix" ]
        [ viewHeader model
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    div [ class "col col-12 border" ]
        [ compileButton model
        ]

compileButton : Model -> Html Msg
compileButton model =
    if model.isCompiling then
        span [ class "inline-block p1 border" ] [ text "compiling right now" ]
    else
        span [ class "inline-block p1 border", onClick CompileGame ] [ text "start compile" ]
