#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

# search fo user in the db
LOGIN_RESULT=$($PSQL "SELECT games_played, best_game FROM players WHERE user_name='$USERNAME';")
if [[ -z $LOGIN_RESULT ]]
then 
  # enter the new user in the database
  USER_INSERT_RESULT=$($PSQL "INSERT INTO players(user_name) VALUES('$USERNAME');")
  # greet the new user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GAMES_PLAYED=0
  BEST_GAME=0
else
  # greet an old user coming back
  echo "$LOGIN_RESULT" | while IFS='|' read GAMES_PLAYED BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

NUMBER=$(( RANDOM % 1000 + 1))
echo $NUMBER

echo "Guess the secret number between 1 and 1000:"  
read USER_GUESS
COUNT=1

# increment user's number of games

game_on=true
while [ $game_on ]
do
  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $USER_GUESS -eq $NUMBER ]]
    then
      echo "You guessed it in $COUNT tries. The secret number was $NUMBER. Nice job!"
      # check if new best
      if [[ $COUNT -lt $BEST_GAME || $GAMES_PLAYED -eq 0 ]]
      then
        # replace new best game
        BEST_GAME=$COUNT
      fi
      # insert
      ((GAMES_PLAYED++))
      UPDATE_PLAYER_RESULT=$($PSQL "UPDATE players SET games_played=$GAMES_PLAYED, best_game=$BEST_GAME WHERE user_name='$USERNAME';")
      break
    elif [[ $USER_GUESS -lt $NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    else
      echo "It's lower than that, guess again:"
    fi
  fi
  
  ((COUNT++))
  read USER_GUESS
done

