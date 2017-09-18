module Interpreter.Interpreter exposing (..)

import Monocle.Optional exposing (Optional)

withOptional : Optional b a -> (a -> (a, Cmd msg)) -> b -> (b, Cmd msg)
withOptional lens updater model =
    case lens.getOption model of
        Just inner ->
            let
                (a_, cmd) = updater inner
            in
                (lens.set a_ model, cmd)
        Nothing ->
            (model, Cmd.none)
