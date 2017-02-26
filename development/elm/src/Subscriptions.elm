port module Subscriptions exposing (..)

import Model exposing (Model)
import Messages exposing (Msg(..))

port compileCompleted : (String -> msg) -> Sub msg
port loadData : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ compileCompleted CompileCompleted
        , loadData LoadCompleted
        ]