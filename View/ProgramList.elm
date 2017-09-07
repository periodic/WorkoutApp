module View.ProgramList exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model.Actions exposing (..)
import Model.Model exposing (..)
import Model.PredefinedPrograms.Programs exposing (allProgramsDict)

view : List TrainingProgram -> Html Action
view programs = 
    div
        [ class "ProgramList" ]
        [ userPrograms programs
        , actions
        ]

userPrograms : List TrainingProgram -> Html Action
userPrograms programs =
    div
        [ class "ProgramList-programs" ]
        (List.map viewProgram programs)

viewProgram : TrainingProgram -> Html Action
viewProgram program =
    let
        programDef =
            Dict.get program.programId allProgramsDict
        programName =
            Maybe.map .name programDef |> Maybe.withDefault "Unknown"

        lastWorkout =
            lastTrainingDate program
        lastWorkoutString =
            Maybe.map toString lastWorkout |> Maybe.withDefault "Never"

        nameElem =
            div
                [ class "ProgramList-programName" ]
                [ text programName ]
        dateElem =
            div
                [ class "ProgramList-programDate" ]
                [ text "Last workout: ", text lastWorkoutString ]
    in
        div
            [ class "ProgramList-program"
            , onClick <| SelectProgramAction program
            ]
            [ nameElem
            , dateElem
            ]

actions : Html Action
actions =
    div
        [ class "ProgramList-actions" ]
        [ button
            [ class "ProgramList-newProgramButton"
            , onClick SelectNewProgramAction
            ]
            [ text "Start a New Program" ]
        ]

