module Model.App exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Monocle.Lens exposing (Lens)
import Monocle.Optional exposing (Optional)
import Navigation exposing (Location)

import Model.Model as Model
import Model.Intent exposing (Intent)

type alias Model =
    { intent : Intent
    , programDict : Dict Int Model.TrainingProgram
    , programIdList : List Int
    }

type Msg
    = LocationChangedMsg Location
    | CallbackMsg Action
    | DateForNewWorkoutMsg Model.TrainingProgram Int Date

type RoutingAction
    = ViewAllProgramsAction
    | ViewSelectNewProgramAction
    | ViewProgramAction Model.TrainingProgram
    | ViewWorkoutAction Model.TrainingProgramDefinition Model.TrainingProgram Model.Workout

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
