port module Update.Update exposing (update)

import Messages exposing (Msg(..))
import Model as Model exposing (Model, GameObject, GameObjectList)
import Decoder.Decoder exposing (getDataLists)
import List.Extra as ListExtra

port startCompile : String -> Cmd msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ------------------------------------------------------------
        NoOp ->
            (model, Cmd.none)
        LoadCompleted str ->
            ({model
                | gameObjects = (getDataLists str)
            }, Cmd.none)
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
        ToggleSystem list ->
            let nList = 
                {list | isVisible = (not list.isVisible)}
            in
            ({ model
                | gameObjects = (updateGameObjects nList model.gameObjects)
            }, Cmd.none)


updateGameObjects : GameObjectList -> Maybe (List GameObjectList) -> Maybe (List GameObjectList)
updateGameObjects tappedList gameObjects =
    case gameObjects of
        Nothing ->
            Nothing
        Just objs ->
            Just(ListExtra.replaceIf (\l -> l.path == tappedList.path) tappedList objs)