#!/bin/bash

# In the .env file, set the SQL_CONNECTION variable to the connection string for your SQL database.
source .env
# Check if the SQL_CONNECTION variable is set
#Connect to PostgresSQL
PSQL="$SQL_CONNECTION"

echo -e "\n~~~~~~ Apartments Manager ~~~~~\n"

