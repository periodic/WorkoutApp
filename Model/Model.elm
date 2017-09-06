module Model.Model exposing (..)

import Dict exposing (Dict)
import Date.Extra.Compare as Date
import Date exposing (Date)

type Weight
    = Pounds Float
    | Kilograms Float

type Time
    = Seconds Float

type alias TrainingProgramDefinition =
    { id : String
    , name : String
    , exercises : List
        { exercise : ExerciseDefinition
        , repeatEvery : Int
        , repeatOffset : Int
        }
    }

type WeightDefinition
    = RepMax Int
    | Fixed Weight
    | Percentage Float WeightDefinition
    | Add Weight WeightDefinition
    | Subtract Weight WeightDefinition
    | RoundUp Weight WeightDefinition
    | RoundDown Weight WeightDefinition
    | MaxOf WeightDefinition WeightDefinition
    | MinOf WeightDefinition WeightDefinition

type alias SetDefinition =
    { weight : WeightDefinition
    , reps : Int
    }

type alias  ExerciseDefinition =
    { name : String
    , workingSets : List SetDefinition
    , warmupSets : List SetDefinition
    , restDuration : Time
    }

type alias Set =
    { weight : Weight
    , reps : Int
    }

type alias Exercise =
    { exercises : Dict String (List Set)
    }

type WorkoutStatus
    = CompleteWorkoutStatus
    | IncompleteWorkoutStatus
    | InProgressWorkoutStatus
    | SkippedWorkoutStatus

type alias Workout =
    { exercises : List Exercise
    , date_started : Date
    , status : WorkoutStatus
    }

type alias TrainingProgram =
    { programId : String
    , workouts : List Workout
    }

lastTrainingDate : TrainingProgram -> Maybe Date
lastTrainingDate { workouts } =
    let
        compareDate workout mDate =
            case mDate of 
                Nothing ->
                    Just workout.date_started
                Just date ->
                    Just
                    <| if Date.is Date.After workout.date_started date
                        then workout.date_started
                        else date
    in
       List.foldr compareDate Nothing workouts


newProgramFromDef : TrainingProgramDefinition -> TrainingProgram
newProgramFromDef def =
    { programId = def.id
    , workouts = []
    }
