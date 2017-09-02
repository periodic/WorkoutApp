module Model.Model exposing (..)

type Weight
    = Pounds Float
    | Kilograms Float

type Time
    = Seconds Float

type alias TrainingProgram =
    { name : String
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
    { exercises : List Set
    }

type alias Workout =
    { exercises : List Exercise
    }
