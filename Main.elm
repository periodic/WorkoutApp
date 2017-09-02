module Main exposing (main)

import StateManager
import View.Root as Root
import Html


main : Program Never StateManager.Model StateManager.Msg
main = Html.program
    { init = StateManager.init
    , update = StateManager.update
    , subscriptions = StateManager.subscriptions
    , view = StateManager.view
    }
