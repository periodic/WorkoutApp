module Interpreter.Set exposing (interpret)

import Monocle.Lens exposing (Lens)

import Model.App exposing (..)
import Model.Model exposing (..)

completedLens : Lens Set Int
completedLens =
    { get = .completedReps
    , set = \reps set -> { set | completedReps = reps }
    }

interpret : SetAction -> Set -> (Set, Cmd msg)
interpret action set =
    case action of
        SetCompletedRepsAction int ->
            (completedLens.set int set, Cmd.none)
