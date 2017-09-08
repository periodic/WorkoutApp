module View.WorkoutDetails exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model.Actions exposing (..)
import Model.Model as Model

view : Model.TrainingProgramDefinition -> Model.TrainingProgram -> Model.Workout -> Html WorkoutAction
view programDef program workout =
    h1 [] [ text "Workout" ]
