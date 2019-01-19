module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img, ul, li)
import Html.Attributes exposing (src)
import Set exposing (Set)


---- MODEL ----
type Letter = Solved Char | Unsolved Char

type alias Model =
    {
        progress: List Letter,
        inputLetters: Set Char
    }


init : ( Model, Cmd Msg )
init =
    ( {
        progress = [Solved 't', Unsolved 'e', Unsolved 's', Solved 't'],
        inputLetters = Set.fromList ['t', 'a']
    }, Cmd.none )



---- UPDATE ----

type Msg = Input Char | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----

renderLetter letter  = case letter of
    Solved x -> text (String.fromChar x)
    Unsolved _ -> text " _ "

view : Model -> Html Msg
view model =
    ul []
    (List.map renderLetter model.progress)



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
