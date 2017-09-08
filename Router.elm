module Router exposing (Msg(..), Model, init, update, interpret, view, intentToPath, pathToIntent)

import Dict
import Html exposing (Html)
import Set
import Navigation exposing (Location)
import Combine exposing (Parser, (<$>), (<*), (*>), (<*>), (<|>), (<?>), (<$), ($>))

import Model.Actions exposing (..)
import Model.Intent exposing (..)
import Model.PredefinedPrograms.Programs exposing (allProgramsDict)

type Msg
    = LocationChangedMsg String

type Model
    = Model Intent

init : String -> (Model, Cmd Msg)
init path =
    let
        intent = pathToIntent path
    in
        (Model intent, Navigation.modifyUrl (intentToPath intent))

navigateTo : Intent -> (Model, Cmd Msg)
navigateTo intent =
    (Model intent, Navigation.newUrl (intentToPath intent))

intentToPath : Intent -> String
intentToPath intent =
    case intent of
        ListProgramsIntent ->
            "/programs"
        SelectNewProgramIntent ->
            "/programs/start"
        ViewProgramIntent program ->
            "/programs/" ++ toString program.id
        ViewWorkoutIntent _ program workout->
            "/programs/" ++ toString program.id ++ "/workout/" ++ toString workout.offset

pathToIntent : String -> Intent
pathToIntent path =
    parsePath path |> Result.withDefault ListProgramsIntent

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case (msg, model) of
        (LocationChangedMsg path, Model intent) ->
            {-
            let
                intent_ = pathToIntent path
            in
               if intent_ /= intent
                  then (Model intent_, Cmd.none)
                  else (model, Cmd.none)
                  -}
            (model, Cmd.none)

interpret : RoutingAction -> Model -> (Model, Cmd Msg)
interpret outMsg model =
    case outMsg of
        ViewAllProgramsAction ->
            navigateTo ListProgramsIntent
        ViewSelectNewProgramAction ->
            navigateTo SelectNewProgramIntent
        ViewProgramAction program ->
            navigateTo <| ViewProgramIntent program
        ViewWorkoutAction programDef program workout ->
            navigateTo <| ViewWorkoutIntent programDef program workout

view : (Intent -> Html msg) -> Model -> Html msg
view views model =
    case model of
        Model intent ->
            views intent

-- Parser
----------------------------------------
parsePath : String -> Result String Intent
parsePath path =
    case Combine.parse pathParser path of
        Ok (_, _, result) ->
            Ok result
        Err (_, _, errors) ->
            Err (String.join " or " << Set.toList << Set.fromList <| errors)

pathParser : Parser s Intent
pathParser =
    listProgramsParser <|> newProgramParser

listProgramsParser : Parser s Intent
listProgramsParser =
    (pathSep
    *> Combine.string "programs"
    *> Combine.end)
    $> ListProgramsIntent

newProgramParser : Parser s Intent
newProgramParser =
    (pathSep
    *> Combine.string "programs"
    *> pathSep
    *> Combine.string "start"
    *> Combine.end)
    $> SelectNewProgramIntent

programId : Parser s String
programId =
    Combine.regex "[0-9]+"

pathSep : Parser s String
pathSep =
    Combine.string "/"
