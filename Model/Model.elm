module Model.Model exposing (..)

import Array exposing (Array)
import Dict exposing (Dict)
import Date exposing (Date)

type alias Weight = Float

type Time
    = Seconds Float

type alias TrainingProgramDefinition =
    { id : String
    , name : String
    , exercises : Array
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
    , workingSets : Array SetDefinition
    , warmupSets : Array SetDefinition
    , restDuration : Time
    }

type alias Set =
    { weight : Weight
    , targetReps : Int
    , completedReps : Int
    }

type alias Exercise =
    { name : String
    , warmupSets : Array Set
    , workingSets : Array Set
    , restDuration : Time
    }

type WorkoutStatus
    = CompleteWorkoutStatus
    | IncompleteWorkoutStatus
    | InProgressWorkoutStatus
    | SkippedWorkoutStatus

type alias Workout =
    { exercises : Array Exercise
    , dateStarted : Date
    , offset : Int
    , status : WorkoutStatus
    }

type alias TrainingProgram =
    { id : Int
    , programId : String
    , workouts : Array Workout
    , startingWeights : Dict String Weight
    }
