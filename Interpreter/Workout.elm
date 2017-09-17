module Interpreter.Workout exposing (interpret)

import Model.Actions exposing (..)
import Model.Model exposing (..)
import Interpreter.Interpreter exposing (..)
import Interpreter.Exercise as ExerciseInterpreter


interpret : WorkoutAction -> Workout -> Workout
interpret action workout = 
    case action of
        ExerciseAction lens exerciseAction ->
            focusedInterpret lens ExerciseInterpreter.interpret exerciseAction workout
        FinishWorkoutAction ->
            workout
