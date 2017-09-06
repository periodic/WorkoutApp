module View.SelectNewProgram exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model.Actions exposing (..)
import Model.Model as Model
import Model.PredefinedPrograms.Programs exposing (allPrograms)


view : Html Action
view =
    div
        [ class "StartNewProgram" ]
        [ h1 [] [ text "Start a new program" ]
        , div [] [ text "Select a program..." ]
        , programList
        ]


programList : Html Action
programList =
    ul
        [ class "StartNewProgram-programList" ]
        (List.map programItem allPrograms)

programItem : Model.TrainingProgramDefinition -> Html Action
programItem program =
    li
        [ class "StartNewProgram-programItem"
        , onClick <| StartNewProgramAction program
        ]
        [ text program.name ]

