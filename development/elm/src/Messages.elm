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
    | TogglePackageGroup GamePackageGroup
    | ToggleObject GameObject
    | ToggleAvailableObjects
    | ToggleRunningSystems
    | IncrementInt FieldInteger GameObject
    | DecrementInt FieldInteger GameObject
    | IncrementFloat FieldFloat GameObject
    | DecrementFloat FieldFloat GameObject
    | ToggleBool FieldBool GameObject
    | UpdateStr FieldString GameObject String
    | UpdateInt FieldInteger GameObject String
    | UpdateFloat FieldFloat GameObject String
    | BuildObject GameObject
    | AddSystem GameObject
    | AddSprite GameObject
    | AddModel GameObject