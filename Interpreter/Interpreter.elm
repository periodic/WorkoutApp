module Interpreter.Interpreter exposing (..)

import Focus exposing (($=))
import FocusMore exposing (FieldSetter)

focusedInterpret
    : FieldSetter outer inner
    -> (action -> inner -> inner)
    -> action
    -> outer
    -> outer
focusedInterpret lens innerInterpret action outerModel =
    lens $= (innerInterpret action) <| outerModel
