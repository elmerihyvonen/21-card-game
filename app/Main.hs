module Main where

import Cards
import Control.Monad
import System.IO
import System.Random
import System.Random (randomRIO)
import System.Exit
import Text.Read

main :: IO ()
main = do

    let answer = ""
    putStrLn "Are you ready to play? yes/no: "
    answer <- getLine
    
    if answer == "yes" then
         do putStrLn ""
            putStrLn "************************* NEW GAME STARTING *************************"
            let playerCards = [] :: [Card]
            let dealerCards = [] :: [Card]
            let unshuffledDeck = createDeck
            deck <- shuffleDeck [] unshuffledDeck
            let action = Hit :: Action
            game dealerCards playerCards deck action
        else exitSuccess

--showScores function handles the monitoring of game situation
showScores :: [Card] -> [Card] -> Bool -> IO()
showScores playerhand dealerhand last = do
    
    putStrLn "------------------------------------------------------------------------"

    let playerScore = handScore ( handValues playerhand )
    let playercards = showHand playerhand
    let dealerScoreSecret = handScore ( handValues (drop 1 dealerhand ))
    let dealerScore = handScore ( handValues dealerhand )
    let dealercards = showHand dealerhand

    if last == True
        then do
            putStrLn $ ("Dealer's hand: | " ++ dealercards) 
            print dealerScore
            putStrLn $ "Your hand: | " ++ playercards
            print playerScore

            if dealerScore <= 21
                then do
                    print $ determineWinner dealerhand playerhand
                    putStrLn ""
                    main
                else do
                    putStrLn "Dealer went over 21! You won!"
                    putStrLn ""
                    main
        else do
            let dealercardsSecret = showHand (drop 1 dealerhand)
            putStrLn $ "Dealer's hand: | secret card | " ++ dealercardsSecret
            print dealerScoreSecret
            putStrLn $ "Your hand: | " ++ playercards
            print playerScore

            if playerScore == 21 
                then do 
                    putStrLn "BlackJack!"
                    print $ determineWinner dealerhand playerhand
                    putStrLn ""
                    main
                else if playerScore > 21
                    then do
                        putStrLn "You went over 21! Game lost."
                        putStrLn ""
                        main
                else putStrLn ""

--game function that handles the game logic
game :: [Card] -> [Card] -> Deck -> Action -> IO()
game dealerHand playerHand deck action = do
    
    if dealerHand == [] && playerHand == [] && length dealerHand == 0
        then do
            let draw = drawCard deck 4
            let cards = fst draw
            let deckAfter = snd draw
            let pHand = [(cards !! 0), (cards !! 2)]
            let dHand = [(cards !! 1), (cards !! 3)]
            showScores pHand dHand False

            putStrLn "Enter next action hit/stay: "
            actionString <- getLine 
            putStrLn ""

            if actionString == "hit" 
                then game dHand pHand deckAfter Hit
                else game dHand pHand deckAfter Stay

        else if action == Hit && handScore (handValues playerHand) < 21 
            then do
                let draw = drawCard deck 1
                let cards = fst draw
                let deckAfter = snd draw
                let pHand = playerHand ++ cards
                showScores pHand dealerHand False

                putStrLn ""
                putStrLn "Enter next action hit/stay: "
                actionString <- getLine
                putStrLn ""

                if actionString == "hit" then game dealerHand pHand deckAfter Hit 
                else game dealerHand pHand deckAfter Stay

        else if action == Stay
            then do
                if handScore (handValues dealerHand) < 17
                    then do 
                        let draw = drawCard deck 1
                        let card = fst draw
                        let deckAfter = snd draw
                        let dHand = dealerHand ++ card
                        game dHand playerHand deckAfter Stay
                    else do
                        showScores playerHand dealerHand True
        else putStrLn "Program has ended."

