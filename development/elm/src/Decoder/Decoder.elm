module Decoder.Decoder exposing (getDataLists)

import Model as Model exposing (GameObject, GameObjectList)
import Json.Decode as Decode
import Json.Decode.Pipeline as DecodeRed
import List.Extra as ListExtra

getDataLists : String -> Maybe (List GameObjectList)
getDataLists str =
    case (Decode.decodeString gameObjectListDecoder str) of
        Ok data -> 
            Just(groupListsByPackage data)
        Err err ->
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

gameObjectDecoder : Decode.Decoder GameObject
gameObjectDecoder =
    DecodeRed.decode GameObject
        |> DecodeRed.required "name" Decode.string
        |> DecodeRed.required "path" Decode.string
        |> DecodeRed.required "id" Decode.int

gameObjectListDecoder : Decode.Decoder (List GameObject)
gameObjectListDecoder =
    Decode.field "systemObjects" (Decode.list gameObjectDecoder)