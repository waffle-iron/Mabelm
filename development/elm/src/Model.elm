module Model exposing (..)

type alias Model =
    { isCompiling :Bool
    , isRendering :Bool
    , isUpdating :Bool
    , modelPackages :Maybe (List GamePackage)
    , systemPackages :Maybe (List GamePackage)
    , spritePackages :Maybe (List GamePackage)
    , currentID :Int
    }

model : Model
model = 
    { isCompiling = False
    , isRendering = False
    , isUpdating = False
    , modelPackages = Nothing
    , systemPackages = Nothing
    , spritePackages = Nothing
    , currentID = 0
    }

type alias GamePackage =
    { objects :List GameObject
    , path :String
    , isVisible :Bool
    }

type alias GameObject =
    { name :String
    , path :String
    , id :Int
    , variables : GameObjectAttributes
    , isActive :Bool
    }

type alias GameObjectAttributes =
    { integers : Maybe (List FieldInteger)
    , strings : Maybe (List FieldString)
    , floats : Maybe (List FieldFloat)
    , booleans : Maybe (List FieldBool)
    }

type alias FieldInteger =
    { pName :String
    , pValue :Maybe Int
    }

type alias FieldFloat =
    { pName :String
    , pValue :Maybe Float
    }

type alias FieldString =
    { pName :String
    , pValue :Maybe String
    }

type alias FieldBool =
    { pName :String
    , pValue :Maybe Bool
    }

type alias Field a =
    { pName :String
    , pValue :Maybe a
    }