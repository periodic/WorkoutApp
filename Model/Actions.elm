module Model.Actions exposing (..)

import Model.Model as Model

type RoutingAction
    = ViewProgramAction Model.TrainingProgram
    | ViewAllProgramsAction

type Action
    = RoutingAction RoutingAction
