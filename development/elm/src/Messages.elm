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

module Messages exposing (Msg(..))

import Model exposing (..)

type Msg
    = NoOp
    | CompileGame
    | CompileCompleted String
    | LoadCompleted String
    | ToggleButtonRender
    | ToggleButtonUpdate
    | ToggleSystem GamePackage
    | TogglePackageGroup GamePackageGroup
    | ToggleObject GameObject
    | ToggleAvailableObjects
    | ToggleRunningSystems
    | IncrementInt FieldInteger GameObject
    | DecrementInt FieldInteger GameObject
    | IncrementFloat FieldFloat GameObject
    | DecrementFloat FieldFloat GameObject
    | ToggleBool FieldBool GameObject
    | UpdateStr FieldString GameObject String
    | UpdateInt FieldInteger GameObject String
    | UpdateFloat FieldFloat GameObject String
    | BuildObject GameObject
    | AddSystem GameObject
    | AddSprite GameObject
    | AddModel GameObject
    | ClickTreeSprite GameSprite
    | ToggleModel GameSprite GameModel