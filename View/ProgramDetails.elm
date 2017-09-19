module View.ProgramDetails exposing (view)

import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Monocle.Optional exposing (Optional)

import Model.Model as Model
import Model.App exposing (..)

view : Optional Model Model.TrainingProgram -> Model.TrainingProgram -> Html Action
view lens program =
    div
        [ class "ProgramDetails" ]
        [ startWorkoutButton lens
        , viewWorkouts program.workouts
        ]

startWorkoutButton lens =
    div
        [ class "ProgramDetails-startWorkoutButton" ]
        [ button
            [ onClick <| ProgramAction lens StartWorkoutAction ]
            [ text "Start new workout" ]
        ]

viewWorkouts workouts =
    div
        [ class "ProgramDetails-workouts" ]
        ( Array.toList <| Array.map viewWorkout workouts )

viewWorkout workout =
    div
        [ class "ProgramDetails-workout" ]
        [ div
            [ class "ProgramDetails-workoutDate" ]
            [ text <| toString workout.dateStarted ]
        , div 
            [ class "ProgramDetails-workoutStatus" ]
            [ text <| toString workout.status ]
        ]

