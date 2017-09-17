module View.WorkoutDetails exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Focus exposing ((=>))
import FocusMore as FM exposing (FieldSetter)

import Model.App exposing (..)
import Model.Model as Model

view : Model.TrainingProgramDefinition -> Model.TrainingProgram -> Model.Workout -> Html WorkoutAction
view programDef program workout =
    let
        exercisesLens f w =
            { w | exercises = f w.exercises }
        viewExercises =
            List.indexedMap
                (\i exercise ->
                    Html.map (ExerciseAction <| exercisesLens => FM.index i) <| viewExercise exercise)
    in
        div
            [ class "WorkoutDetails" ]
            [ h1 [] [ text <| toString workout.dateStarted ]
            , div
                [ class "WorkoutDetails-workouts" ]
                ( viewExercises workout.exercises )
            ]


viewExercise : Model.Exercise -> Html ExerciseAction
viewExercise exercise =
    let
        warmupSetsLens f exercise =
            { exercise | warmupSets = f exercise.warmupSets }
        workingSetsLens f exercise =
            { exercise | workingSets = f exercise.workingSets }
        viewSets : FieldSetter Model.Exercise (List Model.Set) -> List Model.Set -> List (Html ExerciseAction)
        viewSets setter =
            List.indexedMap
                (\i set -> Html.map (SetAction <| setter => FM.index i) <| viewSet set)
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
