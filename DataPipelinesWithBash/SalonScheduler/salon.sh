#!/bin/bash

# In the .env file, set the SQL_CONNECTION variable to the connection string for your PostgreSQL salon database.
source .env

# Salon Scheduler
#Connect to PostgresSQL
PSQL="$SQL_CONNECTION"

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
        APPOINTMENT_SCHEDULER
      else
        APPOINTMENT_SCHEDULER
      fi
    fi
  fi
}

APPOINTMENT_SCHEDULER () {
  # Check if the function received an argument
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  # Get user's name
  CUSTOMER_NAME=$($PSQL " SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # Get Shedule Info
  SCHEDULE_INFO=$($PSQL " SELECT schedule_id, time FROM schedule WHERE available='t' ORDER BY schedule_id ")
  # Print service info to user
  echo "$SCHEDULE_INFO" | while read SCHEDULE_ID BAR TIME
  do
    echo "$SCHEDULE_ID) $TIME"
  done
  # Ask for schedule time
  echo -e "\nWhat time would you like your$SERVICE_NAME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
  # Store user's schedule time
  read SCHEDULE_TIME
  # Check if schedule time is valid
  if [[ ! $SCHEDULE_TIME =~ ^[0-9]+$ ]]
  then
    # send error message to user
    APPOINTMENT_SCHEDULER "That is not a valid schedule time."
  else
    # get schedule availability
    SCHEDULE_AVAILABILITY=$($PSQL " SELECT available FROM schedule WHERE schedule_id='$SCHEDULE_TIME' AND available='t' ")
    # if the time is not available
    if [[ -z $SCHEDULE_AVAILABILITY ]]
    then
      # send error message to user
      APPOINTMENT_SCHEDULER "The time you selected is not avaiable."
    else
      # Get user's customer_id 
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      # Get user's time selected
      TIME_SELECTED=$($PSQL " SELECT time FROM schedule WHERE schedule_id='$SCHEDULE_TIME' ")
      # Create appointment
      UPDATE_AVAILABILITY=$($PSQL " UPDATE schedule SET available='f' WHERE schedule_id='$SCHEDULE_TIME' ")
      ADD_APPOINTMENT=$($PSQL " INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$TIME_SELECTED') ")
      # End message
      echo -e "\nI have put you down for a$SERVICE_NAME at$TIME_SELECTED, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
    fi
  fi    
}

# Execute function
SALON_SCHEDULER