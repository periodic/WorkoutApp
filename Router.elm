module Router exposing (Msg(..), init, update, interpret, view, intentToPath, pathToIntent)

import Dict
import Html exposing (Html)
import Set
import Navigation exposing (Location)
import Combine exposing (Parser, (<$>), (<*), (*>), (<*>), (<|>), (<?>), (<$), ($>))

import Model.App exposing (..)
import Model.Intent exposing (..)
import Model.PredefinedPrograms.Programs exposing (allProgramsDict)

type Msg
    = LocationChangedMsg String

init : String -> (Intent, Cmd msg)
init path =
    let
        intent = pathToIntent path
    in
        (intent, Cmd.none {- Navigation.modifyUrl (intentToPath intent) -})

navigateTo : Intent -> (Intent, Cmd msg)
navigateTo intent =
    (intent, Cmd.none {- Navigation.newUrl (intentToPath intent) -})

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

update : Location -> Intent -> Intent
update location model =
    model

interpret : RoutingAction -> Intent -> (Intent, Cmd msg)
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

view : (Intent -> Html msg) -> Intent -> Html msg
view views model =
    case model of
        intent ->
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
