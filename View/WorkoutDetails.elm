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
                    Html.map (ExerciseAction <| exerciseLens i) <| viewExercise exercise (exerciseLens i))
    in
        div
            [ class "WorkoutDetails" ]
            [ h1 [] [ text <| toString workout.dateStarted ]
            , div
                [ class "WorkoutDetails-workouts" ]
                ( viewExercises workout.exercises )
            ]


viewExercise : Model.Exercise -> Optional Model Model.Exercise -> Html ExerciseAction
viewExercise exercise lens =
    let
        warmupSetsLens =
            { get = .warmupSets
            , set = \sets exercise -> { exercise | warmupSets = sets }
            }
        workingSetsLens =
            { get = .workingSets
            , set = \sets exercise -> { exercise | workingSets = sets }
            }
        viewSets : Lens Model.Exercise (Array Model.Set) -> Array Model.Set -> List (Html Action)
        viewSets setter =
            Array.toList << Array.indexedMap
                (\i set -> Html.map (SetAction <| lens => setter => array i) <| viewSet set)
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

viewSet : Model.Set -> Html SetAction
viewSet { weight, targetReps, completedReps } =
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
                , onClick <| SetCompletedRepsAction repsOnClick
                ]
                [ text <| toString completedReps
                , text "/"
                , text <| toString targetReps
                ]
            ]
