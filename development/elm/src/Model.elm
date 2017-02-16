module Model exposing (Model, model, GameObject, GameObjectChildren(GameObjectChildren))

type alias Model =
    { isCompiling :Bool
    , isRendering :Bool
    , isUpdating :Bool
    , gameObjects :Maybe (List GameObject)
    }

model : Model
model = 
    { isCompiling = False
    , isRendering = False
    , isUpdating = False
    , gameObjects = Just 
        [ baseObject
        , nextObject
        ]
    }

type alias GameObject =
    { name :String
    , path :String
    , displayChildren :Bool
    , children :Maybe GameObjectChildren
    }

type GameObjectChildren = GameObjectChildren (List GameObject)


baseObject : GameObject
baseObject =
    { name = "SystemFlipBook"
    , path = "cranberry.system"
    , displayChildren = True
    , children = Nothing
    }

nextObject : GameObject
nextObject =
    { name = "ModelFlipBook"
    , path = "cranberry.model"
    , displayChildren = True
    , children = Just (GameObjectChildren 
        [ modelChildObj
        , modelChildObj2
        ])
    }

modelChildObj : GameObject
modelChildObj =
    { name = "ChildModelFlipBook"
    , path = "cranberry.model.child"
    , displayChildren = True
    , children = Nothing
    }

modelChildObj2 : GameObject
modelChildObj2 =
    { name = "ChildModelFlipBook2"
    , path = "cranberry.model.child"
    , displayChildren = True
    , children = Nothing
    }