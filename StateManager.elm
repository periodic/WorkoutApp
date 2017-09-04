module StateManager exposing (Model, Msg(..), init, update, subscriptions, view)

import Dict
import Html.Events exposing (onClick)
import Html exposing (Html, div, text, h1)
import Navigation exposing (Location)

import Model.Actions exposing (..)
import Model.Model as Model
import Model.Intent exposing (..)
import Model.PredefinedPrograms.Programs exposing (allPrograms)
import View.ProgramOverview as ProgramOverview
import Router

type alias Model =
    { router : Router.Model
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

        LocationChangedMsg _ ->
            -- TODO: Using this to update the location causes a loop.
            -- Need to pass in the path and only update if the intent changes.
            (model, Cmd.none)

interpret : Action -> Model -> (Model, Cmd Msg)
interpret msg model =
    case msg of
        RoutingAction action ->
            let
                (router_, cmd) = Router.interpret action model.router
            in
               ({ model | router = router_ }, Cmd.map RouterMsg cmd)


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

view : Model -> Html Msg
view model =
    Router.view viewPage model.router

viewPage : Intent -> Html Msg
viewPage page =
    case page of
        ListProgramsIntent ->
            viewProgramList
        ViewProgramIntent program ->
            viewProgram program

viewProgramList : Html Msg
viewProgramList =
    div []
        (List.map viewProgramListItem allPrograms)

viewProgramListItem : Model.TrainingProgram -> Html Msg
viewProgramListItem program =
    div [ onClick <| CallbackMsg (RoutingAction (ViewProgramAction program)) ]
        [ text <| program.name ]

viewProgram : Model.TrainingProgram -> Html Msg
viewProgram program =
    div []
        [ h1 [] [ text program.name ]
        ]
