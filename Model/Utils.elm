module Model.Utils exposing (..)

import Array exposing (Array)
import Dict exposing (Dict)
import Date.Extra.Compare as Date
import Date exposing (Date)

import Model.Model exposing (..)
import Model.PredefinedPrograms.Programs as Programs

lastTrainingDate : TrainingProgram -> Maybe Date
lastTrainingDate { workouts } =
    let
        compareDate workout mDate =
            case mDate of 
                Nothing ->
                    Just workout.dateStarted
                Just date ->
                    Just
                    <| if Date.is Date.After workout.dateStarted date
                        then workout.dateStarted
                        else date
    in
       Array.foldr compareDate Nothing workouts


newProgramFromDef : Int -> TrainingProgramDefinition -> TrainingProgram
newProgramFromDef id def =
    { id = id
    , programId = def.id
    , workouts = Array.empty
    , startingWeights = Dict.empty -- TODO
    }

newWorkout : TrainingProgramDefinition -> TrainingProgram -> Int -> Date -> Workout
newWorkout programDef program offset date =
    let
        exerciseDefs = exercisesForWorkout offset programDef
        exerciseFromDef { name, workingSets, warmupSets, restDuration } =
            { name = name
            , warmupSets = Array.map (setFromDef name) warmupSets
            , workingSets = Array.map (setFromDef name) workingSets
            , restDuration = restDuration
            }
        setFromDef name { weight, reps } =
            { weight = weightFromDef program name weight
            , targetReps = reps
            , completedReps = 0
            }
    in
        { exercises = Array.map exerciseFromDef exerciseDefs
        , dateStarted = date
        , offset = offset
        , status = InProgressWorkoutStatus
        }

exercisesForWorkout : Int -> TrainingProgramDefinition -> Array ExerciseDefinition
exercisesForWorkout offset programDef =
    let
        isInWorkout { exercise, repeatEvery, repeatOffset } =
            offset % repeatEvery == repeatOffset
    in
        Array.filter isInWorkout programDef.exercises |> Array.map .exercise

weightFromDef : TrainingProgram -> String -> WeightDefinition -> Weight
weightFromDef program exerciseName weightDef =
    case weightDef of
        RepMax count ->
            program.workouts
            |> Array.toList
            |> List.concatMap (\w -> Array.toList w.exercises)
            |> List.filter (\e -> e.name == exerciseName)
            |> List.concatMap (\e -> Array.toList e.workingSets)
            |> List.filter (\s -> s.completedReps >= count)
            |> List.map (\s -> s.weight)
            |> List.maximum
            |> Maybe.withDefault (Dict.get exerciseName program.startingWeights |> Maybe.withDefault 45)
        Fixed weight ->
            weight
        Percentage pct def ->
            pct * weightFromDef program exerciseName def
        Add w def ->
            w + weightFromDef program exerciseName def
        Subtract w def ->
            weightFromDef program exerciseName def - w
        RoundUp modulus def ->
            modulus * (toFloat <| ceiling (weightFromDef program exerciseName def / modulus))
        RoundDown modulus def ->
            modulus * (toFloat <| floor (weightFromDef program exerciseName def / modulus))
        MaxOf w1 w2 ->
            max (weightFromDef program exerciseName w1) (weightFromDef program exerciseName w2)
        MinOf w1 w2 ->
            min (weightFromDef program exerciseName w1) (weightFromDef program exerciseName w2)
