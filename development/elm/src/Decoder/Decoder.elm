module Decoder.Decoder exposing (getDataLists)

import Model as Model exposing (..)
import Json.Decode as Decode
import List.Extra as ListExtra

getDataLists : String -> Maybe (List GamePackage)
getDataLists str =
    case (Decode.decodeString gamePackageDecoder str) of
        Ok data -> 
            Just(groupListsByPackage data)
        Err err ->
            let x = Debug.log("error in json") err in
            Nothing

groupListsByPackage : List GameObject -> List GamePackage
groupListsByPackage list =
    List.sortBy .path list
        |> ListExtra.groupWhile (\x y -> x.path == y.path)
        |> List.indexedMap makeGamePackage

makeGamePackage : Int -> List GameObject -> GamePackage
makeGamePackage index list =
    let pathName =  case List.head list of
        Nothing -> ""
        Just head -> head.path in
    (GamePackage list pathName True)






--
gamePackageDecoder : Decode.Decoder (List GameObject)
gamePackageDecoder =
    Decode.field "systemObjects" (Decode.list gameObjectDecoder)

--
gameObjectDecoder : Decode.Decoder GameObject
gameObjectDecoder =
    Decode.map5 GameObject
        (Decode.field "name" Decode.string)
        (Decode.field "path" Decode.string)
        (Decode.field "id" Decode.int)
        (Decode.field "variables" gameObjectAttrDecoder)
        (Decode.oneOf [Decode.field "isActive" Decode.bool, Decode.succeed False])
--
gameObjectAttrDecoder : Decode.Decoder GameObjectAttributes
gameObjectAttrDecoder =
    Decode.map4 GameObjectAttributes
        (Decode.field "integers" (Decode.nullable (Decode.list fieldIntegerDecoder)))
        (Decode.field "strings" (Decode.nullable (Decode.list fieldStringDecoder)))
        (Decode.field "floats" (Decode.nullable (Decode.list fieldFloatDecoder)))
        (Decode.field "booleans" (Decode.nullable (Decode.list fieldBoolDecoder)))

--
fieldStringDecoder : Decode.Decoder FieldString
fieldStringDecoder =
    Decode.map2 FieldString
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" (Decode.nullable Decode.string))

--
fieldIntegerDecoder : Decode.Decoder FieldInteger
fieldIntegerDecoder =
    Decode.map2 FieldInteger
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" (Decode.nullable Decode.int))

--
fieldBoolDecoder : Decode.Decoder FieldBool
fieldBoolDecoder =
    Decode.map2 FieldBool
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" (Decode.nullable Decode.bool))

--
fieldFloatDecoder : Decode.Decoder FieldFloat
fieldFloatDecoder =
    Decode.map2 FieldFloat
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" (Decode.nullable Decode.float))

-- oneOf [ "z" := float, succeed 0 ]
--    , isActive :Bool
