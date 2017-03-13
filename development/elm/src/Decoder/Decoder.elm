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


module Decoder.Decoder exposing (getDataLists)

import Model as Model exposing (..)
import Json.Decode as Decode
import List.Extra as ListExtra


getDataLists : String -> Maybe ( GamePackageGroup, GamePackageGroup, GamePackageGroup )
getDataLists str =
    case (Decode.decodeString gamePackageDecoder str) of
        Ok data ->
            Just ( (groupListsByPackage data.modelPackages), (groupListsByPackage data.systemPackages), (groupListsByPackage data.spritePackages) )

        Err err ->
            let
                x =
                    Debug.log ("error in json") err
            in
                Nothing


groupListsByPackage : List GameObject -> GamePackageGroup
groupListsByPackage list =
    List.sortBy .path list
        |> ListExtra.groupWhile (\x y -> x.path == y.path)
        |> List.indexedMap makeGamePackage
        |> makeGamePackageGroup


makeGamePackageGroup : List GamePackage -> GamePackageGroup
makeGamePackageGroup packages =
    let
        packageType =
            case List.head packages of
                Nothing ->
                    Model_

                Just head ->
                    head.packageType
    in
        (GamePackageGroup packages True packageType)


makeGamePackage : Int -> List GameObject -> GamePackage
makeGamePackage index list =
    let
        ( pathName, packageType ) =
            case List.head list of
                Nothing ->
                    ( "", Model_ )

                Just head ->
                    ( head.path, head.gameObjectType )
    in
        (GamePackage list pathName True packageType)


gamePackageDecoder : Decode.Decoder AllPackages
gamePackageDecoder =
    Decode.map3 AllPackages
        (Decode.field "modelObjects" (Decode.list gameObjectDecoder))
        (Decode.field "systemObjects" (Decode.list gameObjectDecoder))
        (Decode.field "spriteObjects" (Decode.list gameObjectDecoder))


gameObjectDecoder : Decode.Decoder GameObject
gameObjectDecoder =
    Decode.map7 GameObject
        (Decode.field "name" Decode.string)
        (Decode.field "path" Decode.string)
        (Decode.field "id" Decode.int)
        (Decode.field "constructorVariables" gameObjectAttrDecoder)
        (Decode.field "uniqueName" (Decode.nullable Decode.string))
        (Decode.oneOf [ Decode.field "isActive" Decode.bool, Decode.succeed True ])
        (Decode.field "type" (Decode.string |> Decode.andThen gameObjectTypeDecoder))


gameObjectAttrDecoder : Decode.Decoder GameObjectAttributes
gameObjectAttrDecoder =
    Decode.map4 GameObjectAttributes
        (Decode.field "integers" (Decode.nullable (Decode.list fieldIntegerDecoder)))
        (Decode.field "strings" (Decode.nullable (Decode.list fieldStringDecoder)))
        (Decode.field "floats" (Decode.nullable (Decode.list fieldFloatDecoder)))
        (Decode.field "booleans" (Decode.nullable (Decode.list fieldBoolDecoder)))


fieldStringDecoder : Decode.Decoder FieldString
fieldStringDecoder =
    Decode.map2 FieldString
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" (Decode.nullable Decode.string))


fieldIntegerDecoder : Decode.Decoder FieldInteger
fieldIntegerDecoder =
    Decode.map2 FieldInteger
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" (Decode.nullable Decode.int))


fieldBoolDecoder : Decode.Decoder FieldBool
fieldBoolDecoder =
    Decode.map2 FieldBool
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" (Decode.nullable Decode.bool))


fieldFloatDecoder : Decode.Decoder FieldFloat
fieldFloatDecoder =
    Decode.map2 FieldFloat
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" (Decode.nullable Decode.float))


gameObjectTypeDecoder : String -> Decode.Decoder GameObjectType
gameObjectTypeDecoder tag =
    case tag of
        "Sprite" ->
            Decode.succeed Sprite

        "Model" ->
            Decode.succeed Model_

        "System" ->
            Decode.succeed System

        _ ->
            Decode.fail (tag ++ " is not a recognized tag for Importance")
