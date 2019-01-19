module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img, ul, li, input)
import Html.Attributes exposing (src)
import Html.Events exposing (onInput)
import Set exposing (Set)

import Keyboard exposing (Key(..))
import Keyboard exposing (RawKey)

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

type Msg = KeyUp RawKey | None


solveLetterIfMatching : Char -> Letter -> Letter
solveLetterIfMatching inputChar wordLetter = case wordLetter of
    Solved _ -> wordLetter
    Unsolved c -> if c == inputChar then
            Solved c
        else
            wordLetter

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of      
    KeyUp rawKey -> 
        let 
            char = Keyboard.characterKey rawKey
        in
            case char of
                Just (Character value) ->
                    let
                        chars = List.reverse (String.toList value)
                    in
                    case chars of
                        [] -> (model, Cmd.none)
                        c::_ -> ({
                                    progress = List.map (solveLetterIfMatching c) model.progress,
                                    inputLetters = Set.insert c model.inputLetters
                                }, Cmd.none)
                _ ->
                    ( model, Cmd.none )
    None -> (model, Cmd.none)



---- VIEW ----

renderLetter letter  = case letter of
    Solved x -> text (String.fromChar x)
    Unsolved _ -> text " _ "

view : Model -> Html Msg
view model =
    div []
        [
            img[src ("/hangman/" ++ String.fromInt(max 0 (14 - (Set.size model.inputLetters)) ) ++ ".svg")][],
            ul []
                 (List.map renderLetter model.progress)
        ]


---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.ups KeyUp ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
