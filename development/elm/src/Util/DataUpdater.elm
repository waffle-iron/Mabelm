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

module Util.DataUpdater exposing (updateGameObject, updateGameSprite)

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






updateGameSprite : Bool -> GameSprite -> GameSprite -> GameSprite
updateGameSprite addOldChildren newGameSpr rootGameSpr =
    if newGameSpr.id == rootGameSpr.id then
        if addOldChildren
            then {newGameSpr | children = rootGameSpr.children}
            else newGameSpr
    else
        {rootGameSpr | children = updateGameSpriteChildren addOldChildren newGameSpr rootGameSpr.children}

updateGameSpriteChildren : Bool -> GameSprite -> GameSpriteChildren -> GameSpriteChildren
updateGameSpriteChildren addOldChildren newGameSpr (GameSpriteChildren children) =
    GameSpriteChildren(List.map (updateGameSprite addOldChildren newGameSpr) children)