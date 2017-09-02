module View.ProgramOverview exposing (view)

import Html exposing (Html, div, text, h1, button)

import Model.Model as Model

view : Model.TrainingProgram -> Html msg
view _ =
    div [] [
        text "ProgramOverview"
        ]
