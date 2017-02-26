port module Main exposing (init)

import Html

import View.View exposing (view)
import Model exposing (Model, model)
import Update.Update exposing (update)
import Messages exposing (Msg)
import Subscriptions exposing (subscriptions)

port requestData : String -> Cmd msg

-- INIT
init : ( Model, Cmd Msg )
init = 
    ( model, requestData "")

-- MAIN
main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }