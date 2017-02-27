port module Update.Update exposing (update)

import Util.DataUpdater as DataUpdater
import Messages exposing (Msg(..))
import Model as Model exposing (..)
import Decoder.Decoder exposing (getDataLists)
import List.Extra as ListExtra

port startCompile : String -> Cmd msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ------------------------------------------------------------
        NoOp ->
            (model, Cmd.none)
        ------------------------------------------------------------
        LoadCompleted str ->
            ({model
                | systemPackages = (getDataLists str)
            }, Cmd.none)
        ------------------------------------------------------------
        CompileGame ->
            ({model
                | isCompiling = True
            }, startCompile "")
        ------------------------------------------------------------
        CompileCompleted str ->
            ({model
                | isCompiling = False
            }, Cmd.none)
        ------------------------------------------------------------
        ToggleButtonRender ->
            ({model
                | isRendering = not model.isRendering
            }, Cmd.none)
        ------------------------------------------------------------
        ToggleButtonUpdate ->
            ({model
                | isUpdating = not model.isUpdating
            }, Cmd.none)
        ------------------------------------------------------------
        ToggleSystem list ->
            ({ model
                | systemPackages = (updateSystemPackages {list | isVisible = (not list.isVisible)} model.systemPackages)
            }, Cmd.none)
        ------------------------------------------------------------
        ToggleObject obj ->
            (model, Cmd.none)

updateSystemPackages : GamePackage -> Maybe (List GamePackage) -> Maybe (List GamePackage)
updateSystemPackages tappedList maybeSystemPackages =
    case maybeSystemPackages of
        Nothing ->
            Nothing
        Just systemPackages ->
            Just(ListExtra.replaceIf (\l -> l.path == tappedList.path) tappedList systemPackages)