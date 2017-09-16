module Main exposing (main)

import Html
import Navigation

import StateManager
import Model.App as App

main : Program Never App.Model App.Msg
main = Navigation.program App.LocationChangedMsg
    { init = StateManager.init
    , update = StateManager.update
    , subscriptions = StateManager.subscriptions
    , view = StateManager.view
    }
