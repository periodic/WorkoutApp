module View.WorkoutDetails exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model.Actions exposing (..)
import Model.Model as Model

view : Model.TrainingProgramDefinition -> Model.TrainingProgram -> Model.Workout -> Html WorkoutAction
view programDef program workout =
    div
        [ class "WorkoutDetails" ]
        [ h1 [] [ text <| toString workout.dateStarted ]
        , div
            [ class "WorkoutDetails-workouts" ]
            ( List.map viewExercise workout.exercises )
        ]


viewExercise : Model.Exercise -> Html WorkoutAction
viewExercise exercise =
    div
        [ class "WorkoutDetails-workout" ]
        [ h2 [] [ text exercise.name ]
        , div
            [ class "WorkoutDetails-warmupSets" ]
            ((h3 [] [ text "Warmup" ]) :: ( List.map viewSet exercise.warmupSets ))
        , div
            [ class "WorkoutDetails.workingSets" ]
            ((h3 [] [ text "Working" ]) :: ( List.map viewSet exercise.workingSets ))
        ]

viewSet : Model.Set -> Html WorkoutAction
viewSet { weight, targetReps, completedReps } =
    div
        [ class "WorkoutDetails-set" ]
        [ div
            [ class "WorkoutDetails-weight" ]
            [ text "Target weight: "
            , text <| toString weight
            ]
        , div
            [ class "WorkoutDetails-reps" ]
            [ text <| toString completedReps
            , text "/"
            , text <| toString targetReps
            ]
        ]
