module Component.MultiPage exposing (..)

import Dict exposing (Dict)
import Html exposing (Html)

type alias Page model msg = model -> Html msg

type alias Model index =
    { currentPage : index
    }

type Msg index =
    ChangePageMsg index

type alias OutMsg = {}

init : index -> (Model index, {})
init startingPage =
    ({ currentPage = startingPage }, {})

update : Msg index
    -> Model index
    -> (Model index, {})
update msg _ =
    case msg of
        ChangePageMsg index ->
            ({ currentPage = index }, {})

view : (index -> model -> Html msg) -> Model index -> model -> Html msg
view viewPage { currentPage } model =
    viewPage currentPage model
