module Messages exposing (Msg(..))

import Model exposing (GameObjectList)

type Msg
    = NoOp
    | CompileGame
    | CompileCompleted String
    | LoadCompleted String
    | ToggleButtonRender
    | ToggleButtonUpdate
    | ToggleSystem GameObjectList