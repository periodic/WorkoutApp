module View.Root exposing (view)

import Model.Model as Model
import StateManager
import Html exposing (..)


view : StateManager.Model -> Html StateManager.Msg
view _ =
    div [] [ text "Hello!" ]
