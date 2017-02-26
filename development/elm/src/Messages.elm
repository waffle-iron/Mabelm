module Messages exposing (Msg(..))

type Msg
    = NoOp
    | CompileGame
    | CompileCompleted String
    | LoadCompleted String
    | ToggleButtonRender
    | ToggleButtonUpdate