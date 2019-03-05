module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img, ul, li, input, span, a, img)
import Html.Attributes exposing (src, class, href, rel, target, style)
import Html.Events exposing (onInput, onClick)
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
        triesLeft: Int,
        words: List String,
        usedWords: List String
    }

toUnsolvedLetterList : String -> List Letter
toUnsolvedLetterList word =
    List.map (\c -> Unsolved c) (String.toList word)

init : List String -> ( Model, Cmd Msg )
init words =
    case words of
        firstWord :: otherWords ->
            ( {
                progress = toUnsolvedLetterList firstWord,
                inputLetters = Set.fromList [],
                won = InProgress,
                triesLeft = 13,
                words = otherWords,
                usedWords = []
            }, Cmd.none )
        [] -> ( {
                progress = [Unsolved 't', Unsolved 'e', Unsolved 's', Unsolved 't'],
                inputLetters = Set.fromList [],
                won = InProgress,
                triesLeft = 13,
                words = [],
                usedWords = []
            }, Cmd.none )

---- UPDATE ----

type Msg = KeyUp RawKey | Reset | None


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
                                    ({ model |
                                        progress = currentProgress,
                                        inputLetters = Set.insert c model.inputLetters,
                                        won = if (isWon currentProgress) then Won else InProgress
                                    }, Cmd.none)
                            --- Fehlerhafter versuch
                            else
                                ({ model |
                                    inputLetters = Set.insert c model.inputLetters,
                                    --- Game is lost if only 1 attempt remained
                                    won = if model.triesLeft == 1 then Lost else InProgress,
                                    triesLeft = (model.triesLeft - 1)
                                }, Cmd.none)
                    Nothing ->
                        ( model, Cmd.none )
        Reset ->
            case model.words of
                firstWord :: otherWords -> 
                    ( {
                        progress = toUnsolvedLetterList firstWord,
                        inputLetters = Set.fromList [],
                        won = InProgress,
                        triesLeft = 13,
                        words = otherWords,
                        usedWords = (lettersToString model.progress) :: model.usedWords
                    }, Cmd.none )
                [] -> 
                    case model.usedWords of
                        firstWord :: otherWords ->
                            ( {
                                progress = toUnsolvedLetterList firstWord,
                                inputLetters = Set.fromList [],
                                won = InProgress,
                                triesLeft = 13,
                                words = (lettersToString model.progress) :: otherWords,
                                usedWords = []
                            }, Cmd.none )
                        [] ->
                            -- This case is impossible, as usedWords cant be empty when the word list is empty
                            ( {
                                progress = toUnsolvedLetterList "impossible",
                                inputLetters = Set.fromList [],
                                won = InProgress,
                                triesLeft = 13,
                                words = [],
                                usedWords = []
                            }, Cmd.none )
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

renderLetter won letter  = case letter of
    Solved x -> span [ class "letter", class "letter_solved" ] [text (String.fromChar x)]
    Unsolved x -> case won of
        Won -> text "Mhh this case doesnt really make any sense..."
        Lost -> span [ class "letter", class "letter_lost" ] [text (String.fromChar x)]
        InProgress -> span [ class "letter", class "letter_empty" ] [text "_"]


letterToChar : Letter -> Char
letterToChar letter = case letter of
    Solved c -> c
    Unsolved c -> c
        

lettersToString : List Letter -> String
lettersToString letters = letters
    |> List.map letterToChar
    |> List.map String.fromChar
    |> List.foldr (++) ""

viewDefinitonLink word children = a [ href ("https://www.merriam-webster.com/dictionary/" ++ word), class "view_definiton", target "_blank" ] children

letterDisplay won letters = (List.map (renderLetter won) letters)

view : Model -> Html Msg
view model =
    div [ class "main" ]
        [
            img[src ("/hangman/" ++ String.fromInt(model.triesLeft) ++ ".svg")][],
            div [ class "letters" ] (case model.won of
                InProgress -> letterDisplay model.won model.progress
                _ -> [ viewDefinitonLink (lettersToString model.progress) (letterDisplay model.won model.progress) ]
            ),
            (case model.won of
                Won -> wonOverlay
                _ -> text ""),
            (case model.won of
                InProgress -> text ""
                _ -> span [ onClick Reset, class "another_round"] [ text "🤺 Another Round?" ])
        ]


confetti : Int -> Html msg
confetti i = div [ class ("confetti-" ++ String.fromInt i) ] [ ]

wonOverlay = div [ class "confetti_overlay" ] (List.map confetti (List.range 0 150))

---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.ups KeyUp ]

---- PROGRAM ----


main : Program (List String) Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
