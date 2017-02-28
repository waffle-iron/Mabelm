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
                | modelPackages = (getDataLists str)
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
                | modelPackages = (updateSystemPackages {list | isVisible = (not list.isVisible)} model.modelPackages)
            }, Cmd.none)
        ------------------------------------------------------------
        ToggleObject obj ->
            let newObj = { obj | isActive = not obj.isActive } in
            ({model
                | modelPackages = DataUpdater.updateGameObject newObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        IncrementInt fieldInt obj ->
            let 
                nObj = (incrementDecrementObjInt fieldInt obj (+))
            in
            ({model
                | modelPackages = DataUpdater.updateGameObject nObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        DecrementInt fieldInt obj ->
            let 
                nObj = (incrementDecrementObjInt fieldInt obj (-))
            in
            ({model
                | modelPackages = DataUpdater.updateGameObject nObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        IncrementFloat fieldFloat obj ->
            let 
                nObj = (incrementDecrementObjFloat fieldFloat obj (+))
            in
            ({model
                | modelPackages = DataUpdater.updateGameObject nObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        DecrementFloat fieldFloat obj ->
            let 
                nObj = (incrementDecrementObjFloat fieldFloat obj (-))
            in
            ({model
                | modelPackages = DataUpdater.updateGameObject nObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        ToggleBool fieldBool obj ->
            let 
                nObj = (toggleObjBool fieldBool obj)
            in
            ({model
                | modelPackages = DataUpdater.updateGameObject nObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        UpdateStr fieldString obj str ->
            let 
                nObj = (changeFieldString fieldString str obj)
            in
            ({model
                | modelPackages = DataUpdater.updateGameObject nObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        UpdateInt fieldInt obj str ->
            let 
                nObj = (changeFieldInt fieldInt str obj)
            in
            ({model
                | modelPackages = DataUpdater.updateGameObject nObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        UpdateFloat fieldFloat obj str ->
            let 
                nObj = (changeFieldFloat fieldFloat str obj)
            in
            ({model
                | modelPackages = DataUpdater.updateGameObject nObj model.modelPackages
            }, Cmd.none)
        ------------------------------------------------------------
        BuildObject obj ->
            (model, (addModel (Encoder.objToValue obj)))
        ------------------------------------------------------------
        ChangeVal field obj ->
            (model, Cmd.none)



updateSystemPackages : GamePackage -> Maybe (List GamePackage) -> Maybe (List GamePackage)
updateSystemPackages tappedList maybeSystemPackages =
    case maybeSystemPackages of
        Nothing ->
            Nothing
        Just systemPackages ->
            Just(ListExtra.replaceIf (\l -> l.path == tappedList.path) tappedList systemPackages)




            



incrementDecrementObjInt : FieldInteger -> GameObject -> (Int -> Int -> Int) -> GameObject
incrementDecrementObjInt fieldInt obj operation =
    let 
        val = case fieldInt.pValue of 
            Nothing -> 0 
            Just val -> val
        nFieldInt = {fieldInt | pValue = Just(operation val 1)}
        variables = obj.variables
        nVariables = {variables | integers = updateField nFieldInt obj.variables.integers}
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
        nVariables = {variables | floats = updateField nFieldFloat obj.variables.floats}
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
        nVariables = {variables | booleans = updateField nFieldBool obj.variables.booleans}
    in
        { obj | variables = nVariables }

changeFieldString : FieldString -> String -> GameObject -> GameObject
changeFieldString fieldString str obj =
    let 
        nFieldString = {fieldString | pValue = Just(str)}
        variables = obj.variables
        nVariables = {variables | strings = updateField nFieldString obj.variables.strings}
    in
        { obj | variables = nVariables }

changeFieldInt : FieldInteger -> String -> GameObject -> GameObject
changeFieldInt fieldInt str obj =
    let 
        val = case String.toInt str of
            Ok v -> v
            Err _ -> 0
        nFieldInt = {fieldInt | pValue = Just(val)}
        variables = obj.variables
        nVariables = {variables | integers = updateField nFieldInt obj.variables.integers}
    in
        { obj | variables = nVariables }

changeFieldFloat : FieldFloat -> String -> GameObject -> GameObject
changeFieldFloat fieldFloat str obj =
    let 
        val = case String.toFloat str of
            Ok v -> v
            Err _ -> 0
        nFieldFloat = {fieldFloat | pValue = Just(val)}
        variables = obj.variables
        nVariables = {variables | floats = updateField nFieldFloat obj.variables.floats}
    in
        { obj | variables = nVariables }

updateField : Field a -> Maybe (List (Field a)) -> Maybe (List (Field a))
updateField field maybeFields =
    case maybeFields of
        Nothing ->
            Nothing
        Just fields ->
            Just(ListExtra.replaceIf (\l -> l.pName == field.pName) field fields)