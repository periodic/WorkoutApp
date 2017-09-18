module Model.PredefinedPrograms.TexasMethod exposing (basicProgram)

import Array exposing (Array, fromList)
import Model.Model exposing (..)

bar : Weight
bar = 45

percentOfWorkingWeight : Float -> WeightDefinition -> WeightDefinition
percentOfWorkingWeight percent working =
    let
        plates = MaxOf (Fixed (0)) (Subtract bar working)
    in
       Add bar (Percentage percent plates)

warmupSets : WeightDefinition -> Array SetDefinition
warmupSets working = fromList
    [ { weight = Fixed bar, reps = 10 }
    , { weight = percentOfWorkingWeight 0.25 working, reps = 5 }
    , { weight = percentOfWorkingWeight 0.50 working, reps = 3 }
    , { weight = percentOfWorkingWeight 0.75 working, reps = 2 }
    ]

exercise : String -> Int -> Int -> WeightDefinition -> ExerciseDefinition
exercise name sets reps workingWeight =
    { name = name
    , workingSets = Array.repeat sets { weight = workingWeight, reps = reps }
    , warmupSets = warmupSets workingWeight
    , restDuration = Seconds 90
    }

volume : String -> ExerciseDefinition
volume name =
    exercise name 5 5 <| Percentage 0.9 <| RepMax 5

intensity : String -> ExerciseDefinition
intensity name =
    exercise name 1 5 <| Add 5 <| RepMax 5

basicProgram : TrainingProgramDefinition
basicProgram =
    { id = "texas-method-basic"
    , name = "Texas Method"
    , exercises = fromList
        [ { exercise = volume "Squat"
          , repeatEvery = 3
          , repeatOffset = 0
          }
        , { exercise = volume "Benchpress"
          , repeatEvery = 6
          , repeatOffset = 0
          }
        , { exercise = volume "Overhead Press"
          , repeatEvery = 6
          , repeatOffset = 3
          }
        , { exercise = exercise "Squat" 2 5 (Percentage 0.8 (RepMax 5))
          , repeatEvery = 3
          , repeatOffset = 1
          }
        , { exercise = exercise "Benchpress" 3 5 (Percentage 0.9 (RepMax 5))
          , repeatEvery = 6
          , repeatOffset = 4
          }
        , { exercise = exercise "Overhead Press" 3 5 (Percentage 0.9 (RepMax 5))
          , repeatEvery = 6
          , repeatOffset = 1
          }
        , { exercise = intensity "Squat"
          , repeatEvery = 3
          , repeatOffset = 2
          }
        , { exercise = intensity "Benchpress"
          , repeatEvery = 6
          , repeatOffset = 2
          }
        , { exercise = intensity "Overhead Press"
          , repeatEvery = 6
          , repeatOffset = 5
          }
        ]
    }
