module Model.Actions exposing (..)

import Model.Model as Model
import Focus
import FocusMore exposing (FieldSetter)

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
    | WorkoutAction (FieldSetter Model.TrainingProgram Model.Workout) WorkoutAction
    | SelectNewProgramAction
    | StartNewProgramAction Model.TrainingProgramDefinition
    | SelectProgramAction Model.TrainingProgram
