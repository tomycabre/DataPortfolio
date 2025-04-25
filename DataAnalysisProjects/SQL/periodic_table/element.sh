#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if the user provided an argument
if [[ $1 ]]
then
  # If they provided an argument, continue.
  # Check if the argument is a number.
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    # If its not a number, check if it is a letter
    # Check if it is a symbol or name
    ELEMENT_NAME=$($PSQL " SELECT name FROM elements WHERE symbol='$1' OR name ILIKE '$1' ")
    if [[ -z $ELEMENT_NAME ]]
    then
      # If it does not exist
      echo "I could not find that element in the database."
    else
      ELEMENT_SYMBOL=$($PSQL" SELECT symbol FROM elements WHERE name='$ELEMENT_NAME' ")
      TYPE=$($PSQL" SELECT type FROM types FULL JOIN properties ON types.type_id = properties.type_id FULL JOIN elements ON properties.atomic_number = elements.atomic_number WHERE name='$ELEMENT_NAME' ")
      ATOMIC_NUMBER=$($PSQL " SELECT atomic_number FROM elements WHERE name='$ELEMENT_NAME' ")
      ATOMIC_MASS=$($PSQL"SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER' ")
      MELTING_POINT=$($PSQL"SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
      BOILING_POINT=$($PSQL"SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  else
    # if it is a number, contiinue.
    # Get Element
    ELEMENT_NAME=$($PSQL " SELECT name FROM elements WHERE atomic_number='$1' ")
    if [[ -z $ELEMENT_NAME ]] 
    then
      # If it does not exist
      echo "I could not find that element in the database."
    else
      # If exists
      ELEMENT_SYMBOL=$($PSQL " SELECT symbol FROM elements WHERE atomic_number='$1'")
      TYPE=$($PSQL " SELECT type FROM types FULL JOIN properties ON types.type_id = properties.type_id WHERE atomic_number='$1'; ")
      ATOMIC_MASS=$($PSQL " SELECT atomic_mass FROM properties WHERE atomic_number='$1' ")
      MELTING_POINT=$($PSQL " SELECT melting_point_celsius FROM properties WHERE atomic_number='$1' ")
      BOILING_POINT=$($PSQL " SELECT boiling_point_celsius FROM properties WHERE atomic_number='$1' ")
      echo "The element with atomic number $1 is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  fi
else
  # If not, tell them to provide an argument
  echo "Please provide an element as an argument."
fi