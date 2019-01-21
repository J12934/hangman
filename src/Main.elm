module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img, ul, li, input, span)
import Html.Attributes exposing (src)
import Html.Events exposing (onInput)
import Set exposing (Set)

import Keyboard exposing (Key(..))
import Keyboard exposing (RawKey)

---- MODEL ----
type Letter = Solved Char | Unsolved Char

type Won = Won | Lost | InProgress

type alias Model =
    {
        progress: List Letter,
        inputLetters: Set Char,
        won: Won,
        triesLeft: Int
    }


init : ( Model, Cmd Msg )
init =
    ( {
        progress = [Unsolved 't', Unsolved 'e', Unsolved 's', Unsolved 't'],
        inputLetters = Set.fromList [],
        won = InProgress,
        triesLeft = 13
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

keyToChar : RawKey -> Maybe Char
keyToChar rawKey = 
    let
        char = Keyboard.characterKey rawKey
    in
        case char of
            Just (Character value) ->
                let
                    chars = List.reverse (String.toList value)
                in
                case chars of
                    [] -> Nothing
                    c::_ -> if Char.isAlpha c then
                            Just (Char.toLower c)
                        else
                            Nothing
            _ ->
                Nothing

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of
        KeyUp rawKey ->
            case model.won of
                Won -> ( model, Cmd.none )
                Lost -> (model, Cmd.none)
                InProgress -> case (keyToChar rawKey) of
                    Just c ->
                        --- Input Buchstabe schon versucht?
                        if Set.member c model.inputLetters then
                            --- Input ignorieren
                            ( model, Cmd.none )
                        else
                            --- Input Buchstabe löst einen Buchstaben vom Wort
                            if isSuccessfulTry model.progress c then
                                let
                                    currentProgress = List.map (solveLetterIfMatching c) model.progress
                                in
                                    ({
                                        progress = currentProgress,
                                        inputLetters = Set.insert c model.inputLetters,
                                        won = if (isWon currentProgress) then Won else InProgress,
                                        triesLeft = model.triesLeft
                                    }, Cmd.none)
                            --- Fehlerhafter versuch
                            else
                                ({
                                    progress = model.progress,
                                    inputLetters = Set.insert c model.inputLetters,
                                    --- Game is lost if only 1 attempt remained
                                    won = if model.triesLeft == 1 then Lost else InProgress,
                                    triesLeft = (model.triesLeft - 1)
                                }, Cmd.none)
                    Nothing ->
                        ( model, Cmd.none )
        None -> (model, Cmd.none)


isWon : (List Letter) -> Bool
isWon letters = List.all isSolved letters

isSolved : Letter -> Bool
isSolved letter = case letter of
    Solved _ -> True
    Unsolved _ -> False

isSuccessfulTry : (List Letter) -> Char -> Bool
isSuccessfulTry letters char =
    List.any (solvesLetter char) letters

solvesLetter : Char -> Letter -> Bool
solvesLetter char letter = case letter of
    Solved _ -> False
    Unsolved c -> c == char
        

---- VIEW ----

renderLetter letter  = case letter of
    Solved x -> text (String.fromChar x)
    Unsolved _ -> text " _ "

view : Model -> Html Msg
view model =
    div []
        [
            img[src ("/hangman/" ++ String.fromInt(model.triesLeft) ++ ".svg")][],
            ul []
                 (List.map renderLetter model.progress),
            case model.won of
                Won -> text "You won!"
                Lost -> text "You Lost!"
                InProgress -> text ("Tries left: " ++ (String.fromInt model.triesLeft))
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
