port module Update.Update exposing (update)

import Messages exposing (Msg(..))
import Model as Model exposing (Model, GameObject, GameObjectList)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import List.Extra as ListExtra
import List as Listless

port startCompile : String -> Cmd msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ------------------------------------------------------------
        NoOp ->
            (model, Cmd.none)
        LoadCompleted str ->
            case (Decode.decodeString gameObjectListDecoder str) of
                Ok data -> 
                    ({model
                        | gameObjects = Just(groupListsByPackage(data))
                    }, Cmd.none)
                Err err ->
                    (model, Cmd.none)
        CompileGame ->
            ({model
                | isCompiling = True
            }, startCompile "")
        CompileCompleted str ->
            ({model
                | isCompiling = False
            }, Cmd.none)
        ToggleButtonRender ->
            ({model
                | isRendering = not model.isRendering
            }, Cmd.none)
        ToggleButtonUpdate ->
            ({model
                | isUpdating = not model.isUpdating
            }, Cmd.none)


groupListsByPackage : List GameObject -> List GameObjectList
groupListsByPackage list =
    List.sortBy .path list
        |> ListExtra.groupWhile (\x y -> x.path == y.path)
        |> List.map makeGameObjectList

makeGameObjectList : List GameObject -> GameObjectList
makeGameObjectList list =
    let pathName =  case List.head list of
        Nothing -> ""
        Just head -> head.path in
    (GameObjectList list pathName True)

gameObjectDecoder : Decode.Decoder GameObject
gameObjectDecoder =
    decode GameObject
        |> required "name" Decode.string
        |> required "path" Decode.string

type alias ListHam = List GameObject

gameObjectListDecoder : Decode.Decoder (List GameObject)
gameObjectListDecoder =
    Decode.field "systemObjects" (Decode.list gameObjectDecoder)