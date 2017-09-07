module StateManager exposing (Model, Msg(..), init, update, subscriptions, view)

import Dict exposing (Dict)
import Html.Events exposing (onClick)
import Html exposing (Html, div, text, h1)
import Navigation exposing (Location)

import Model.Actions exposing (..)
import Model.Model as Model
import Model.Intent exposing (..)
import Model.PredefinedPrograms.Programs exposing (allPrograms)
import Router

import View.ProgramList as ProgramList
import View.SelectNewProgram as SelectNewProgram
import View.ProgramDetails as ProgramDetails

type alias Model =
    { router : Router.Model
    , programDict : Dict Int Model.TrainingProgram
    , programIdList : List Int
    }

type Msg
    = RouterMsg Router.Msg
    | LocationChangedMsg Location
    | CallbackMsg Action

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
                program = Model.newProgramFromDef programId programDef
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

nextProgramId : Model -> Int
nextProgramId { programIdList } =
    List.foldr max 0 programIdList

programList : Model -> List Model.TrainingProgram
programList { programIdList, programDict } =
    List.map (flip Dict.get programDict) programIdList
    |> List.filterMap identity
