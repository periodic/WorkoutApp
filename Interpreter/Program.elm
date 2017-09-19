module Interpreter.Program exposing (interpret)

import Array
import Date
import Task
import Monocle.Optional exposing (Optional)

import Model.App exposing (..)
import Model.Model as Model
import Model.App exposing (..)

interpret : Optional Model Model.TrainingProgram -> ProgramAction -> Model.TrainingProgram -> (Model.TrainingProgram, Cmd Msg)
interpret lens action program =
    case action of
        StartWorkoutAction ->
            let
                offset = Array.length program.workouts
            in
               (program, Task.perform (DateForNewWorkoutMsg program lens offset) Date.now)
        ResumeWorkoutAction ->
            (program, Cmd.none)
