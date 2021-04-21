# 21 card game

Implementation of card game 21. There are many versions of Twenty-One game. This one follows the game logic of casino style blackjack.  Rewards may differ from the standard. 

## Rules

* Game is implemented by using only one deck of cards, each card is unique
* Dealer will 'stay' at 17 or higher
* Dealer first card is kept hidden till the end of the game
* If player has blackjack he receives a double of his stake
* If the round result is draw player keeps the stake
* If player scores closer to 21 than dealer, dealer pays the amount of player's stake
* If dealer scores closer to 21 than player, dealer receives the stake
* Game is not as sophisticated as modern blackjack game so splitting a pair, double down and insurance are not possible. 

## Instructions

At first you need to install Haskell on your machine. You will need at least the Glasgow Haskell Compiler (GHC) to run the 21 Card game. If you don’t have GHC installed, you can download it from here https://www.haskell.org/downloads/ . Project source code can be cloned from here. For this you obviously need Git as well. Once you have successfully installed GHC & build tools and cloned the repository you can run the program with stack run -command from your terminal. Stack is a build tool for Haskell. 
Interactions in the game are done in terminal so no GUI is implemented. Expected inputs are instructed by the game host. Overall, the logic and flow of the game are very straightforward and will become clear to you once you start playing.
