module Util.DataUpdater exposing (..)

import Model exposing (..)


-- GameObject -> (List GameObjectList) -> Maybe GameObjectList
-- gameObjects
ham = 13


-- getSceneObject : Int -> SceneObject -> Maybe SceneObject
-- getSceneObject id rootObj =
--     if id == rootObj.id then
--         Just rootObj
--     else
--         let list = List.map (getSceneObject id) (getSceneObjectList rootObj.children) in
--         case List.head list of
--             Nothing -> Nothing
--             Just val -> val

-- getSceneObjectList : Children -> List SceneObject
-- getSceneObjectList (Model.Children children) =
--     children

-- updateSceneObject : SceneObject -> SceneObject -> SceneObject
-- updateSceneObject newSceneObj rootObj =
--     if newSceneObj.id == rootObj.id then
--         newSceneObj
--     else
--         {rootObj | children = updateChildren newSceneObj rootObj.children}

-- updateChildren : SceneObject -> Children -> Children
-- updateChildren newSceneObj (Children children) =
--     Children(List.map (updateSceneObject newSceneObj) children)