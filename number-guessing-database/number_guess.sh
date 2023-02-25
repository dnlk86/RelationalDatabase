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

NUMBER=$(( RANDOM % 1000 + 1))
echo $NUMBER

echo "Guess the secret number between 1 and 1000:"  
read USER_GUESS
COUNT=1
game_on=true
while [ game_on ]
do
  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $USER_GUESS -eq $NUMBER ]]
    then
      echo "You guessed it in $COUNT tries. The secret number was $NUMBER. Nice job!"
      break
    else if [[ $USER_GUESS -lt $NUMBER ]]
      echo "It's higher than that, guess again:"
    else
      echo "It's lower than that, guess again:"
    fi
  fi
  
  ((COUNT++))
  read USER_GUESS
done

