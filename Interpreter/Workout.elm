module Interpreter.Workout exposing (interpret)

import Model.App exposing (..)
import Model.Model exposing (..)
import Interpreter.Interpreter exposing (..)
import Interpreter.Exercise as ExerciseInterpreter


interpret : WorkoutAction -> Workout -> (Workout, Cmd msg)
interpret action workout = 
    case action of
        FinishWorkoutAction ->
            -- TODO
            (workout, Cmd.none)
