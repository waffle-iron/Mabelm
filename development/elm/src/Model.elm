module Model exposing (..)

type alias Model =
    { isCompiling :Bool
    , isRendering :Bool
    , isUpdating :Bool
    }

model : Model
model = 
    { isCompiling = False
    , isRendering = False
    , isUpdating = False
    }
