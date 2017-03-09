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
        NoOp ->
            ( model, Cmd.none )

        LoadCompleted str ->
            let
                maybeData =
                    getDataLists str
            in
                case maybeData of
                    Nothing ->
                        ( model, Cmd.none )

                    Just ( modelPackages, systemPackages, spritePackages ) ->
                        ( { model
                            | modelPackages = Just modelPackages
                            , systemPackages = Just systemPackages
                            , spritePackages = Just spritePackages
                          }
                        , Cmd.none
                        )

        CompileGame ->
            ( { model
                | isCompiling = True
              }
            , startCompile ""
            )

        CompileCompleted str ->
            ( { model
                | isCompiling = False
              }
            , Cmd.none
            )

        ToggleButtonRender ->
            ( { model
                | isRendering = not model.isRendering
              }
            , Cmd.none
            )

        ToggleButtonUpdate ->
            ( { model
                | isUpdating = not model.isUpdating
              }
            , Cmd.none
            )

        ToggleAvailableObjects ->
            ( { model
                | showsAvailableObjects = not model.showsAvailableObjects
              }
            , Cmd.none
            )

        ToggleRunningSystems ->
            ( { model
                | showsRunningSystems = not model.showsRunningSystems
              }
            , Cmd.none
            )

        TogglePackageGroup packageGroup ->
            let
                setPackageList =
                    case packageGroup.packageType of
                        Sprite ->
                            setSpritePackageList

                        Model_ ->
                            setModelPackageList

                        System ->
                            setSystemPackageList

                nPackageGroup =
                    { packageGroup | isVisible = not packageGroup.isVisible }
            in
                ( setPackageList model (Just nPackageGroup), Cmd.none )

        ToggleSystem list ->
            let
                ( packageList, setPackageList ) =
                    case list.packageType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (updatePackageGroup { list | isVisible = (not list.isVisible) } packageList), Cmd.none )

        ToggleObject obj ->
            let
                nObj =
                    { obj | isActive = not obj.isActive }

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        IncrementInt fieldInt obj ->
            let
                nObj =
                    (incrementDecrementObjInt fieldInt obj (+))

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        DecrementInt fieldInt obj ->
            let
                nObj =
                    (incrementDecrementObjInt fieldInt obj (-))

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        IncrementFloat fieldFloat obj ->
            let
                nObj =
                    (incrementDecrementObjFloat fieldFloat obj (+))

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        DecrementFloat fieldFloat obj ->
            let
                nObj =
                    (incrementDecrementObjFloat fieldFloat obj (-))

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        ToggleBool fieldBool obj ->
            let
                nObj =
                    (toggleObjBool fieldBool obj)

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        UpdateStr fieldString obj str ->
            let
                nObj =
                    (changeFieldString fieldString str obj)

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        UpdateInt fieldInt obj str ->
            let
                nObj =
                    (changeFieldInt fieldInt str obj)

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        UpdateFloat fieldFloat obj str ->
            let
                nObj =
                    (changeFieldFloat fieldFloat str obj)

                ( packageList, setPackageList ) =
                    case obj.gameObjectType of
                        Sprite ->
                            ( model.spritePackages, setSpritePackageList )

                        Model_ ->
                            ( model.modelPackages, setModelPackageList )

                        System ->
                            ( model.systemPackages, setSystemPackageList )
            in
                ( setPackageList model (DataUpdater.updateGameObject nObj packageList), Cmd.none )

        BuildObject obj ->
            ( model, Cmd.none )

        AddSystem obj ->
            let
                runningSystems =
                    List.append model.runningSystems [ obj ]
            in
                ( { model
                    | runningSystems = runningSystems
                  }
                , Cmd.none
                )

        AddSprite obj ->
            case model.activeSprite of
                Nothing ->
                    ( model, Cmd.none )

                Just activeSpr ->
                    let
                        nChildren =
                            addChild activeSpr.children (createGameSprite model.nextID obj)

                        nRoot =
                            DataUpdater.updateByID activeSpr.id (updateChildren nChildren) model.root
                    in
                        ( { model
                            | root = nRoot
                            , nextID = model.nextID + 1
                            , activeSprite = DataUpdater.getByID activeSpr.id nRoot
                          }
                        , Cmd.none
                        )

        AddModel obj ->
            case model.activeSprite of
                Nothing ->
                    ( model, Cmd.none )

                Just activeSpr ->
                    let
                        nModels =
                            addModel activeSpr.models (createGameModel model.nextID obj)

                        nRoot =
                            DataUpdater.updateByID activeSpr.id (updateModels nModels) model.root
                    in
                        ( { model
                            | root = nRoot
                            , nextID = model.nextID + 1
                            , activeSprite = DataUpdater.getByID activeSpr.id nRoot
                          }
                        , Cmd.none
                        )

        ClickTreeSprite spr ->
            let
                ( root, maybeSpr ) =
                    case model.activeSprite of
                        Nothing ->
                            let
                                nRoot =
                                    DataUpdater.updateByID spr.id (updateIsActive True) model.root
                            in
                                ( nRoot, DataUpdater.getByID spr.id nRoot )

                        Just aSpr ->
                            let
                                nRoot =
                                    DataUpdater.updateByID aSpr.id (updateIsActive False) model.root
                            in
                                if aSpr.id == spr.id then
                                    ( nRoot, Nothing )
                                else
                                    let
                                        xRoot =
                                            DataUpdater.updateByID spr.id (updateIsActive True) nRoot
                                    in
                                        ( xRoot, DataUpdater.getByID spr.id xRoot )
            in
                ( { model
                    | root = root
                    , activeSprite = maybeSpr
                  }
                , Cmd.none
                )

        ToggleModel gameSprite gameModel ->
            let
                nGameModel =
                    { gameModel | isActive = not gameModel.isActive }

                nModels =
                    ListExtra.replaceIf (\n -> n.id == gameModel.id) nGameModel gameSprite.models

                nRoot =
                    DataUpdater.updateByID gameSprite.id (updateModels nModels) model.root
            in
                ( { model
                    | root = nRoot
                    , activeSprite = DataUpdater.getByID gameSprite.id nRoot
                  }
                , Cmd.none
                )

        ToggleVisiblilty spr ->
            let
                nRoot =
                    DataUpdater.updateByID spr.id (updateIsVisible (not spr.isVisible)) model.root
            in
                ( { model
                    | root = nRoot
                    , activeSprite = updateActiveSpr model.activeSprite nRoot
                  }
                , Cmd.none
                )

        ToggleLocked spr ->
            let
                nRoot =
                    DataUpdater.updateByID spr.id (updateIsLocked (not spr.isLocked)) model.root
            in
                ( { model
                    | root = nRoot
                    , activeSprite = updateActiveSpr model.activeSprite nRoot
                  }
                , Cmd.none
                )

        ToggleExpanded spr ->
            let
                nRoot =
                    DataUpdater.updateByID spr.id (updateIsExpanded (not spr.isExpanded)) model.root
            in
                ( { model
                    | root = nRoot
                    , activeSprite = updateActiveSpr model.activeSprite nRoot
                  }
                , Cmd.none
                )


updateIsVisible : Bool -> GameSprite -> GameSprite
updateIsVisible isVisible gameSpr =
    { gameSpr | isVisible = isVisible }


updateIsExpanded : Bool -> GameSprite -> GameSprite
updateIsExpanded isExpanded gameSpr =
    { gameSpr | isExpanded = isExpanded }


updateIsActive : Bool -> GameSprite -> GameSprite
updateIsActive isActive gameSpr =
    { gameSpr | isActive = isActive }


updateIsLocked : Bool -> GameSprite -> GameSprite
updateIsLocked isLocked gameSpr =
    { gameSpr | isLocked = isLocked }


updateModels : List GameModel -> GameSprite -> GameSprite
updateModels models gameSpr =
    { gameSpr | models = models }


updateChildren : GameSpriteChildren -> GameSprite -> GameSprite
updateChildren children gameSpr =
    { gameSpr | children = children }


updateActiveSpr : Maybe GameSprite -> GameSprite -> Maybe GameSprite
updateActiveSpr maybeSpr root =
    case maybeSpr of
        Nothing ->
            Nothing

        Just activeSpr ->
            DataUpdater.getByID activeSpr.id root


updatePackage : GamePackage -> List GamePackage -> List GamePackage
updatePackage tappedList gamePackage =
    ListExtra.replaceIf (\l -> l.path == tappedList.path) tappedList gamePackage


updatePackageGroup : GamePackage -> Maybe GamePackageGroup -> Maybe GamePackageGroup
updatePackageGroup tappedList maybePackageGroup =
    case maybePackageGroup of
        Nothing ->
            Nothing

        Just packageGroup ->
            Just { packageGroup | packages = updatePackage tappedList packageGroup.packages }


setModelPackageList : Model -> Maybe GamePackageGroup -> Model
setModelPackageList model maybePackages =
    { model | modelPackages = maybePackages }


setSpritePackageList : Model -> Maybe GamePackageGroup -> Model
setSpritePackageList model maybePackages =
    { model | spritePackages = maybePackages }


setSystemPackageList : Model -> Maybe GamePackageGroup -> Model
setSystemPackageList model maybePackages =
    { model | systemPackages = maybePackages }


incrementDecrementObjInt : FieldInteger -> GameObject -> (Int -> Int -> Int) -> GameObject
incrementDecrementObjInt fieldInt obj operation =
    let
        val =
            case fieldInt.pValue of
                Nothing ->
                    0

                Just val ->
                    val

        nFieldInt =
            { fieldInt | pValue = Just (operation val 1) }

        variables =
            obj.variables

        nVariables =
            { variables | integers = updateField nFieldInt obj.variables.integers }
    in
        { obj | variables = nVariables }


incrementDecrementObjFloat : FieldFloat -> GameObject -> (Float -> Float -> Float) -> GameObject
incrementDecrementObjFloat fieldFloat obj operation =
    let
        val =
            case fieldFloat.pValue of
                Nothing ->
                    0

                Just val ->
                    val

        nFieldFloat =
            { fieldFloat | pValue = Just (operation val 1) }

        variables =
            obj.variables

        nVariables =
            { variables | floats = updateField nFieldFloat obj.variables.floats }
    in
        { obj | variables = nVariables }


toggleObjBool : FieldBool -> GameObject -> GameObject
toggleObjBool fieldBool obj =
    let
        val =
            case fieldBool.pValue of
                Nothing ->
                    False

                Just val ->
                    val

        nFieldBool =
            { fieldBool | pValue = Just (not val) }

        variables =
            obj.variables

        nVariables =
            { variables | booleans = updateField nFieldBool obj.variables.booleans }
    in
        { obj | variables = nVariables }


changeFieldString : FieldString -> String -> GameObject -> GameObject
changeFieldString fieldString str obj =
    let
        nFieldString =
            { fieldString | pValue = Just (str) }

        variables =
            obj.variables

        nVariables =
            { variables | strings = updateField nFieldString obj.variables.strings }
    in
        { obj | variables = nVariables }


changeFieldInt : FieldInteger -> String -> GameObject -> GameObject
changeFieldInt fieldInt str obj =
    let
        val =
            case String.toInt str of
                Ok v ->
                    v

                Err _ ->
                    0

        nFieldInt =
            { fieldInt | pValue = Just (val) }

        variables =
            obj.variables

        nVariables =
            { variables | integers = updateField nFieldInt obj.variables.integers }
    in
        { obj | variables = nVariables }


changeFieldFloat : FieldFloat -> String -> GameObject -> GameObject
changeFieldFloat fieldFloat str obj =
    let
        val =
            case String.toFloat str of
                Ok v ->
                    v

                Err _ ->
                    0

        nFieldFloat =
            { fieldFloat | pValue = Just (val) }

        variables =
            obj.variables

        nVariables =
            { variables | floats = updateField nFieldFloat obj.variables.floats }
    in
        { obj | variables = nVariables }


updateField : Field a -> Maybe (List (Field a)) -> Maybe (List (Field a))
updateField field maybeFields =
    case maybeFields of
        Nothing ->
            Nothing

        Just fields ->
            Just (ListExtra.replaceIf (\l -> l.pName == field.pName) field fields)


addChild : GameSpriteChildren -> GameSprite -> GameSpriteChildren
addChild (GameSpriteChildren children) nChild =
    GameSpriteChildren (List.append children [ nChild ])


addModel : List GameModel -> GameModel -> List GameModel
addModel models gModel =
    List.append models [ gModel ]
