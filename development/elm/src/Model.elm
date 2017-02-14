module Model exposing (..)

type alias Model =
    { isCompiling :Bool
    , isRendering :Bool
    , isUpdating :Bool
    , systemPackages :Maybe (List SystemPackage)
    , modelPackages :Maybe (List ModelPackage)
    , spritePackages :Maybe (List SpritePackage)
    }

model : Model
model = 
    { isCompiling = False
    , isRendering = False
    , isUpdating = False
    , systemPackages = Nothing
    , modelPackages = Nothing
    , spritePackages = Nothing
    }

type alias GameModel = GameObjectData
type alias GameSystem = GameObjectData
type alias GameSprite = GameObjectData
--
type alias SystemPackage =
    { gameSystems :Maybe List GameSystem
    , subPackages :Maybe List SystemPackageChild
    }
type SystemPackageChild = SystemPackageChild SystemPackage
--
type alias ModelPackage =
    { gameModels :Maybe List GameModel
    , subPackages :Maybe List ModelPackageChild
    }
type ModelPackageChild = ModelPackageChild ModelPackage
--
type alias SpritePackage =
    { gameSprites :Maybe List GameSprite
    , subPackages :Maybe List SpritePackageChild
    }
type SpritePackageChild = SpritePackageChild SpritePackage
--

type alias FieldString =
    { name :String
    , value :String
    }
--
type alias FieldFloat =
    { name :String
    , value :Float
    }
--
type alias FieldInt =
    { name :String
    , value :Int
    }
--
type alias FieldBool =
    { name :String
    , value :Bool
    }
--
type Asset
    = Image FieldAsset
    | Sound FieldAsset
    | Blob FieldAsset
    | Font FieldAsset
    | Video FieldAsset
--
type alias FieldAsset =
    { name :String
    , path :String
    }
--
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