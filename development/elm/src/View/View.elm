module View.View exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (id, class)

import Messages exposing (Msg(..))
import Model exposing (..)
import View.Toolbar.ViewToolbar as ViewToolbar
import View.Toolbar.ToolbarModel exposing (displayGamePackage)
import View.GameWindow.ViewGameWindow exposing (gameWindow)

view : Model -> Html Msg
view model =
    div []
        [ ViewToolbar.toolbar model
        , gameWindow model
        , div [ id "gamePackageContainers", class "p1" ]
            [ displayGamePackage "Models" model.modelPackages
            , displayGamePackage "Systems" model.systemPackages
            , displayGamePackage "Sprites" model.spritePackages
            ]
        ]