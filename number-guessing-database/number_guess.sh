#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

# search fo user in the db
LOGIN_RESULT=$($PSQL "SELECT games_played, best_game FROM players WHERE user_name='$USERNAME';")
if [[ $LOGIN_RESULT ]]
then 
  # greet an old user coming back
  echo "$LOGIN_RESULT" | while IFS='|' read GAMES_PLAYED BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
else
  # enter the new user in the database
  USER_INSERT_RESULT=$($PSQL "INSERT INTO players(user_name) VALUES('$USERNAME');")
  # greet the new user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi

GENERATE_RANDOM_NUMBER() {
  NUMBER=$(( RANDOM % 1000 + 1))
}