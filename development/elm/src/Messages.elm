module Messages exposing (Msg(..))

import Model exposing (..)

type Msg
    = NoOp
    | CompileGame
    | CompileCompleted String
    | LoadCompleted String
    | ToggleButtonRender
    | ToggleButtonUpdate
    | ToggleSystem GamePackage
    | ToggleObject GameObject
    | IncrementInt FieldInteger GameObject
    | DecrementInt FieldInteger GameObject
    | IncrementFloat FieldFloat GameObject
    | DecrementFloat FieldFloat GameObject
    | ToggleBool FieldBool GameObject
    | BuildObject GameObject