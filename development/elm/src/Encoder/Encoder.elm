module Encoder.Encoder exposing (..)

import Model exposing (..)
import Json.Encode as Encode

objToValue : GameObject -> Encode.Value
objToValue obj =
    Encode.object
        [ ("name", Encode.string obj.name)
        , ("path", Encode.string obj.path)
        , ("id", Encode.int obj.id)
        , ("variables", variablesToValue obj.variables)
        , ("isActive", Encode.bool obj.isActive)
        ]
--
variablesToValue : GameObjectAttributes -> Encode.Value
variablesToValue attrs =
    let 
        maybeInts = case attrs.integers of
            Nothing -> Encode.null
            Just params -> Encode.list (List.map fieldIntegerToValue params)
        maybeFloats = case attrs.floats of
            Nothing -> Encode.null
            Just params -> Encode.list (List.map fieldFloatToValue params)
        maybeStrings = case attrs.strings of
            Nothing -> Encode.null
            Just params -> Encode.list (List.map fieldStringToValue params)
        maybeBools = case attrs.booleans of
            Nothing -> Encode.null
            Just params -> Encode.list (List.map fieldBoolToValue params)
    in
    Encode.object
        [ ("integers", maybeInts)
        , ("floats", maybeFloats)
        , ("strings", maybeStrings)
        , ("booleans", maybeBools)
        ]
--
fieldIntegerToValue : FieldInteger -> Encode.Value
fieldIntegerToValue field =
    let 
        pValue = case field.pValue of
            Nothing -> Encode.int 0
            Just val -> Encode.int val
    in
    Encode.object
        [ ("pName", (Encode.string field.pName))
        , ("pValue", pValue)
        ]
--
fieldFloatToValue : FieldFloat -> Encode.Value
fieldFloatToValue field =
    let 
        pValue = case field.pValue of
            Nothing -> Encode.float 0
            Just val -> Encode.float val
    in
    Encode.object
        [ ("pName", (Encode.string field.pName))
        , ("pValue", pValue)
        ]
--
fieldStringToValue : FieldString -> Encode.Value
fieldStringToValue field =
    let 
        pValue = case field.pValue of
            Nothing -> Encode.string ""
            Just val -> Encode.string val
    in
    Encode.object
        [ ("pName", (Encode.string field.pName))
        , ("pValue", pValue)
        ]
--
fieldBoolToValue : FieldBool -> Encode.Value
fieldBoolToValue field =
    let 
        pValue = case field.pValue of
            Nothing -> Encode.bool False
            Just val -> Encode.bool val
    in
    Encode.object
        [ ("pName", (Encode.string field.pName))
        , ("pValue", pValue)
        ]