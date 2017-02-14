module Model exposing (..)

type alias Model =
    { isCompiling :Bool
    }

model : Model
model = 
    { isCompiling = False
    }
