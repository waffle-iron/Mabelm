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

type GameObject
    = GameModel GameObjectData
    | GameSystem GameObjectData
    | GameSprite GameObjectData

type alias FieldString =
    { name :String
    , value :String
    }

type alias FieldFloat =
    { name :String
    , value :Float
    }

type alias FieldInt =
    { name :String
    , value :Int
    }

type alias FieldBool =
    { name :String
    , value :Bool
    }

type Asset
    = Image FieldAsset
    | Sound FieldAsset
    | Blob FieldAsset
    | Font FieldAsset
    | Video FieldAsset

type alias FieldAsset =
    { name :String
    , path :String
    }

type alias GameObjectData =
    { name :String
    , package :String
    , stringFields :Maybe List FieldString
    , floatFields :Maybe List FieldFloat
    , intFields :Maybe List FieldInt
    , boolFields :Maybe List FieldBool
    , assets :Maybe List Asset
    }





--------------------------
-- fields Assets
--------------------------
-- Image
-- Sound
-- Blob
-- Font
-- Video
--------------------------
-- fields Primitive
--------------------------
-- String
-- Float
-- Int
-- Bool