module Model.Actions exposing (..)

import Model.Model as Model

type RoutingAction
    = ViewAllProgramsAction
    | ViewSelectNewProgramAction
    | ViewProgramAction Model.TrainingProgram

type ProgramAction
    = ResumeWorkoutAction 
    | StartWorkoutAction

type Action
    = RoutingAction RoutingAction
    | ProgramAction Model.TrainingProgram ProgramAction
    | SelectNewProgramAction
    | StartNewProgramAction Model.TrainingProgramDefinition
    | SelectProgramAction Model.TrainingProgram
