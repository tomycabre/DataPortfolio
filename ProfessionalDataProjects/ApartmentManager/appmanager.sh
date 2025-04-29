#!/bin/bash

# In the .env file, set the SQL_CONNECTION variable to the connection string for your SQL database.
source .env
# Check if the SQL_CONNECTION variable is set
#Connect to PostgresSQL
PSQL="$SQL_CONNECTION"

echo -e "\n\n~~~~~~~~~~~~~~~~~~~\n~~~ App Manager ~~~\n~~~~~~~~~~~~~~~~~~~"

MAIN_MENU() {
  # Check if the function received an argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\nSelect an option:"
  echo -e "\n1) Add New Apartment\n2) Delete Existing Apartment\n3) Exit"
  read MAIN_MENU_SELECTION
  
  case $MAIN_MENU_SELECTION in
    1) NEW_APARTMENT ;;
    2) DELETE_APARTMENT ;;
    3) EXIT ;;
    *) MAIN_MENU "Please enter a valid option.\n" ;;
  esac
}

NEW_APARTMENT () {
  # Check if the function received an argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # Function to create a new apartment
  echo -e "\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n~~ Apartment Creation Menu ~~\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

  echo -e "\nAdd an apartment number. ex: 4C, 403."
  read APARTMENT_NUMBER
  
  if [[ -z $APARTMENT_NUMBER ]]
  then
    NEW_APARTMENT "Please, add an appartment number and try again. To exit: Ctrl + Z."
  else
    # Count characters
    AP_NUM_CHAR_COUNT=$(echo -n $APARTMENT_NUMBER | wc -m)
    # If characters > 5, ERROR
    if [[ $AP_NUM_CHAR_COUNT > 5 ]]
    then
      NEW_APARTMENT "The appartment number must have a maximum of 5 characters. To exit: Ctrl + Z."
    else
      NUMBER_OF_ROOMS
    fi
  fi
}

NUMBER_OF_ROOMS () {
  # Check if the function received an argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # Get number of rooms in the apartment
  echo -e "\nHow many rooms does $APARTMENT_NUMBER have? Do not include bathrooms."
  read ROOMS_NUMBER

  if [[ ! $ROOMS_NUMBER =~ ^[0-9]+$ ]]
  then
    NUMBER_OF_ROOMS "That is not a valid number. To exit: Ctrl + Z."
  else
    APPARTMENT_PRICE
  fi
}

APPARTMENT_PRICE () {
  # Check if the function received an argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # Get user's price for the apartment
  echo -e "\nAdd a price-per-day for your apartment. Do NOT include $."
  read PRICE_PER_DAY

  if [[ ! $PRICE_PER_DAY =~ ^[0-9]+$ ]]
  then
    APPARTMENT_PRICE "That is not a valid number. To exit: Ctrl + Z."
  else
    INSERT_NEW_APARTMENT=$($PSQL " INSERT INTO apartments(apartment_number, rooms, price) VALUES ('$APARTMENT_NUMBER', $ROOMS_NUMBER, $PRICE_PER_DAY) ")
    echo -e "\nYour apartment $APARTMENT_NUMBER, with a price of \$$PRICE_PER_DAY per day for $ROOMS_NUMBER rooms has been successfully added to your database."
  fi
}

DELETE_APARTMENT () {
  # Check if the function received an argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # Function to delete an apartment
  echo -e "\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n~~ Apartment Deletion Menu ~~\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  # Get apartments
  GET_APARTMENTS=$($PSQL " SELECT apartment_id, apartment_number FROM apartments; ")
  # Create function to display apartments
  echo -e "\nSelect the apartment you want to delete:"
  echo "$GET_APARTMENTS" | while read APARTMENT_ID BAR APARTMENT_NUMBER
  do
    echo "$APARTMENT_ID) $APARTMENT_NUMBER"
  done
  # Get user choice
  read APARTMENT_CHOSEN

  if [[ ! $APARTMENT_CHOSEN =~ ^[0-9]+$ ]]
  then
    DELETE_APARTMENT "That is not a valid apartment number. To exit: Ctrl + Z."
  else
    # Get apartment to delete
    APARTMENT_TO_DELETE=$($PSQL " SELECT apartment_number FROM apartments WHERE apartment_id='$APARTMENT_CHOSEN' ")
    if [[ -z $APARTMENT_TO_DELETE ]]
    then
      DELETE_APARTMENT "That apartment does not exist. To exit: Ctrl + Z."
    else
      FINISH_DELETING
    fi
  fi
}

FINISH_DELETING() {
  # Check if the function received an argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\nAre you sure you want to delete apartment$APARTMENT_TO_DELETE? ( y / n )"
  read YES_OR_NO
  
  case $YES_OR_NO in
    y) DELETE ;;
    n) EXIT ;;
    *) FINISH_DELETING "Please write y or n to continue. To exit: Ctrl + Z."
  esac
}

DELETE () {
  # Delete selected apartment
  APARTMENT_DELETION_PROMPT=$($PSQL " DELETE FROM apartments WHERE apartment_id='$APARTMENT_CHOSEN' ")
  echo -e "\nThe apartment$APARTMENT_TO_DELETE was succesfully deleted."
}

EXIT () {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU