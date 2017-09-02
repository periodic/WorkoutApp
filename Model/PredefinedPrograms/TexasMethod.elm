module Model.PredefinedPrograms.TexasMethod exposing (basicProgram)

import Model.Model exposing (..)

bar : Weight
bar = Pounds 45

percentOfWorkingWeight : Float -> WeightDefinition -> WeightDefinition
percentOfWorkingWeight percent working =
    let
        plates = MaxOf (Fixed (Pounds 0)) (Subtract bar working)
    in
       Add bar (Percentage percent plates)

warmupSets : WeightDefinition -> List SetDefinition
warmupSets working =
    [ { weight = Fixed bar, reps = 10 }
    , { weight = percentOfWorkingWeight 0.25 working, reps = 5 }
    , { weight = percentOfWorkingWeight 0.50 working, reps = 3 }
    , { weight = percentOfWorkingWeight 0.75 working, reps = 2 }
    ]

exercise : String -> Int -> Int -> WeightDefinition -> ExerciseDefinition
exercise name sets reps workingWeight =
    { name = name
    , workingSets = List.repeat sets { weight = workingWeight, reps = reps }
    , warmupSets = warmupSets workingWeight
    , restDuration = Seconds 90
    }

volume : String -> ExerciseDefinition
volume name =
    exercise name 5 5 <| Percentage 0.9 <| RepMax 5

intensity : String -> ExerciseDefinition
intensity name =
    exercise name 1 5 <| Add (Pounds 5) <| RepMax 5

basicProgram : TrainingProgram
basicProgram =
    { name = "Texas Method"
    , exercises =
        [ { exercise = volume "Squat"
          , repeatEvery = 3
          , repeatOffset = 0
          }
        , { exercise = volume "Benchpress"
          , repeatEvery = 3
          , repeatOffset = 0
          }
        , { exercise = volume "Overhead Press"
          , repeatEvery = 3
          , repeatOffset = 3
          }
        , { exercise = exercise "Squat" 2 5 (Percentage 0.8 (RepMax 5))
          , repeatEvery = 3
          , repeatOffset = 1
          }
        , { exercise = exercise "Benchpress" 3 5 (Percentage 0.9 (RepMax 5))
          , repeatEvery = 3
          , repeatOffset = 4
          }
        , { exercise = exercise "Overhead Press" 3 5 (Percentage 0.9 (RepMax 5))
          , repeatEvery = 1
          , repeatOffset = 3
          }
        , { exercise = intensity "Squat"
          , repeatEvery = 3
          , repeatOffset = 2
          }
        , { exercise = intensity "Benchpress"
          , repeatEvery = 3
          , repeatOffset = 2
          }
        , { exercise = intensity "Overhead Press"
          , repeatEvery = 1
          , repeatOffset = 5
          }
        ]
    }
