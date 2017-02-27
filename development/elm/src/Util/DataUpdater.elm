module Util.DataUpdater exposing (updateGameObject)

import Model exposing (..)

updateGameObject : GameObject -> Maybe (List GamePackage) -> Maybe (List GamePackage)
updateGameObject newObj maybeList =
    case maybeList of
        Nothing -> Nothing
        Just val ->
            Just(List.map (updatePackageList newObj) val)

updatePackageList : GameObject -> GamePackage -> GamePackage
updatePackageList newObj gamePackage =
    {gamePackage
        | objects = List.map (updateObj newObj) (gamePackage.objects)
    }

updateObj : GameObject -> GameObject -> GameObject
updateObj newObj obj =
    if newObj.id == obj.id then
        newObj
    else
        obj