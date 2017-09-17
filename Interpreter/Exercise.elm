module Interpreter.Exercise exposing (interpret)

import Model.App exposing (..)
import Model.Model exposing (..)
import Interpreter.Interpreter exposing (..)
import Interpreter.Set as SetInterpreter


interpret : ExerciseAction -> Exercise -> Exercise
interpret action exercise = 
    case action of
        SetAction lens setAction ->
            focusedInterpret lens SetInterpreter.interpret setAction exercise
