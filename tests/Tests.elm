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
        [ describe "reset"
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
