module Model exposing (Model, model, GameObject, GameObjectList)

type alias Model =
    { isCompiling :Bool
    , isRendering :Bool
    , isUpdating :Bool
    , gameObjects :Maybe (List GameObjectList)
    }

model : Model
model = 
    { isCompiling = False
    , isRendering = False
    , isUpdating = False
    , gameObjects = Nothing
    }

type alias GameObjectList =
    { objects :List GameObject
    , path :String
    , isVisible :Bool
    }

type alias GameObject =
    { name :String
    , path :String
    }