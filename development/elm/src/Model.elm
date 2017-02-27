module Model exposing (..)

type alias Model =
    { isCompiling :Bool
    , isRendering :Bool
    , isUpdating :Bool
    , gameObjects :Maybe (List GameObjectList)
    , currentID :Int
    }

model : Model
model = 
    { isCompiling = False
    , isRendering = False
    , isUpdating = False
    , gameObjects = Nothing
    , currentID = 0
    }

type alias GameObjectList =
    { objects :List GameObject
    , path :String
    , isVisible :Bool
    }

type alias GameObject =
    { name :String
    , path :String
    , id :Int
    , variables : GameObjectAttributes
    }

type alias GameObjectAttributes =
    { integers : Maybe (List FieldInteger)
    , strings : Maybe (List FieldString)
    , floats : Maybe (List FieldFloat)
    , booleans : Maybe (List FieldBool)
    }

type alias FieldInteger =
    { name :String
    , value :Int
    }

type alias FieldFloat =
    { name :String
    , value :Float
    }

type alias FieldString =
    { name :String
    , value :String
    }

type alias FieldBool =
    { name :String
    , value :Bool
    }