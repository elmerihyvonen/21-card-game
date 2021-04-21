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
    menu 0
    
menu :: Double -> IO()
menu balance = do

    putStrLn ""
    putStrLn "++++++++++++++++++++++++++++ MENU +++++++++++++++++++++++++++++++"
    putStrLn "Your Balance: "
    print balance
    putStrLn ""

    if balance == 0
        then do
            putStrLn "Deposit more money: "
            input <- getLine
            let uptdBalance = (read input :: Double)
            menu uptdBalance

        else do
            let answer = ""
            putStrLn "Ready to play a hand ? yes/no: "
            answer <- getLine
            putStrLn ""
            
            if answer == "yes" then
                do 
                    putStrLn "Place bet: "
                    input <- getLine 
                    let bet = (read input :: Double)
                    putStrLn ""

                    if bet > balance
                        then do
                            putStrLn "not enough balance!"
                            putStrLn ""
                            menu balance
                        else do
                            let newBalance = balance - bet

                            putStrLn ""
                            putStrLn "************************* NEW ROUND *************************"

                            let playerCards = [] :: [Card]
                            let dealerCards = [] :: [Card]
                            let unshuffledDeck = createDeck
                            deck <- shuffleDeck [] unshuffledDeck
                            let action = Hit :: Action
                            game dealerCards playerCards deck action bet newBalance

                else exitSuccess

--showScores function handles the monitoring of game situation
showScores :: [Card] -> [Card] -> Bool -> Double -> Double -> IO()
showScores playerhand dealerhand last bet balance = do
    
    putStrLn "------------------------------------------------------------------------"

    let playerScore = handScore $ handValues playerhand 
    let playercards = showHand playerhand
    let dealerScoreSecret = handScore $ handValues (drop 1 dealerhand )
    let dealerScore = handScore $ handValues dealerhand
    let dealercards = showHand dealerhand

    if last == True

        then do
            putStrLn $ "Dealer's hand: | " ++ dealercards
            print dealerScore
            putStrLn $ "Your hand: | " ++ playercards
            print playerScore
            putStrLn ""

            if dealerScore <= 21
                then do
                    let result = determineWinner dealerhand playerhand
                    print result
                    if result == "You lost" 
                        then do 
                            putStrLn ""
                            menu balance
                        else if result == "You won"
                            then do
                                let newBalance = balance + bet*2
                                menu newBalance
                        else menu balance
                else do
                    putStrLn "Dealer went over 21! You won!"
                    putStrLn ""
                    let newBalance = balance + bet*2
                    menu newBalance
        else do
            let dealercardsSecret = showHand (drop 1 dealerhand)
            putStrLn $ "Dealer's hand: | secret card | " ++ dealercardsSecret
            print dealerScoreSecret
            putStrLn $ "Your hand: | " ++ playercards
            print playerScore

            if playerScore == 21 
                then do 
                    putStrLn "You hit 21!"
                    print $ determineWinner dealerhand playerhand
                    putStrLn ""
                    let newBalance = balance + bet*3
                    menu newBalance
                else if playerScore > 21
                    then do
                        putStrLn "You went over 21! Game lost."
                        putStrLn ""
                        menu balance
                else putStrLn ""

--game function that handles the game logic
game :: [Card] -> [Card] -> Deck -> Action -> Double -> Double -> IO()
game dealerHand playerHand deck action bet balance = do
    
    if dealerHand == [] && playerHand == [] && length dealerHand == 0
        then do
            let draw = drawCard deck 4
            let cards = fst draw
            let deckAfter = snd draw
            let pHand = [(cards !! 0), (cards !! 2)]
            let dHand = [(cards !! 1), (cards !! 3)]
            showScores pHand dHand False bet balance

            putStrLn "Enter next action hit/stay: "
            actionString <- getLine 
            putStrLn ""

            if actionString == "hit" 
                then game dHand pHand deckAfter Hit bet balance
                else game dHand pHand deckAfter Stay bet balance

        else if action == Hit && handScore (handValues playerHand) < 21 
            then do
                let draw = drawCard deck 1
                let cards = fst draw
                let deckAfter = snd draw
                let pHand = playerHand ++ cards
                showScores pHand dealerHand False bet balance

                putStrLn ""
                putStrLn "Enter next action hit/stay: "
                actionString <- getLine
                putStrLn ""

                if actionString == "hit" then game dealerHand pHand deckAfter Hit bet balance
                else game dealerHand pHand deckAfter Stay bet balance

        else if action == Stay
            then do
                if handScore (handValues dealerHand) < 17
                    then do 
                        let draw = drawCard deck 1
                        let card = fst draw
                        let deckAfter = snd draw
                        let dHand = dealerHand ++ card
                        game dHand playerHand deckAfter Stay bet balance
                    else do
                        showScores playerHand dealerHand True bet balance
        else putStrLn "Program has ended."

