#!/bin/bash

# In the .env file, set the SQL_CONNECTION variable to the connection string for your SQL database.
source .env
# Check if the SQL_CONNECTION variable is set
#Connect to PostgresSQL
PSQL="$SQL_CONNECTION"

echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~\n~~~ Schedule Manager ~~~\n~~~~~~~~~~~~~~~~~~~~~~~~"

MAIN_MENU() {
    # Check if the function received an argument
    if [[ $1 ]]
    then
        echo -e "\n$1"
    fi
    echo -e "\nWelcome to Schedule Manager, please select an option:"
    echo -e "\n1) Check-In\n2) Check-Out\n3) Exit" 
    read MAIN_MENU_SELECTION

    case $MAIN_MENU_SELECTION in
        1) CHECK_IN ;;
        2) CHECK_OUT ;;
        3) EXIT ;;
        *) MAIN_MENU "Please select a valid option." ;;
    esac

}

CHECK_IN () {
    # Check if the function received an argument
    if [[ $1 ]]
    then
        echo -e "\n$1"
    fi

    echo -e "\n~~~~~~~~~~~~~~~~\n~~~ Check In ~~~\n~~~~~~~~~~~~~~~~"
    # Get list of available apartments
    AVAILABLE_APARTMENTS=$($PSQL " SELECT apartment_id, apartment_number FROM apartments WHERE available='t' ORDER BY apartment_id ")
    if [[ -z $AVAILABLE_APARTMENTS ]]
    then
        MAIN_MENU "Sorry, there are no apartments available."
    else
        echo -e "\nChoose an apartment to Check-In:"
        # Loop through the apartments
        echo "$AVAILABLE_APARTMENTS" | while read APARTMENT_ID BAR APARTMENT_NUMBER
        do
            echo "$APARTMENT_ID) $APARTMENT_NUMBER"
        done
        # Get user choice
        read APARTMENT_CHOSEN

        if [[ ! $APARTMENT_CHOSEN =~ ^[0-9]+$ ]]
        then
            CHECK_IN "That is not a valid apartment number. To exit: Ctrl + Z."
        else
            # Get apartment to check in 
            APARTMENT_TO_CHECK_IN=$($PSQL " SELECT apartment_number FROM apartments WHERE apartment_id=$APARTMENT_CHOSEN ")
            if [[ -z $APARTMENT_TO_CHECK_IN ]]
            then
                CHECK_IN "Sorry, that apartment is not available. To exit: Ctrl + Z."
            else
                CUSTOMER_INFO
            fi
        fi
    fi
}

CUSTOMER_INFO () {
    # Check if the function received an argument
    if [[ $1 ]]
    then
        echo -e "\n$1"
    fi

    echo -e "\nPlease enter your customer's phone number. (Only numbers)"
    read PHONE_ENTERED
    if [[ ! $PHONE_ENTERED =~ ^[0-9]+$ ]]
    then
        CUSTOMER_INFO "\nPlease write the phone in the correct format. To exit: Ctrl + Z."
    else
        # Check if customer exists
        CUSTOMER_NAME=$($PSQL " SELECT name FROM customers WHERE phone=$PHONE_ENTERED ")
        if [[ -z $CUSTOMER_NAME ]]
        then
            echo -e "\nYou dont have a customer with that phone number."
            echo -e "\nPlease enter new customer name:"
            read NEW_CUSTOMER_NAME

            INSERT_CUSTOMER_INFORMATION=$($PSQL " INSERT INTO customers(name, phone) VALUES ('$NEW_CUSTOMER_NAME', $PHONE_ENTERED) ")
            # Get the name of the new customer
            CUSTOMER_NAME=$($PSQL " SELECT name FROM customers WHERE phone=$PHONE_ENTERED ")
            echo -e "\nThe customer $NEW_CUSTOMER_NAME was successfully added to your database."
            FINISH_CHECK_IN
        else
            echo -e "\nCustomer $CUSTOMER_NAME, with $PHONE_ENTERED is already on database, proceeding."
            FINISH_CHECK_IN
        fi
    fi
}

FINISH_CHECK_IN () {
    # Check if the function received an argument
    if [[ $1 ]]
    then
        echo -e "\n$1"
    fi

    echo -e "\nAre you sure you want to Check-In apartment$APARTMENT_TO_CHECK_IN? ( y / n )"
    read YES_OR_NO
  
    case $YES_OR_NO in
    y) CHECK_IN_COMPLEATED ;;
    n) EXIT ;;
    *) FINISH_CHECK_IN "Please write y or n to continue. To exit: Ctrl + Z."
    esac
}

CHECK_IN_COMPLEATED () {
    # Get user id
    CUSTOMER_ID=$($PSQL " SELECT customer_id FROM customers WHERE phone ='$PHONE_ENTERED'")
    # Insert data into schedule table
    INSERT_SCHEDULE=$($PSQL " INSERT INTO schedule(checkin_time, customer_id, apartment_id) VALUES(NOW(), $CUSTOMER_ID, $APARTMENT_CHOSEN) ")
    # Update availability of apartment
    UPDATE_AVAILABLILITY=$($PSQL " UPDATE apartments SET available='f' WHERE apartment_id=$APARTMENT_CHOSEN ")
    echo -e "\nCheck-In was successfull!"
}

CHECK_OUT () {
    # Check if the function received an argument
    if [[ $1 ]]
    then
        echo -e "\n$1"
    fi

    echo -e "\n~~~~~~~~~~~~~~~~~\n~~~ Check Out ~~~\n~~~~~~~~~~~~~~~~~"
    # Check if there are apartments pending for Check-Out.
    GET_UNAVAIL_APARTMENTS=$($PSQL " SELECT apartment_id, apartment_number FROM apartments WHERE available='f' ORDER BY apartment_id ")
    if  [[ -z $GET_UNAVAIL_APARTMENTS ]]
    then
        MAIN_MENU "Sorry, there are no apartments available for Check-Out."
    else
        echo -e "\nSelect an apartment for Check-Out:"
        echo "$GET_UNAVAIL_APARTMENTS" | while read APARTMENT_ID BAR APARTMENT_NUMBER
        do
            echo "$APARTMENT_ID) $APARTMENT_NUMBER"
        done
        read APARTMENT_CHOSEN

        if [[ ! $APARTMENT_CHOSEN =~ ^[0-9]+$ ]]
        then
            CHECK_OUT "That is not a valid apartment number. To exit: Ctrl + Z."
        else
            CHECK_OUT_CONFIRMATION
        fi
    fi
}

CHECK_OUT_CONFIRMATION () {
    # Get apartment to Check-Out.
    APARTMENT_TO_CHECK_OUT=$($PSQL " SELECT apartment_number FROM apartments WHERE apartment_id=$APARTMENT_CHOSEN AND available='f' ")
    if [[ -z $APARTMENT_TO_CHECK_OUT ]]
    then
        CHECK_OUT "Sorry, that apartment is not available for Check-Out. To exit: Ctrl + Z."
    else
        echo -e "\nAre you sure you want to Check-Out apartment $APARTMENT_CHOSEN? ( y / n )"
        read YES_OR_NO

        case $YES_OR_NO in
            y) FINISH_CHECK_OUT ;;
            n) EXIT ;;
            *) CHECK_OUT_CONFIRMATION "Please write y or n to continue. To exit: Ctrl + Z." ;;
        esac
    fi
}

FINISH_CHECK_OUT () {
    # Get schedule_id
    SCHEDULE_ID=$($PSQL " SELECT schedule_id FROM schedule WHERE checkout_time IS NULL AND apartment_id=$APARTMENT_CHOSEN ")
    # Get apartment ID
    UPDATE_SCHEDULE_CHECK_OUT_TIME=$($PSQL " UPDATE schedule SET checkout_time= NOW() WHERE apartment_id=$APARTMENT_CHOSEN ")
    UPDATE_AVAILABLILITY=$($PSQL " UPDATE apartments SET available='t' WHERE apartment_id=$APARTMENT_CHOSEN ")
    
    # Get Check-in and Check-out dates.
    CHECK_IN_DATE=$($PSQL " SELECT checkin_time FROM schedule WHERE schedule_id=$SCHEDULE_ID " )
    CHECK_OUT_DATE=$($PSQL " SELECT checkout_time FROM schedule WHERE schedule_id=$SCHEDULE_ID ")
    # Get apartment price per night
    PRICE_PER_DAY=$($PSQL " SELECT price FROM apartments WHERE apartment_id=$APARTMENT_CHOSEN ")
    # Convert both dates to seconds since epoch
    D1=$(date -d "$CHECK_IN_DATE" +%s)
    D2=$(date -d "$CHECK_OUT_DATE" +%s)

    # Calculate the difference in days
    DAY_DIFFERENCE=$(( (D2 - D1) / 86400 ))
    PRICE_TO_PAY=$(($PRICE_PER_DAY * $DAY_DIFFERENCE))

    UPDATE_TOTAL_PRICE=$($PSQL " UPDATE schedule SET total=$PRICE_TO_PAY WHERE schedule_id=$SCHEDULE_ID ")
    echo -e "\nYou have successfully checked out apartment$APARTMENT_TO_CHECK_OUT."
}

EXIT () {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU