port module Update.Update exposing (update)

import Messages exposing (Msg(..))
import Model as Model exposing (Model)

port startCompile : String -> Cmd msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ------------------------------------------------------------
        NoOp ->
            (model, Cmd.none)
        CompileGame ->
            ({model
                | isCompiling = True
            }, startCompile "")
        CompileCompleted str ->
            ({model
                | isCompiling = False
            }, Cmd.none)
        ToggleButtonRender ->
            ({model
                | isRendering = not model.isRendering
            }, Cmd.none)
        ToggleButtonUpdate ->
            ({model
                | isUpdating = not model.isUpdating
            }, Cmd.none)