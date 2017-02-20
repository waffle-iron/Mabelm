module Model exposing (Model, model, GameObject)

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
        [ obj1
        , obj2
        , obj3
        , obj4
        , obj5
        ]
    }

type alias GameObject =
    { name :String
    , path :String
    }


obj1 : GameObject
obj1 =
    { name = "ModFlipBook"
    , path = "cranberry.model"
    }

obj2 : GameObject
obj2 =
    { name = "ModelFlipBook"
    , path = "cranberry.model"
    }

obj3 : GameObject
obj3 =
    { name = "ChildModelFlipBook"
    , path = "cranberry.model.child"
    }

obj4 : GameObject
obj4 =
    { name = "ChildModelFlipBook2"
    , path = "cranberry.model.child.ham"
    }

obj5 : GameObject
obj5 =
    { name = "ChildModelFlipBook3"
    , path = "cranberry.model.child"
    }