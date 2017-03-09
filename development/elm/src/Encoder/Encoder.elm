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


module Encoder.Encoder exposing (..)

import Model exposing (..)
import Json.Encode as Encode


objToValue : GameObject -> Encode.Value
objToValue obj =
    Encode.object
        [ ( "name", Encode.string obj.name )
        , ( "path", Encode.string obj.path )
        , ( "id", Encode.int obj.id )
        , ( "variables", variablesToValue obj.variables )
        , ( "isActive", Encode.bool obj.isActive )
        ]


variablesToValue : GameObjectAttributes -> Encode.Value
variablesToValue attrs =
    let
        maybeInts =
            case attrs.integers of
                Nothing ->
                    Encode.null

                Just params ->
                    Encode.list (List.map fieldIntegerToValue params)

        maybeFloats =
            case attrs.floats of
                Nothing ->
                    Encode.null

                Just params ->
                    Encode.list (List.map fieldFloatToValue params)

        maybeStrings =
            case attrs.strings of
                Nothing ->
                    Encode.null

                Just params ->
                    Encode.list (List.map fieldStringToValue params)

        maybeBools =
            case attrs.booleans of
                Nothing ->
                    Encode.null

                Just params ->
                    Encode.list (List.map fieldBoolToValue params)
    in
        Encode.object
            [ ( "integers", maybeInts )
            , ( "floats", maybeFloats )
            , ( "strings", maybeStrings )
            , ( "booleans", maybeBools )
            ]


fieldIntegerToValue : FieldInteger -> Encode.Value
fieldIntegerToValue field =
    let
        pValue =
            case field.pValue of
                Nothing ->
                    Encode.int 0

                Just val ->
                    Encode.int val
    in
        Encode.object
            [ ( "pName", (Encode.string field.pName) )
            , ( "pValue", pValue )
            ]


fieldFloatToValue : FieldFloat -> Encode.Value
fieldFloatToValue field =
    let
        pValue =
            case field.pValue of
                Nothing ->
                    Encode.float 0

                Just val ->
                    Encode.float val
    in
        Encode.object
            [ ( "pName", (Encode.string field.pName) )
            , ( "pValue", pValue )
            ]


fieldStringToValue : FieldString -> Encode.Value
fieldStringToValue field =
    let
        pValue =
            case field.pValue of
                Nothing ->
                    Encode.string ""

                Just val ->
                    Encode.string val
    in
        Encode.object
            [ ( "pName", (Encode.string field.pName) )
            , ( "pValue", pValue )
            ]


fieldBoolToValue : FieldBool -> Encode.Value
fieldBoolToValue field =
    let
        pValue =
            case field.pValue of
                Nothing ->
                    Encode.bool False

                Just val ->
                    Encode.bool val
    in
        Encode.object
            [ ( "pName", (Encode.string field.pName) )
            , ( "pValue", pValue )
            ]
