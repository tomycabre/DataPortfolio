#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL"TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # TEAMS TABLE
    # GET TEAM_ID
    TEAM_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER' AND name='$OPPONENT'")
    # IF NOT FOUND
    if [[ -z $TEAM_ID ]] 
    then
      # INSERT WINNER
      INSERT_WINNER=$($PSQL"INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_WINNER == 'INSERT 0 1' ]]
      then
        echo Winners inserted into teams, $WINNER
      fi
      # INSERT OPPONENT
      INSERT_OPPONENT=$($PSQL"INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_OPPONENT == 'INSERT 0 1' ]]
      then
        echo Opponents inserted into teams, $OPPONENT
      fi
    fi
    # GAMES TABLE
    # GET GAME_ID
    # GET WINNER_ID
    WINNER_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $GAME_ID ]]
    then
      INSERT_GAMES=$($PSQL"INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAMES == 'INSERT 0 1' ]]
      then
       echo the $YEAR $ROUND confronting $WINNER vs $OPPONENT was succesfully added
      fi 
    fi
  fi
done