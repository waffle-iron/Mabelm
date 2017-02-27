module Decoder.Decoder exposing (getDataLists)

import Model as Model exposing (..)
import Json.Decode as Decode
import List.Extra as ListExtra

getDataLists : String -> Maybe (List GameObjectList)
getDataLists str =
    case (Decode.decodeString gameObjectListDecoder str) of
        Ok data -> 
            Just(groupListsByPackage data)
        Err err ->
            let x = Debug.log("error in json") err in
            Nothing

groupListsByPackage : List GameObject -> List GameObjectList
groupListsByPackage list =
    List.sortBy .path list
        |> ListExtra.groupWhile (\x y -> x.path == y.path)
        |> List.indexedMap makeGameObjectList

makeGameObjectList : Int -> List GameObject -> GameObjectList
makeGameObjectList index list =
    let pathName =  case List.head list of
        Nothing -> ""
        Just head -> head.path in
    (GameObjectList list pathName True)



gameObjectListDecoder : Decode.Decoder (List GameObject)
gameObjectListDecoder =
    Decode.field "systemObjects" (Decode.list gameObjectDecoder)

gameObjectDecoder : Decode.Decoder GameObject
gameObjectDecoder =
    Decode.map4 GameObject
        (Decode.field "name" Decode.string)
        (Decode.field "path" Decode.string)
        (Decode.field "id" Decode.int)
        (Decode.field "variables" gameObjectAttrDecoder)

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
        (Decode.field "pValue" Decode.string)

fieldIntegerDecoder : Decode.Decoder FieldInteger
fieldIntegerDecoder =
    Decode.map2 FieldInteger
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" Decode.int)

fieldBoolDecoder : Decode.Decoder FieldBool
fieldBoolDecoder =
    Decode.map2 FieldBool
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" Decode.bool)

fieldFloatDecoder : Decode.Decoder FieldFloat
fieldFloatDecoder =
    Decode.map2 FieldFloat
        (Decode.field "pName" Decode.string)
        (Decode.field "pValue" Decode.float)