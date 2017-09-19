module StateManager exposing (Model, Msg, init, update, subscriptions, view)

import Array
import Dict
import Html.Events exposing (onClick)
import Html exposing (Html, div, text, h1)
import Navigation exposing (Location)
import Date exposing (Date)
import Task
import Monocle.Common exposing (..)
import Monocle.Optional exposing (..)

import Model.App exposing (..)
import Model.Model as Model
import Model.Utils as ModelUtils
import Model.PredefinedPrograms.Programs exposing (allPrograms, allProgramsDict)
import Router
import Interpreter.Program as ProgramInterpreter
import Interpreter.Workout as WorkoutInterpreter
import Interpreter.Set as SetInterpreter
import Interpreter.Exercise as ExerciseInterpreter
import Interpreter.Interpreter exposing (..)

import View.ProgramList as ProgramList
import View.SelectNewProgram as SelectNewProgram
import View.ProgramDetails as ProgramDetails
import View.WorkoutDetails as WorkoutDetails

type alias Model = Model.App.Model

type alias Msg = Model.App.Msg

init : Location -> (Model, Cmd Msg)
init location =
    let
        (intent, routerCmd) =
            Router.init location.pathname
        model =
            { intent = intent
            , programDict = Dict.empty
            , programIdList = []
            }
        cmd =
            Cmd.batch [routerCmd]
    in
       (model, cmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        CallbackMsg outMsg ->
            interpret outMsg model

        LocationChangedMsg location ->
            let
                intent_ = Router.update location model.intent
            in
                ({ model | intent = intent_ }, Cmd.none)
        DateForNewWorkoutMsg program lens offset date ->
            case Dict.get program.programId allProgramsDict of
                Just programDef ->
                    let
                        workout = ModelUtils.newWorkout programDef program offset date
                        program_ = { program | workouts = Array.append (Array.fromList [workout]) program.workouts }
                        programDict_ = Dict.insert program_.id program_ model.programDict
                        model_ = { model | programDict = programDict_ }
                        workoutsLens = fromLens <|
                            { get = .workouts
                            , set = \w p -> { p | workouts = w }
                            }
                        lens_ = lens => workoutsLens => array 0
                    in
                       interpret (RoutingAction <| ViewWorkoutAction programDef program_ workout lens_) model_
                Nothing ->
                    (model, Cmd.none)

interpret : Action -> Model -> (Model, Cmd Msg)
interpret msg model =
    case msg of
        RoutingAction action ->
            let
                (intent_, cmd) = Router.interpret action model.intent
            in
               ({ model | intent = intent_ }, cmd)
        SelectNewProgramAction ->
            interpret (RoutingAction ViewSelectNewProgramAction) model
        StartNewProgramAction programDef ->
            let
                programId = nextProgramId model
                program = ModelUtils.newProgramFromDef programId programDef
                model_ =
                    { model
                    | programDict = Dict.insert programId program model.programDict
                    , programIdList = programId :: model.programIdList
                    }
                routing =
                    RoutingAction ViewAllProgramsAction
            in
                interpret routing model_
        SelectProgramAction program ->
            interpret 
                (RoutingAction
                <| ViewProgramAction program (programOpt program.id))
                <| model
        ProgramAction lens action ->
            withOptional lens (ProgramInterpreter.interpret lens action) model
        WorkoutAction lens action ->
            withOptional lens (WorkoutInterpreter.interpret action) model
        SetAction lens action ->
            withOptional lens (SetInterpreter.interpret action) model
        ExerciseAction lens action ->
            withOptional lens (ExerciseInterpreter.interpret action) model

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

view : Model -> Html Msg
view model =
    Router.view (viewPage model) model.intent

viewPage : Model -> Intent -> Html Msg
viewPage model page =
    Html.map CallbackMsg
    <| case page of
        ListProgramsIntent ->
            ProgramList.view <| programList model
        SelectNewProgramIntent ->
            SelectNewProgram.view
        ViewProgramIntent program lens ->
            ProgramDetails.view lens program
        ViewWorkoutIntent programDef program workout lens ->
            WorkoutDetails.view programDef program workout lens

nextProgramId : Model -> Int
nextProgramId { programIdList } =
    List.foldr max 0 programIdList

programList : Model -> List Model.TrainingProgram
programList { programIdList, programDict } =
    List.map (flip Dict.get programDict) programIdList
    |> List.filterMap identity
