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
    , activeSprite = Just heavySprite
    }


heavySprite : GameSprite
heavySprite =
    { name = "HeavySprite"
    , path = "cranberry.sprite"
    , id = 32423948
    , constructorVariables =
        { integers =
            Just
                [ { pName = "weight"
                  , pValue = Just 3948
                  }
                ]
        , strings =
            Just
                [ { pName = "hippoID"
                  , pValue = Just "Dr. Strange"
                  }
                ]
        , floats =
            Just
                [ { pName = "speed"
                  , pValue = Just 0.0237
                  }
                ]
        , booleans =
            Just
                [ { pName = "isHungry"
                  , pValue = Just True
                  }
                ]
        }
    , publicVariables = defaultSpritePublicValues
    , uniqueName = Just "heavyRoot"
    , isActive = True
    , isExpanded = True
    , isLocked = False
    , isVisible = True
    , isEditingTitle = False
    , models = [ gameModel ]
    , children = (GameSpriteChildren [])
    }


rootSprite : GameSprite
rootSprite =
    { name = "Sprite"
    , path = "cranberry.sprite"
    , id = 0
    , constructorVariables =
        { integers = Nothing
        , strings = Nothing
        , floats = Nothing
        , booleans = Nothing
        }
    , publicVariables = defaultSpritePublicValues
    , uniqueName = Just "asdasdsadasd"
    , isActive = False
    , isExpanded = True
    , isLocked = False
    , isVisible = True
    , isEditingTitle = False
    , models = [ gameModel, gameModel2 ]
    , children = (GameSpriteChildren [ rootSprite2, heavySprite ])
    }


rootSprite2 : GameSprite
rootSprite2 =
    { name = "Sprite"
    , path = "cranberry.sprite"
    , id = 2938
    , constructorVariables =
        { integers = Nothing
        , strings = Nothing
        , floats = Nothing
        , booleans = Nothing
        }
    , publicVariables = defaultSpritePublicValues
    , uniqueName = Just "yeahBoi"
    , isActive = False
    , isExpanded = True
    , isLocked = False
    , isVisible = True
    , isEditingTitle = False
    , models = [ gameModel2 ]
    , children = (GameSpriteChildren [])
    }


gameModel : GameModel
gameModel =
    { name = "ModelFlipBook"
    , path = "cranberry.model"
    , id = 300
    , constructorVariables =
        { integers =
            Just
                [ { pName = "columns"
                  , pValue = Just 2
                  }
                ]
        , strings = Nothing
        , floats =
            Just
                [ { pName = "speed"
                  , pValue = Just 273.34
                  }
                ]
        , booleans = Nothing
        }
    , uniqueName = Nothing
    , isActive = False
    , isEditingTitle = False
    , systems = []
    }


gameModel2 : GameModel
gameModel2 =
    { name = "ModelFlipBook22"
    , path = "cranberry.model"
    , id = 3340
    , constructorVariables =
        { integers =
            Just
                [ { pName = "columns"
                  , pValue = Just 23
                  }
                ]
        , strings = Nothing
        , floats =
            Just
                [ { pName = "speed"
                  , pValue = Just 353.3474
                  }
                ]
        , booleans = Nothing
        }
    , uniqueName = Nothing
    , isActive = False
    , isEditingTitle = False
    , systems = []
    }


type alias Model =
    { isCompiling : Bool
    , isRendering : Bool
    , isUpdating : Bool
    , modelPackages : Maybe GamePackageGroup
    , systemPackages : Maybe GamePackageGroup
    , spritePackages : Maybe GamePackageGroup
    , currentID : Int
    , showsAvailableObjects : Bool
    , showsRunningSystems : Bool
    , runningSystems : List GameObject
    , root : GameSprite
    , nextID : Int
    , activeSprite : Maybe GameSprite
    }


type alias GamePackageGroup =
    { packages : List GamePackage
    , isVisible : Bool
    , packageType : GameObjectType
    }


type alias GamePackage =
    { objects : List GameObject
    , path : String
    , isVisible : Bool
    , packageType : GameObjectType
    }


type alias GameObject =
    { name : String
    , path : String
    , id : Int
    , constructorVariables : GameObjectAttributes
    , isActive : Bool
    , gameObjectType : GameObjectType
    }


type alias GameObjectAttributes =
    { integers : Maybe (List FieldInteger)
    , strings : Maybe (List FieldString)
    , floats : Maybe (List FieldFloat)
    , booleans : Maybe (List FieldBool)
    }


type alias FieldInteger =
    { pName : String
    , pValue : Maybe Int
    }


type alias FieldFloat =
    { pName : String
    , pValue : Maybe Float
    }


type alias FieldString =
    { pName : String
    , pValue : Maybe String
    }


type alias FieldBool =
    { pName : String
    , pValue : Maybe Bool
    }


type alias Field a =
    { pName : String
    , pValue : Maybe a
    }


type alias AllPackages =
    { modelPackages : List GameObject
    , systemPackages : List GameObject
    , spritePackages : List GameObject
    }


type GameObjectType
    = Sprite
    | System
    | Model_


type GameSpriteChildren
    = GameSpriteChildren (List GameSprite)


type alias GameSprite =
    { name : String
    , path : String
    , id : Int
    , constructorVariables : GameObjectAttributes
    , publicVariables : GameObjectAttributes
    , uniqueName : Maybe String
    , isActive : Bool
    , isExpanded : Bool
    , isLocked : Bool
    , isVisible : Bool
    , isEditingTitle : Bool
    , models : List GameModel
    , children : GameSpriteChildren
    }


type alias GameModel =
    { name : String
    , path : String
    , id : Int
    , constructorVariables : GameObjectAttributes
    , uniqueName : Maybe String
    , isActive : Bool
    , isEditingTitle : Bool
    , systems : List GameSystem
    }


type RunningModels
    = RunningModels (List GameModel)


type alias GameSystem =
    { name : String
    , path : String
    , id : Int
    , constructorVariables : GameObjectAttributes
    , uniqueName : Maybe String
    , isActive : Bool
    , isEditingTitle : Bool
    , models : RunningModels
    }


createGameSprite : Int -> GameObject -> GameSprite
createGameSprite nextID obj =
    { name = obj.name
    , path = obj.path
    , id = nextID
    , constructorVariables = defaultContructorValues obj.constructorVariables
    , publicVariables = defaultSpritePublicValues
    , uniqueName = Nothing
    , isActive = False
    , isExpanded = True
    , isLocked = False
    , isVisible = True
    , isEditingTitle = False
    , models = []
    , children = (GameSpriteChildren [])
    }


createGameModel : Int -> GameObject -> GameModel
createGameModel nextID obj =
    { name = obj.name
    , path = obj.path
    , id = nextID
    , constructorVariables = defaultContructorValues obj.constructorVariables
    , uniqueName = Nothing
    , isActive = False
    , isEditingTitle = False
    , systems = []
    }


defaultSpritePublicValues : GameObjectAttributes
defaultSpritePublicValues =
    { integers = Nothing
    , strings = Nothing
    , floats =
        Just
            [ { pName = "x"
              , pValue = Just 0
              }
            , { pName = "y"
              , pValue = Just 0
              }
            , { pName = "anchorX"
              , pValue = Just 0
              }
            , { pName = "anchorY"
              , pValue = Just 0
              }
            , { pName = "scaleX"
              , pValue = Just 1
              }
            , { pName = "scaleY"
              , pValue = Just 1
              }
            , { pName = "rotation"
              , pValue = Just 0
              }
            , { pName = "alpha"
              , pValue = Just 1
              }
            ]
    , booleans =
        Just
            [ { pName = "visible"
              , pValue = Just True
              }
            ]
    }


defaultContructorValues : GameObjectAttributes -> GameObjectAttributes
defaultContructorValues attrs =
    let
        integers =
            case attrs.integers of
                Nothing ->
                    Nothing

                Just ints ->
                    Just (List.map defaultInt ints)

        strings =
            case attrs.strings of
                Nothing ->
                    Nothing

                Just strs ->
                    Just (List.map defaultString strs)

        floats =
            case attrs.floats of
                Nothing ->
                    Nothing

                Just flts ->
                    Just (List.map defaultFloat flts)

        booleans =
            case attrs.booleans of
                Nothing ->
                    Nothing

                Just bools ->
                    Just (List.map defaultBool bools)
    in
        (GameObjectAttributes integers strings floats booleans)


defaultInt : FieldInteger -> FieldInteger
defaultInt fieldInt =
    case fieldInt.pValue of
        Nothing ->
            { fieldInt
                | pValue = Just 0
            }

        Just val ->
            { fieldInt
                | pValue = Just val
            }


defaultString : FieldString -> FieldString
defaultString fieldStr =
    case fieldStr.pValue of
        Nothing ->
            { fieldStr
                | pValue = Just ""
            }

        Just val ->
            { fieldStr
                | pValue = Just val
            }


defaultBool : FieldBool -> FieldBool
defaultBool fieldBool =
    case fieldBool.pValue of
        Nothing ->
            { fieldBool
                | pValue = Just False
            }

        Just val ->
            { fieldBool
                | pValue = Just val
            }


defaultFloat : FieldFloat -> FieldFloat
defaultFloat fieldFloat =
    case fieldFloat.pValue of
        Nothing ->
            { fieldFloat
                | pValue = Just 0.0
            }

        Just val ->
            { fieldFloat
                | pValue = Just val
            }
