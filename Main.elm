module Main exposing (main)

import Html
import Navigation

import StateManager

main : Program Never StateManager.Model StateManager.Msg
-- TODO: Stop ignoring locations.
main = Navigation.program StateManager.LocationChangedMsg
    { init = StateManager.init
    , update = StateManager.update
    , subscriptions = StateManager.subscriptions
    , view = StateManager.view
    }
