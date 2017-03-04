{-
    Mabelm 
    Copyright (C) 2017  Jeremy Meltingtallow

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-}

module Model exposing (..)

model : Model
model = 
    { isCompiling = False
    , isRendering = False
    , isUpdating = False
    , modelPackages = Nothing
    , systemPackages = Nothing
    , spritePackages = Nothing
    , currentID = 0
    , showsAvailableObjects = True
    , showsRunningSystems = True
    , runningSystems = []
    , root = rootSprite
    , nextID = 1
    , activeSprite = Nothing
    }

rootSprite : GameSprite
rootSprite =
    { name = "Sprite"
    , path = "cranberry.sprite"
    , id = 0
    , variables =
        { integers = Nothing
        , strings = Nothing
        , floats = Nothing
        , booleans = Nothing
        }
    , uniqueName = Just "root"
    , isActive = False
    , models = []
    , children = (GameSpriteChildren [])
    }

type alias Model =
    { isCompiling :Bool
    , isRendering :Bool
    , isUpdating :Bool
    , modelPackages :Maybe GamePackageGroup
    , systemPackages :Maybe GamePackageGroup
    , spritePackages :Maybe GamePackageGroup
    , currentID :Int
    , showsAvailableObjects :Bool
    , showsRunningSystems :Bool
    , runningSystems :List GameObject
    , root : GameSprite
    , nextID :Int
    , activeSprite : Maybe GameSprite
    }

type alias GamePackageGroup =
    { packages :List GamePackage
    , isVisible :Bool
    , packageType :GameObjectType
    }

type alias GamePackage =
    { objects :List GameObject
    , path :String
    , isVisible :Bool
    , packageType :GameObjectType
    }

type alias GameObject =
    { name :String
    , path :String
    , id :Int
    , variables : GameObjectAttributes
    , uniqueName : Maybe String
    , isActive :Bool
    , gameObjectType :GameObjectType
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

type alias AllPackages =
    { modelPackages : (List GameObject)
    , systemPackages : (List GameObject)
    , spritePackages : (List GameObject)
    }

type GameObjectType
    = Sprite
    | System
    | Model_

type GameSpriteChildren = GameSpriteChildren (List GameSprite)

type alias GameSprite =
    { name :String
    , path :String
    , id :Int
    , variables :GameObjectAttributes
    , uniqueName :Maybe String
    , isActive :Bool
    , models :List GameModel
    , children :GameSpriteChildren
    }

type alias GameModel =
    { name :String
    , path :String
    , id :Int
    , variables :GameObjectAttributes
    , uniqueName :Maybe String
    , isActive :Bool
    , systems :List GameSystem
    }

type RunningModels = RunningModels (List GameModel)

type alias GameSystem =
    { name :String
    , path :String
    , id :Int
    , variables :GameObjectAttributes
    , uniqueName :Maybe String
    , isActive :Bool
    , models :RunningModels
    }

createGameSprite : Int -> GameObject -> GameSprite
createGameSprite nextID obj =
    { name = obj.name
    , path = obj.path
    , id = nextID
    , variables = obj.variables
    , uniqueName = obj.uniqueName
    , isActive = False
    , models = []
    , children = (GameSpriteChildren [])
    }

createGameModel : Int -> GameObject -> GameModel
createGameModel nextID obj =
    { name = obj.name
    , path = obj.path
    , id = nextID
    , variables = obj.variables
    , uniqueName = obj.uniqueName
    , isActive = False
    , systems = []
    }