module View.WorkoutDetails exposing (view)

import Array exposing (Array)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Monocle.Lens exposing (Lens)
import Monocle.Optional exposing (..)
import Monocle.Common exposing (..)

import Model.App exposing (..)
import Model.Model as Model

view : Model.TrainingProgramDefinition
    -> Model.TrainingProgram
    -> Model.Workout
    -> Optional Model Model.Workout
    -> Html Action
view programDef program workout lens =
    let
        exercisesLens : Optional Model.Workout (Array Model.Exercise)
        exercisesLens = fromLens <|
            { get = .exercises
            , set = \es w -> { w | exercises = es }
            }
        exerciseLens i =
            lens => exercisesLens => array i
        viewExercises =
            Array.toList << Array.indexedMap
                (\i exercise ->
                    viewExercise exercise (exerciseLens i))
    in
        div
            [ class "WorkoutDetails" ]
            [ h1 [] [ text <| toString workout.dateStarted ]
            , div
                [ class "WorkoutDetails-workouts" ]
                ( viewExercises workout.exercises )
            ]


viewExercise : Model.Exercise -> Optional Model Model.Exercise -> Html Action
viewExercise exercise lens =
    let
        warmupSetsLens = fromLens <|
            { get = .warmupSets
            , set = \sets exercise -> { exercise | warmupSets = sets }
            }
        workingSetsLens = fromLens <|
            { get = .workingSets
            , set = \sets exercise -> { exercise | workingSets = sets }
            }
        viewSets : Optional Model.Exercise (Array Model.Set) -> Array Model.Set -> List (Html Action)
        viewSets setter =
            Array.toList << Array.indexedMap
                (\i set -> viewSet set <| lens => setter => array i)
    in
        div
            [ class "WorkoutDetails-workout" ]
            [ h2 [] [ text exercise.name ]
            , div
                [ class "WorkoutDetails-warmupSets" ]
                ((h3 [] [ text "Warmup" ]) :: viewSets warmupSetsLens exercise.warmupSets )
            , div
                [ class "WorkoutDetails.workingSets" ]
                ((h3 [] [ text "Working" ]) :: viewSets workingSetsLens exercise.workingSets )
            ]

viewSet : Model.Set -> Optional Model Model.Set -> Html Action
viewSet { weight, targetReps, completedReps } setter =
    let
        repsOnClick =
            if completedReps == 0
                then targetReps
                else completedReps - 1
    in
        div
            [ class "WorkoutDetails-set" ]
            [ div
                [ class "WorkoutDetails-weight" ]
                [ text "Target weight: "
                , text <| toString weight
                ]
            , div
                [ class "WorkoutDetails-reps"
                , onClick <| SetAction setter <| SetCompletedRepsAction repsOnClick
                ]
                [ text <| toString completedReps
                , text "/"
                , text <| toString targetReps
                ]
            ]
