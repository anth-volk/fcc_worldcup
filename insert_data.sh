#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # If not reading the header row
  if [[ $WINNER != "winner" ]]
  then
    # Create two variables for team ID's to avoid querying twice, if possible
    WINNER_ID=0
    OPPONENT_ID=0

    # Query db for winner
    QUERY_FOR_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")

    # If not found, insert winner and echo success
    if [[ -z $QUERY_FOR_WINNER ]]
    then
      WINNER_INSERTION=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      echo $WINNER_INSERTION
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    else
      WINNER_ID=$QUERY_FOR_WINNER
    fi

    # Query db for opponent
    QUERY_FOR_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    # If not found, insert opponent and echo success
    if [[ -z $QUERY_FOR_OPPONENT ]]
    then
      OPPONENT_INSERTION=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      echo $OPPONENT_INSERTION
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    else
      OPPONENT_ID=$QUERY_FOR_OPPONENT
    fi    

    # Using WINNER_ID & OPPONENT_ID, add entire game to table
    GAME_INSERTION=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    echo $GAME_INSERTION

  fi

done