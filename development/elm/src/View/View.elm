module View.View exposing (..)

import Html exposing (Html, text, div, ul, li, span)
import Html.Attributes exposing (class, id)
import Material.Icons.Action exposing (build, autorenew)
import Material.Icons.Av exposing (play_arrow, stop)
import Color as Color
import Svg exposing (Svg)

import Messages exposing (Msg(..))


import Html.Events exposing (onClick)


import Messages exposing (Msg(..))
import Model exposing (Model)

type alias MaterialIcon = (Color.Color -> Int -> Svg Msg)
type alias ClassName = String

view : Model -> Html Msg
view model =
    div []
        [ toolbar model
        , gameWindow model
        ]

toolbar : Model -> Html Msg
toolbar model =
    let renderButton = if model.isRendering then stop else play_arrow in
    let updateButton = if model.isUpdating then stop else play_arrow in
    let buildButton = if model.isCompiling then autorenew else autorenew in

    let baseClass = "toolbar__button" 
        |> stateUpdating model.isUpdating
        |> stateRendering model.isRendering
        |> stateCompiling model.isCompiling in

    div [ class "toolbar" ]
        [ toolbar__button model baseClass "update" ToggleButtonUpdate updateButton (Color.rgb 100 255 100) 50
        , toolbar__button model baseClass "render" ToggleButtonRender renderButton (Color.rgb 100 100 255) 50
        , toolbar__button model baseClass "compile" CompileGame autorenew (Color.rgb 200 200 200) 50
        ]

toolbar__button : Model -> ClassName -> ClassName -> Msg -> MaterialIcon -> Color.Color -> Int -> Html Msg
toolbar__button model baseClass subClass msg icon color size =
    div [ class (baseClass ++ " " ++ subClass), onClick msg ]
        [ icon color size
        ]

stateUpdating : Bool -> String -> String
stateUpdating isUpdating str =
    if isUpdating then
        str ++ " isLoading"
    else
        str

stateRendering : Bool -> String -> String
stateRendering isRendering str = 
    if isRendering then
        str ++ " isRendering"
    else
        str

stateCompiling : Bool -> String -> String
stateCompiling isCompiling str = 
    if isCompiling then
        str ++ " isCompiling"
    else
        str

gameWindow : Model -> Html Msg
gameWindow model =
    div [ id "gameWindow" ]
        []