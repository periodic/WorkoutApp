module Main exposing (main)

import Html
import Navigation

import StateManager

main : Program Never StateManager.Model StateManager.Msg
main = Navigation.program StateManager.LocationChangedMsg
    { init = StateManager.init
    , update = StateManager.update
    , subscriptions = StateManager.subscriptions
    , view = StateManager.view
    }
