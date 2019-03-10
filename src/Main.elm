port module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img, ul, li, input, span, a, img)
import Html.Attributes exposing (src, class, href, rel, target, style)
import Html.Events exposing (onInput, onClick)
import Set exposing (Set)

import Keyboard exposing (Key(..))
import Keyboard exposing (RawKey)

totalTries = 13

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
                triesLeft = totalTries,
                words = otherWords,
                usedWords = []
            }, Cmd.none )
        [] -> ( {
                progress = [Unsolved 't', Unsolved 'e', Unsolved 's', Unsolved 't'],
                inputLetters = Set.fromList [],
                won = InProgress,
                triesLeft = totalTries,
                words = [],
                usedWords = []
            }, Cmd.none )

---- UPDATE ----

type Msg = KeyUp RawKey | ChromecastKeyPress Int | Reset | None


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
                
keyCodeToChar : Int -> Maybe Char
keyCodeToChar keyCode =
    let
        char = Char.fromCode keyCode
    in
        if Char.isAlpha char then
            Just (Char.toLower char)
        else
            Nothing

handleLetter : Model -> Char -> ( Model, Cmd Msg )
handleLetter model c = 
    --- successful attempt: input letter solves a letter from the target word
    if isSuccessfulTry model.progress c then
        let
            currentProgress = List.map (solveLetterIfMatching c) model.progress
        in
            ({ model |
                progress = currentProgress,
                inputLetters = Set.insert c model.inputLetters,
                won = if (isWon currentProgress) then Won else InProgress
            }, Cmd.none)
    --- failed attempt
    else
        ({ model |
            inputLetters = Set.insert c model.inputLetters,
            --- Game is lost if only 1 attempt remained
            won = if model.triesLeft == 1 then Lost else InProgress,
            triesLeft = (model.triesLeft - 1)
        }, Cmd.none)

handleRawInput : Model -> Maybe Char -> (Model, Cmd Msg)
handleRawInput model char = case model.won of
    -- Handle normal input
    InProgress -> case char of
        Just c ->
            --- input letter already tried?
            if Set.member c model.inputLetters then
                --- already tried: ignore input
                ( model, Cmd.none )
            else
                handleLetter model c
        Nothing ->
            ( model, Cmd.none )
    -- Ignore Inputs when the game is already won or already lost
    Won -> ( model, Cmd.none )
    Lost -> (model, Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of
        KeyUp rawKey -> handleRawInput model (keyToChar rawKey)
        ChromecastKeyPress keyCode -> handleRawInput model (keyCodeToChar keyCode)
        Reset ->
            case model.words of
                firstWord :: otherWords -> 
                    ( {
                        progress = toUnsolvedLetterList firstWord,
                        inputLetters = Set.fromList [],
                        won = InProgress,
                        triesLeft = totalTries,
                        words = otherWords,
                        usedWords = (lettersToString model.progress) :: model.usedWords
                    }, Cmd.none )
                -- This case only happens after the suer played 1000 round without reloading the page
                [] -> 
                    case model.usedWords of
                        -- Switch usedWords with words. -> the words are repeated after 1000 rounds
                        firstWord :: otherWords ->
                            ( {
                                progress = toUnsolvedLetterList firstWord,
                                inputLetters = Set.fromList [],
                                won = InProgress,
                                triesLeft = totalTries,
                                words = (lettersToString model.progress) :: otherWords,
                                usedWords = []
                            }, Cmd.none )
                        [] ->
                            -- This case is impossible, as usedWords cant be empty unless the inital word list is empty
                            ( {
                                progress = toUnsolvedLetterList "impossible",
                                inputLetters = Set.fromList [],
                                won = InProgress,
                                triesLeft = totalTries,
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
            lettersOverview (Set.toList model.inputLetters),
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

letterToLi letter = li [][text (String.fromChar letter)]


lettersOverview : List Char -> Html msg
lettersOverview letters = ul [ class "inputed_letters" ] (List.map letterToLi letters)

---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.ups KeyUp,
          chromecastKeyPress ChromecastKeyPress,
          chromecastResetGame (always Reset)
        ]
        
---- PORTS ----

port chromecastKeyPress : (Int -> msg) -> Sub msg
port chromecastResetGame : (() -> msg) -> Sub msg

---- PROGRAM ----


main : Program (List String) Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
