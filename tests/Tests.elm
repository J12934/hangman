module Tests exposing (..)

import Test exposing (..)
import Expect
import Set exposing (Set)
import Main exposing (update, Letter(..), Msg(..), Won(..))
import Keyboard exposing (RawKey)


-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!

initialState = {
        progress = [ Unsolved 't', Unsolved 'e', Unsolved 's', Unsolved 't'],
        inputLetters = Set.fromList [],
        won = InProgress,
        triesLeft = 13,
        words = ["anothertest"],
        usedWords = []
    }

all : Test
all =
    describe "reducer"
        -- input char test uses the chromecastkeypress action as the RawKey of the 'normal' action is hard to create
        --- both action call the same undelying code, so it should be fine
        [ describe "inputchar"
            [
                test "solves letters if matching" <|
                    \_ ->
                        Expect.equal ({
                            progress = [ Unsolved 't', Solved 'e', Unsolved 's', Unsolved 't'],
                            inputLetters = Set.fromList ['e'],
                            won = InProgress,
                            triesLeft = 13,
                            words = [],
                            usedWords = []
                        }, (Cmd.none)) (update (ChromecastKeyPress (Char.toCode 'e')) {
                            progress = [ Unsolved 't', Unsolved 'e', Unsolved 's', Unsolved 't'],
                            inputLetters = Set.fromList [],
                            won = InProgress,
                            triesLeft = 13,
                            words = [],
                            usedWords = []
                        }),
                test "doesn't solve letters if not matching" <|
                    \_ ->
                        Expect.equal ({
                            progress = [ Unsolved 't', Unsolved 'e', Unsolved 's', Unsolved 't'],
                            inputLetters = Set.fromList ['x'],
                            won = InProgress,
                            triesLeft = 12,
                            words = [],
                            usedWords = []
                        }, (Cmd.none)) (update (ChromecastKeyPress (Char.toCode 'x')) {
                            progress = [ Unsolved 't', Unsolved 'e', Unsolved 's', Unsolved 't'],
                            inputLetters = Set.fromList [],
                            won = InProgress,
                            triesLeft = 13,
                            words = [],
                            usedWords = []
                        }),
                test "solves multiple letters if multiple match" <|
                    \_ ->
                        Expect.equal ({
                            progress = [ Solved 't', Unsolved 'e', Unsolved 's', Solved 't'],
                            inputLetters = Set.fromList ['t'],
                            won = InProgress,
                            triesLeft = 13,
                            words = [],
                            usedWords = []
                        }, (Cmd.none)) (update (ChromecastKeyPress (Char.toCode 't')) {
                            progress = [ Unsolved 't', Unsolved 'e', Unsolved 's', Unsolved 't'],
                            inputLetters = Set.fromList [],
                            won = InProgress,
                            triesLeft = 13,
                            words = [],
                            usedWords = []
                        }),
                test "marks game as won if the last letter was solved" <|
                    \_ ->
                        Expect.equal ({
                            progress = [ Solved 't', Solved 'e', Solved 's', Solved 't'],
                            inputLetters = Set.fromList ['t', 'e', 's'],
                            won = Won,
                            triesLeft = 13,
                            words = [],
                            usedWords = []
                        }, (Cmd.none)) (update (ChromecastKeyPress (Char.toCode 's')) {
                            progress = [ Solved 't', Solved 'e', Unsolved 's', Solved 't'],
                            inputLetters = Set.fromList ['t', 'e'],
                            won = InProgress,
                            triesLeft = 13,
                            words = [],
                            usedWords = []
                        })
            ],
            describe "reset"
                [
                    test "reset works" <|
                        \_ ->
                            Expect.equal ({
                                progress = [ Unsolved 'f', Unsolved 'o', Unsolved 'o'],
                                inputLetters = Set.fromList [],
                                won = InProgress,
                                triesLeft = 13,
                                words = [],
                                usedWords = ["test"]
                            }, (Cmd.none)) (update Reset {
                                progress = [ Solved 't', Solved 'e', Solved 's', Solved 't'],
                                inputLetters = Set.fromList [],
                                won = Won,
                                triesLeft = 8,
                                words = ["foo"],
                                usedWords = []
                            }),
                    test "reset cycles used and normal words when normal words get emptied" <|
                        \_ ->
                            Expect.equal ({
                                progress = [ Unsolved 'f', Unsolved 'o', Unsolved 'o'],
                                inputLetters = Set.fromList [],
                                won = InProgress,
                                triesLeft = 13,
                                words = ["test"],
                                usedWords = []
                            }, (Cmd.none)) (update Reset {
                                progress = [ Solved 't', Solved 'e', Solved 's', Solved 't'],
                                inputLetters = Set.fromList [],
                                won = Won,
                                triesLeft = 13,
                                words = [],
                                usedWords = ["foo"]
                            })
                ]
        ]
