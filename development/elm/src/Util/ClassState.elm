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


module Util.ClassState exposing (classStateGameSprite, classStateModel)

import Model exposing (..)


classStateGameSprite : String -> GameSprite -> String
classStateGameSprite baseClass spr =
    baseClass
        |> addState spr.isActive " isActive"
        |> addState spr.isExpanded " isExpanded"
        |> addState spr.isLocked " isLocked"
        |> addState spr.isVisible " isVisible"


classStateModel : String -> Model -> String
classStateModel baseClass spr =
    baseClass
        |> addState spr.isCompiling " isCompiling"
        |> addState spr.isRendering " isRendering"
        |> addState spr.isUpdating " isUpdating"
        |> addState spr.showsAvailableObjects " showsAvailableObjects"
        |> addState spr.showsRunningSystems " showsRunningSystems"


addState : Bool -> String -> String -> String
addState isCompiling state str =
    if isCompiling then
        str ++ " " ++ state
    else
        str
