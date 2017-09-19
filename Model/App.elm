module Model.App exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Monocle.Lens exposing (Lens)
import Monocle.Optional exposing (Optional)
import Navigation exposing (Location)

import Model.Model as Model

type alias Model =
    { intent : Intent
    , programDict : Dict Int Model.TrainingProgram
    , programIdList : List Int
    }

intentLens =
    { get = .intent
    , set = \i m -> { m | intent = i }
    }
programDictLens =
    { get = .programDict
    , set = \i m -> { m | programDict = i }
    }
programIdListLens =
    { get = .programIdList
    , set = \i m -> { m | programIdList = i }
    }

programOpt programId =
    { getOption = .programDict >> Dict.get programId
    , set = \p m -> { m | programDict = Dict.insert programId p m.programDict }
    }

type Msg
    = LocationChangedMsg Location
    | CallbackMsg Action
    | DateForNewWorkoutMsg Model.TrainingProgram (Optional Model Model.TrainingProgram) Int Date

type RoutingAction
    = ViewAllProgramsAction
    | ViewSelectNewProgramAction
    | ViewProgramAction Model.TrainingProgram (Optional Model Model.TrainingProgram)
    | ViewWorkoutAction Model.TrainingProgramDefinition Model.TrainingProgram Model.Workout (Optional Model Model.Workout)

type ProgramAction
    = ResumeWorkoutAction
    | StartWorkoutAction

type ExerciseAction
    = SkipExerciseAction

type WorkoutAction
    = FinishWorkoutAction

type SetAction
    = SetCompletedRepsAction Int

type Action
    = RoutingAction RoutingAction
    | ProgramAction (Optional Model Model.TrainingProgram) ProgramAction
    | WorkoutAction (Optional Model Model.Workout) WorkoutAction
    | ExerciseAction (Optional Model Model.Exercise) ExerciseAction
    | SetAction (Optional Model Model.Set) SetAction
    | SelectNewProgramAction
    | StartNewProgramAction Model.TrainingProgramDefinition
    | SelectProgramAction Model.TrainingProgram

type Intent
    = ListProgramsIntent
    | SelectNewProgramIntent
    | ViewProgramIntent Model.TrainingProgram (Optional Model Model.TrainingProgram)
    | ViewWorkoutIntent Model.TrainingProgramDefinition Model.TrainingProgram Model.Workout (Optional Model Model.Workout) 
