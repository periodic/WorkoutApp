module View.ProgramDetails exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model.Model as Model
import Model.App exposing (..)

view : Model.TrainingProgram -> Html ProgramAction
view program =
    div
        [ class "ProgramDetails" ]
        [ startWorkoutButton program
        , viewWorkouts program.workouts
        ]

startWorkoutButton program =
    div
        [ class "ProgramDetails-startWorkoutButton" ]
        [ button
            [ onClick <| StartWorkoutAction ]
            [ text "Start new workout" ]
        ]

viewWorkouts workouts =
    div
        [ class "ProgramDetails-workouts" ]
        ( List.map viewWorkout workouts )

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

