port module Update.Update exposing (update)

import Messages exposing (Msg(..))
import Model as Model exposing (Model)

port yeah : String -> Cmd msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ------------------------------------------------------------
        NoOp ->
            (model, Cmd.none)
        CompileGame ->
            ({model
                | isCompiling = True
            }, yeah "game")
        CompileCompleted str ->
            ({model
                | isCompiling = False
            }, Cmd.none)