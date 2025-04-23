#!/bin/bash
#Connect to PostgresSQL
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# Script title
echo -e "\n~~~~~ MY SALON ~~~~~\n"

# Salon Funciton
SALON_SCHEDULER () {
  # Check if the function received an argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # Welcome message
  echo -e  "\nWelcome to My Salon, how can I help you?\n"
  # Get Service info
  SERVICE_INFO=$($PSQL " SELECT service_id, name FROM services ORDER BY service_id ")
  # Print service info to user
  echo "$SERVICE_INFO" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  # Get user selection 
  read SERVICE_ID_SELECTED
  # Check if service exists
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # send to main menu
    SALON_SCHEDULER "That is not a valid service."
  else
    # Get service name
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    # Get service ID
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    # Check if service id exists
    if [[ -z $SERVICE_ID ]] 
    then
      # if service does not exists, send error message to user
      SALON_SCHEDULER "Service $SERVICE_ID_SELECTED is not available at the moment."
    else
      # if service exists, ask for phone number
      echo -e "\nWhat's your phone number?"
      # Store user's phone number
      read CUSTOMER_PHONE
      # Look if the user exists
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      # Check if number exists
      if [[ -z $CUSTOMER_ID ]]
      then
        # if number does not exist in the database
        # Ask for user's name
        echo -e "\nI don't have a record for that phone number, what's your name?"
        # Store user's name
        read CUSTOMER_NAME
        # Add user to database
        ADD_CUSTOMER=$($PSQL " INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME') ")
        # Ask user for appointment time
        echo -e "\nWhat time would you like your cut, $(echo $CUSTOMER_NAME  | sed -r 's/^ *| *$//g')?"
        # Store user's selected time
        read SERVICE_TIME
        # Get user's customer_id now that they have one
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        # Add user's appointment to database
        ADD_APPOINTMENT=$($PSQL " INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID', '$SERVICE_TIME') ")
        # Send user appointment confirmation message
        echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
      else
        # if number exists in database
        # Get user's name
        CUSTOMER_NAME=$($PSQL " SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        # Ask user for appointment time
        echo -e "\nWhat time would you like your cut,$(echo $CUSTOMER_NAME  | sed -r 's/^ *| *$//g')?"
        # Store user's selected time
        read SERVICE_TIME
        # Add user's appointment to database
        ADD_APPOINTMENT=$($PSQL " INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID', '$SERVICE_TIME') ")
        # Send user appointment confirmation message
        echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
      fi
    fi
  fi
}

# Execute function
SALON_SCHEDULER