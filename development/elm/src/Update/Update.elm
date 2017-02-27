port module Update.Update exposing (update)

import Json.Encode as Encode
import Util.DataUpdater as DataUpdater
import Messages exposing (Msg(..))
import Model as Model exposing (..)
import Decoder.Decoder exposing (getDataLists)
import List.Extra as ListExtra
import Encoder.Encoder as Encoder

port startCompile : String -> Cmd msg
port addModel : Encode.Value -> Cmd msg

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
            let newObj = { obj | isActive = not obj.isActive } in
            ({model
                | systemPackages = DataUpdater.updateGameObject newObj model.systemPackages
            }, Cmd.none)
        ------------------------------------------------------------
        IncrementInt fieldInt obj ->
            let 
                nObj = (incrementDecrementObjInt fieldInt obj (+))
            in
            ({model
                | systemPackages = DataUpdater.updateGameObject nObj model.systemPackages
            }, Cmd.none)
        ------------------------------------------------------------
        DecrementInt fieldInt obj ->
            let 
                nObj = (incrementDecrementObjInt fieldInt obj (-))
            in
            ({model
                | systemPackages = DataUpdater.updateGameObject nObj model.systemPackages
            }, Cmd.none)
        ------------------------------------------------------------
        IncrementFloat fieldFloat obj ->
            let 
                nObj = (incrementDecrementObjFloat fieldFloat obj (+))
            in
            ({model
                | systemPackages = DataUpdater.updateGameObject nObj model.systemPackages
            }, Cmd.none)
        ------------------------------------------------------------
        DecrementFloat fieldFloat obj ->
            let 
                nObj = (incrementDecrementObjFloat fieldFloat obj (-))
            in
            ({model
                | systemPackages = DataUpdater.updateGameObject nObj model.systemPackages
            }, Cmd.none)
        ------------------------------------------------------------
        ToggleBool fieldBool obj ->
            let 
                nObj = (toggleObjBool fieldBool obj)
            in
            ({model
                | systemPackages = DataUpdater.updateGameObject nObj model.systemPackages
            }, Cmd.none)
        ------------------------------------------------------------
        UpdateStr fieldString obj str ->
            let 
                nObj = (changeFieldString fieldString str obj)
            in
            ({model
                | systemPackages = DataUpdater.updateGameObject nObj model.systemPackages
            }, Cmd.none)
        ------------------------------------------------------------
        BuildObject obj ->
            (model, (addModel (Encoder.objToValue obj)))












incrementDecrementObjInt : FieldInteger -> GameObject -> (Int -> Int -> Int) -> GameObject
incrementDecrementObjInt fieldInt obj operation =
    let 
        val = case fieldInt.pValue of 
            Nothing -> 0 
            Just val -> val
        nFieldInt = {fieldInt | pValue = Just(operation val 1)}
        variables = obj.variables
        nVariables = {variables | integers = updateFieldInt nFieldInt obj.variables.integers}
    in
        { obj | variables = nVariables }

incrementDecrementObjFloat : FieldFloat -> GameObject -> (Float -> Float -> Float) -> GameObject
incrementDecrementObjFloat fieldFloat obj operation =
    let 
        val = case fieldFloat.pValue of 
            Nothing -> 0 
            Just val -> val
        nFieldFloat = {fieldFloat | pValue = Just(operation val 1)}
        variables = obj.variables
        nVariables = {variables | floats = updateFieldFloat nFieldFloat obj.variables.floats}
    in
        { obj | variables = nVariables }

toggleObjBool : FieldBool -> GameObject -> GameObject
toggleObjBool fieldBool obj =
    let 
        val = case fieldBool.pValue of 
            Nothing -> False
            Just val -> val
        nFieldBool = {fieldBool | pValue = Just(not val)}
        variables = obj.variables
        nVariables = {variables | booleans = updateFieldBool nFieldBool obj.variables.booleans}
    in
        { obj | variables = nVariables }

changeFieldString : FieldString -> String -> GameObject -> GameObject
changeFieldString fieldString str obj =
    let 
        nFieldString = {fieldString | pValue = Just(str)}
        variables = obj.variables
        nVariables = {variables | strings = updateFieldString nFieldString obj.variables.strings}
    in
        { obj | variables = nVariables }







updateFieldInt : FieldInteger -> Maybe (List FieldInteger) -> Maybe (List FieldInteger)
updateFieldInt fieldInt maybeFields =
    case maybeFields of
        Nothing ->
            Nothing
        Just fields ->
            Just(ListExtra.replaceIf (\l -> l.pName == fieldInt.pName) fieldInt fields)

updateFieldFloat : FieldFloat -> Maybe (List FieldFloat) -> Maybe (List FieldFloat)
updateFieldFloat fieldFloat maybeFields =
    case maybeFields of
        Nothing ->
            Nothing
        Just fields ->
            Just(ListExtra.replaceIf (\l -> l.pName == fieldFloat.pName) fieldFloat fields)

updateFieldBool : FieldBool -> Maybe (List FieldBool) -> Maybe (List FieldBool)
updateFieldBool fieldBool maybeFields =
    case maybeFields of
        Nothing ->
            Nothing
        Just fields ->
            Just(ListExtra.replaceIf (\l -> l.pName == fieldBool.pName) fieldBool fields)

updateFieldString : FieldString -> Maybe (List FieldString) -> Maybe (List FieldString)
updateFieldString fieldString maybeFields =
    case maybeFields of
        Nothing ->
            Nothing
        Just fields ->
            Just(ListExtra.replaceIf (\l -> l.pName == fieldString.pName) fieldString fields)






updateSystemPackages : GamePackage -> Maybe (List GamePackage) -> Maybe (List GamePackage)
updateSystemPackages tappedList maybeSystemPackages =
    case maybeSystemPackages of
        Nothing ->
            Nothing
        Just systemPackages ->
            Just(ListExtra.replaceIf (\l -> l.path == tappedList.path) tappedList systemPackages)