module Model.App exposing (Msg(..), Model)

import Date exposing (Date)
import Dict exposing (Dict)
import Model.Model as Model
import Router
import Navigation exposing (Location)
import Model.Actions exposing (..)

type alias Model =
    { router : Router.Model
    , programDict : Dict Int Model.TrainingProgram
    , programIdList : List Int
    }

type Msg
    = RouterMsg Router.Msg
    | LocationChangedMsg Location
    | CallbackMsg Action
    | DateForNewWorkoutMsg Model.TrainingProgram Int Date

