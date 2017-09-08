module StateManager exposing (Model, Msg(..), init, update, subscriptions, view)

import Dict exposing (Dict)
import Html.Events exposing (onClick)
import Html exposing (Html, div, text, h1)
import Navigation exposing (Location)
import Date exposing (Date)
import Task

import Model.Actions exposing (..)
import Model.Model as Model
import Model.Utils as ModelUtils
import Model.Intent exposing (..)
import Model.PredefinedPrograms.Programs exposing (allPrograms, allProgramsDict)
import Router

import View.ProgramList as ProgramList
import View.SelectNewProgram as SelectNewProgram
import View.ProgramDetails as ProgramDetails
import View.WorkoutDetails as WorkoutDetails

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

init : Location -> (Model, Cmd Msg)
init location =
    let
        (router, routerCmd) =
            Router.init location.pathname
        model =
            { router = router
            , programDict = Dict.empty
            , programIdList = []
            }
        cmd =
            Cmd.batch [Cmd.map RouterMsg routerCmd]
    in
       (model, cmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        RouterMsg msg_ ->
            let
                (router, cmd) = Router.update msg_ model.router
            in
                ({ model | router = router }, Cmd.map RouterMsg cmd)

        CallbackMsg outMsg ->
            interpret outMsg model

        LocationChangedMsg location ->
            let
                (router, cmd) = Router.update (Router.LocationChangedMsg location.pathname) model.router
            in
                ({ model | router = router }, Cmd.map RouterMsg cmd)
        DateForNewWorkoutMsg program offset date ->
            let
                workout = ModelUtils.newWorkout offset date
                program_ = { program | workouts = workout :: program.workouts }
                programDict_ = Dict.insert program_.id program_ model.programDict
                model_ = { model | programDict = programDict_ }
            in
                case Dict.get program_.programId allProgramsDict of
                    Just programDef ->
                        interpret (RoutingAction <| ViewWorkoutAction programDef program_ workout) model_
                    Nothing ->
                        interpret (RoutingAction <| ViewProgramAction program_) model



interpret : Action -> Model -> (Model, Cmd Msg)
interpret msg model =
    case msg of
        RoutingAction action ->
            let
                (router_, cmd) = Router.interpret action model.router
            in
               ({ model | router = router_ }, Cmd.map RouterMsg cmd)
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
           interpret (RoutingAction <| ViewProgramAction program) model
        ProgramAction program action ->
            case action of
                StartWorkoutAction ->
                    let
                        offset = List.length program.workouts
                    in
                        (model, Task.perform (DateForNewWorkoutMsg program offset) Date.now)
                ResumeWorkoutAction ->
                    (model, Cmd.none)
        WorkoutAction program workout action ->
            (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

view : Model -> Html Msg
view model =
    Router.view (viewPage model) model.router

viewPage : Model -> Intent -> Html Msg
viewPage model page =
    Html.map CallbackMsg
    <| case page of
        ListProgramsIntent ->
            ProgramList.view <| programList model
        SelectNewProgramIntent ->
            SelectNewProgram.view
        ViewProgramIntent program ->
           Html.map (ProgramAction program) <| ProgramDetails.view program
        ViewWorkoutIntent programDef program workout ->
           Html.map (WorkoutAction program workout) <| WorkoutDetails.view programDef program workout

nextProgramId : Model -> Int
nextProgramId { programIdList } =
    List.foldr max 0 programIdList

programList : Model -> List Model.TrainingProgram
programList { programIdList, programDict } =
    List.map (flip Dict.get programDict) programIdList
    |> List.filterMap identity
