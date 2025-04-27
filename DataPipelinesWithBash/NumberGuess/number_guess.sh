#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guesser -t --no-align -c"

# Initializate program
# Welcome message
echo "~~ Welcome to Number Guesser ~~"

A=${RANDOM:0:3}

# Define function
LOGIN (){
  echo -e "\nEnter your username:"
  read USERNAME
  
  # Get username from database
  DBUSERNAME=$($PSQL " SELECT username FROM user_info WHERE username='$USERNAME' ")
  # If user exists, print stats, if not, add to database.
  if [[ -z $DBUSERNAME ]]
  then
    # if not, add to database.
    ADD_TO_DB=$($PSQL " INSERT INTO user_info(username) VALUES('$USERNAME') ")
    DBUSERNAME=$($PSQL " SELECT username FROM user_info WHERE username='$USERNAME' ")
    # Greet new username.
    echo -e "\nWelcome, $DBUSERNAME! It looks like this is your first time here."
    NUMBER_GUESSER
  else
    # Get games_played and best_game
    GAMES_PLAYED=$($PSQL " SELECT games_played FROM user_info WHERE username='$DBUSERNAME' ")
    BEST_GAME=$($PSQL "SELECT best_game FROM user_info WHERE username='$DBUSERNAME' ")
    # Print welcome back message
    echo -e "\nWelcome back, $DBUSERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    NUMBER_GUESSER
  fi
}

NUMBER_GUESSER (){
  echo -e "\nGuess the secret number between 1 and 1000:"
  NUMBER_OF_GUESSES=1
  read NUMBER
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
  else
    until [[ $NUMBER == $A ]]
    do
      if [[ $NUMBER > $A ]]
      then
        echo -e "\nIt's lower than that, guess again:"
      else
        echo -e "\nIt's higher than that, guess again:"
      fi
      ((NUMBER_OF_GUESSES++))
      read NUMBER
    done
    ((GAMES_PLAYED++))
    echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $A. Nice job!"
    if [[ $GAMES_PLAYED == 1 ]]
    then
      INSERT_FIRST_GAME=$($PSQL "UPDATE user_info SET games_played='1' WHERE username='$USERNAME' ")
      INSERT_NEW_HIGH_SCORE=$($PSQL " UPDATE user_info SET best_game='$NUMBER_OF_GUESSES' WHERE username='$USERNAME' ")  
    else
      if [[ $NUMBER_OF_GUESSES < $BEST_GAME ]]
      then
        INSERT_NEW_GAMES_PLAYED=$($PSQL " UPDATE user_info SET games_played='$GAMES_PLAYED' WHERE username='$USERNAME' ")
        INSERT_NEW_HIGH_SCORE=$($PSQL " UPDATE user_info SET best_game='$NUMBER_OF_GUESSES' WHERE username='$USERNAME' ")  
      fi
    fi
  fi
}



LOGIN