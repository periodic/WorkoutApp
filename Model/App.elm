module Model.App exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Focus
import FocusMore exposing (FieldSetter)
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

type WorkoutAction
    = FinishWorkoutAction
    | ExerciseAction (FieldSetter Model.Workout Model.Exercise) ExerciseAction

type ExerciseAction
    = SetAction (FieldSetter Model.Exercise Model.Set) SetAction

type SetAction
    = SetCompletedRepsAction Int

type Action
    = RoutingAction RoutingAction
    | ProgramAction Model.TrainingProgram ProgramAction
    | WorkoutAction (FieldSetter Model Model.Workout) WorkoutAction
    | SelectNewProgramAction
    | StartNewProgramAction Model.TrainingProgramDefinition
    | SelectProgramAction Model.TrainingProgram
