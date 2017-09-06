module Model.Actions exposing (..)

import Model.Model as Model

type RoutingAction
    = ViewAllProgramsAction
    | ViewSelectNewProgramAction

type Action
    = RoutingAction RoutingAction
    | SelectNewProgramAction
    | StartNewProgramAction Model.TrainingProgramDefinition
