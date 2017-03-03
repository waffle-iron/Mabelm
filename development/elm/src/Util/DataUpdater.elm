module Util.DataUpdater exposing (updateGameObject)

import Model exposing (..)

updateGameObject : GameObject -> Maybe GamePackageGroup -> Maybe GamePackageGroup
updateGameObject newObj maybePackageGroup =
    case maybePackageGroup of
        Nothing -> Nothing
        Just packageGroup ->
            let 
                nPackages = List.map (updatePackageList newObj) packageGroup.packages
            in
            Just {packageGroup | packages = nPackages}

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