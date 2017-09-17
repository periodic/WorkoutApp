module Interpreter.Set exposing (interpret)

import Focus exposing ((.=))

import Model.App exposing (..)
import Model.Model exposing (..)

completedLens f set = { set | completedReps = f set.completedReps }

interpret : SetAction -> Set -> Set
interpret action model =
    case action of
        SetCompletedRepsAction int ->
            completedLens .= int <| model
