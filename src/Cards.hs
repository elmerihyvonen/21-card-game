module Cards where

import System.Random (randomRIO)
import Data.List

-- data type Value represents the value of a playing card
data Value = A | Two | Three | Four | Five | Six | Seven | Eight | Nine |
            Ten | J | Q | K deriving (Eq, Enum, Show)

--data type Suit representing the suit of a playing card
data Suit = Club | Diamond | Heart | Spade deriving (Eq, Enum, Show)

--type Card representing the playing card containing Suit and Value
type Card = (Suit, Value)

-- type Deck representing all the cards that are in the deck
type Deck = [Card]

-- data type representing the possible player actions
data Action = Hit | Stay deriving (Show, Eq)

--function to return the value of given card
cardValues :: Card -> Int
cardValues (_ , A)     = 1
cardValues (_ , Two)   = 2
cardValues (_ , Three) = 3
cardValues (_ , Four)  = 4
cardValues (_ , Five)  = 5
cardValues (_ , Six)   = 6
cardValues (_ , Seven) = 7
cardValues (_ , Eight) = 8
cardValues (_ , Nine)  = 9
cardValues (_ , _)     = 10

--function to print the suit and value of given card
printCard :: Card -> String
printCard c = show (snd c) ++ " of " ++ show (fst c) ++ "'s"

--function that prints the whole hand, recursive function
showHand :: [Card] -> String
showHand [] = ""
showHand (c:cs) = printCard c ++ " | " ++ showHand cs

-- function that creates a new deck of playing cards, returned in perfect order
createDeck :: Deck
createDeck = [(suit, value) | suit <- [Club .. Spade], value <- [A .. K]]

--function that shuffles the deck in random order
shuffleDeck :: Deck -> Deck -> IO [Card]
shuffleDeck randomized [] = return randomized
shuffleDeck randomized notyetrandomized = do
  random <- randomRIO (0, length notyetrandomized - 1)
  let randomcard = notyetrandomized !! random
  let cards1 = take random notyetrandomized 
  let cards2 = drop (random + 1) notyetrandomized  
  shuffleDeck (randomized ++ [randomcard]) (cards1 ++ cards2)

--to calculate score of hand
handScore :: [Int] -> Int
handScore cards
  |sum cards < 12 && 1 `elem` cards = sum (cards) + 10
  |otherwise = sum cards

--to calculate the hand value as a [Int]
handValues :: [Card] -> [Int]
handValues [] = []
handValues (c:cs) = (cardValues c): handValues cs

--compare scores and determine the winner
determineWinner :: [Card] -> [Card] -> String
determineWinner dealerHand playerHand
  |handScore (handValues dealerHand) == handScore (handValues playerHand) = "Game draw" 
  |handScore (handValues dealerHand) > handScore (handValues playerHand) = "You lost" 
  |handScore (handValues dealerHand) < handScore (handValues playerHand) = "You won" 

--function to draw a card from deck. 
drawCard :: Deck -> Int -> ([Card], [Card])
drawCard deck num = (take num deck, drop num deck)




