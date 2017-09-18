module Interpreter.Program exposing (interpret)

import Array
import Date
import Task

import Model.App exposing (..)
import Model.Model as Model
import Model.App exposing (..)

interpret : ProgramAction -> Model.TrainingProgram -> (Model.TrainingProgram, Cmd Msg)
interpret action program =
    case action of
        StartWorkoutAction ->
            let
                offset = Array.length program.workouts
            in
               (program, Task.perform (DateForNewWorkoutMsg program offset) Date.now)
        ResumeWorkoutAction ->
            (program, Cmd.none)
