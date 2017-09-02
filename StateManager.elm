module StateManager exposing (Model, Msg, init, update, subscriptions, view)

import Dict
import Html.Events exposing (onClick)
import Html exposing (Html, div, text)

import Component.MultiPage as MultiPage
import Model.Model as Model
import Model.PredefinedPrograms.TexasMethod as TexasMethod
import View.ProgramOverview as ProgramOverview

type Page
    = ProgramOverviewPage
    | WorkoutPage

type alias Model =
    { trainingProgram : Model.TrainingProgram
    , multiPage : MultiPage.Model Page
    }

type Msg
    = MultiPageMsg (MultiPage.Msg Page)
    | StartWorkoutMsg

init : (Model, Cmd Msg)
init =
    let
        (multiPage, _) = MultiPage.init ProgramOverviewPage
        model =
            { trainingProgram = TexasMethod.basicProgram
            , multiPage = multiPage
            }
        cmd =
            Cmd.none
    in
       (model, cmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        StartWorkoutMsg ->
            let
                (multiPageModel, _) = MultiPage.update (MultiPage.ChangePageMsg WorkoutPage) model.multiPage
            in
                ({ model | multiPage = multiPageModel }, Cmd.none)

        MultiPageMsg msg_ ->
            let
                (multiPageModel, _) = MultiPage.update msg_ model.multiPage
            in
                ({ model | multiPage = multiPageModel }, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

view : Model -> Html Msg
view model =
    MultiPage.view viewPage model.multiPage model.trainingProgram

viewPage : Page -> Model.TrainingProgram -> Html Msg
viewPage page =
    case page of
        ProgramOverviewPage ->
            viewOverview
        WorkoutPage ->
            viewWorkout

viewOverview : Model.TrainingProgram -> Html Msg
viewOverview _ =
    div [ onClick StartWorkoutMsg ]
        [ text "ProgramOverview" ]

viewWorkout : Model.TrainingProgram -> Html Msg
viewWorkout _ =
    div [] [ text "Workout!" ]
