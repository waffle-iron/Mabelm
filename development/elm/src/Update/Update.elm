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
            let maybeData = getDataLists str in
            case maybeData of
                Nothing -> (model, Cmd.none)
                Just (modelPackages, systemPackages, spritePackages) ->
                    ({model
                        | modelPackages = Just modelPackages
                        , systemPackages = Just systemPackages
                        , spritePackages = Just spritePackages
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
        ToggleAvailableObjects ->
            ({model
                | showsAvailableObjects = not model.showsAvailableObjects
            }, Cmd.none)
        ------------------------------------------------------------
        TogglePackageGroup packageGroup ->
            let 
                setPackageList = case packageGroup.packageType of
                    Sprite -> setSpritePackageList
                    Model_ -> setModelPackageList
                    System -> setSystemPackageList
                nPackageGroup = {packageGroup | isVisible = not packageGroup.isVisible}
            in
            (setPackageList model (Just nPackageGroup), Cmd.none)
        ------------------------------------------------------------
        ToggleSystem list ->
            let 
                (packageList, setPackageList) = case list.packageType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (updatePackageGroup {list | isVisible = (not list.isVisible)} packageList), Cmd.none)
        ------------------------------------------------------------
        ToggleObject obj ->
            let 
                nObj = { obj | isActive = not obj.isActive }
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        IncrementInt fieldInt obj ->
            let 
                nObj = (incrementDecrementObjInt fieldInt obj (+))
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        DecrementInt fieldInt obj ->
            let 
                nObj = (incrementDecrementObjInt fieldInt obj (-))
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        IncrementFloat fieldFloat obj ->
            let 
                nObj = (incrementDecrementObjFloat fieldFloat obj (+))
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        DecrementFloat fieldFloat obj ->
            let 
                nObj = (incrementDecrementObjFloat fieldFloat obj (-))
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        ToggleBool fieldBool obj ->
            let 
                nObj = (toggleObjBool fieldBool obj)
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        UpdateStr fieldString obj str ->
            let 
                nObj = (changeFieldString fieldString str obj)
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        UpdateInt fieldInt obj str ->
            let 
                nObj = (changeFieldInt fieldInt str obj)
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        UpdateFloat fieldFloat obj str ->
            let 
                nObj = (changeFieldFloat fieldFloat str obj)
                (packageList, setPackageList) = case obj.gameObjectType of
                    Sprite -> (model.spritePackages, setSpritePackageList)
                    Model_ -> (model.modelPackages, setModelPackageList)
                    System -> (model.systemPackages, setSystemPackageList)
            in
            (setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none)
        ------------------------------------------------------------
        BuildObject obj ->
            (model, (addModel (Encoder.objToValue obj)))
        ------------------------------------------------------------
        ChangeVal field obj ->
            (model, Cmd.none)



updatePackage : GamePackage -> List GamePackage -> List GamePackage
updatePackage tappedList gamePackage =
    ListExtra.replaceIf (\l -> l.path == tappedList.path) tappedList gamePackage


updatePackageGroup : GamePackage -> Maybe GamePackageGroup -> Maybe GamePackageGroup
updatePackageGroup tappedList maybePackageGroup =
    case maybePackageGroup of
        Nothing ->
            Nothing
        Just packageGroup ->
            Just {packageGroup | packages = updatePackage tappedList packageGroup.packages}

setModelPackageList : Model -> (Maybe GamePackageGroup) -> Model
setModelPackageList model maybePackages = 
    { model | modelPackages = maybePackages }
setSpritePackageList : Model -> (Maybe GamePackageGroup) -> Model
setSpritePackageList model maybePackages = 
    { model | spritePackages = maybePackages }
setSystemPackageList : Model -> (Maybe GamePackageGroup) -> Model
setSystemPackageList model maybePackages = 
    { model | systemPackages = maybePackages }

            



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