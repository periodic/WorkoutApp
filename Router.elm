module Router exposing (Msg, Model, init, update, interpret, view, intentToPath, pathToIntent)

import Dict
import Html exposing (Html)
import Set
import Navigation exposing (Location)
import Combine exposing (Parser, (<$>), (<*), (*>), (<*>), (<|>), (<?>), (<$), ($>))

import Model.Actions exposing (..)
import Model.Intent exposing (..)
import Model.PredefinedPrograms.Programs exposing (allProgramsDict)

type Msg
    = Nothing

type Model
    = Model Intent

init : String -> (Model, Cmd Msg)
init path =
    pathToIntent path |> navigateTo

navigateTo : Intent -> (Model, Cmd Msg)
navigateTo intent =
    (Model intent, Navigation.modifyUrl (intentToPath intent))

intentToPath : Intent -> String
intentToPath intent =
    case intent of
        ListProgramsIntent ->
            "/programs"
        ViewProgramIntent program ->
            "/programs/" ++ program.id

pathToIntent : String -> Intent
pathToIntent path =
    parsePath path |> Result.withDefault ListProgramsIntent

update : Msg -> Model -> (Model, Cmd Msg)
update _ model =
    (model, Cmd.none)

interpret : RoutingAction -> Model -> (Model, Cmd Msg)
interpret outMsg model =
    case outMsg of
        ViewAllProgramsAction ->
            navigateTo ListProgramsIntent
        ViewProgramAction program ->
            navigateTo (ViewProgramIntent program)


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
    listProgramsParser <|> viewProgramParser


listProgramsParser : Parser s Intent
listProgramsParser =
    (pathSep *> Combine.string "programs" *> Combine.end) $> ListProgramsIntent

viewProgramParser : Parser s Intent
viewProgramParser =
    (pathSep
    *> Combine.string "programs"
    *> pathSep
    *> programId
    <* Combine.end)
    |> Combine.map (flip Dict.get allProgramsDict)
    |> Combine.andThen
        (Maybe.map Combine.succeed
        >> Maybe.withDefault (Combine.fail "Expected Program ID"))
    |> Combine.map ViewProgramIntent

programId : Parser s String
programId =
    Combine.regex "[a-z0-9_-]+"

pathSep : Parser s String
pathSep =
    Combine.string "/"
