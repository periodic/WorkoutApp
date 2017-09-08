module Model.Actions exposing (..)

import Model.Model as Model

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

type Action
    = RoutingAction RoutingAction
    | ProgramAction Model.TrainingProgram ProgramAction
    | WorkoutAction Model.TrainingProgram Model.Workout WorkoutAction
    | SelectNewProgramAction
    | StartNewProgramAction Model.TrainingProgramDefinition
    | SelectProgramAction Model.TrainingProgram
