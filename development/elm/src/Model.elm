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
    , runningSystems : List GameObject
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
    , showsAvailableObjects = True
    , showsRunningSystems = True
    , runningSystems = []
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