#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

# search fo user in the db
USER_ID=$($PSQL "SELECT user_id FROM players WHERE user_name='$USERNAME';")
if [[ -z $USER_ID ]]
then 
  # enter the new user in the database
  USER_INSERT_RESULT=$($PSQL "INSERT INTO players(user_name) VALUES('$USERNAME');")
  # greet the new user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GAMES_PLAYED=0
  BEST_GAME=0
else
  # greet an old user coming back
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM players WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT best_game FROM players WHERE user_id=$USER_ID;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

NUMBER=$(( RANDOM % 1000 + 1))
  
game_on=true
echo "Guess the secret number between 1 and 1000:"
while [ "$game_on" == "true" ]
do
  ((COUNT++))
  read USER_GUESS

  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ ! $USER_GUESS -eq $NUMBER ]]
    then
      if [[ $USER_GUESS -lt $NUMBER ]]
      then
        echo "It's higher than that, guess again:"
      else
        echo "It's lower than that, guess again:"
      fi
    else
      echo "You guessed it in $COUNT tries. The secret number was $NUMBER. Nice job!"
      # check if new best
      if [[ $COUNT < $BEST_GAME || $GAMES_PLAYED == 0 ]]
      then
        # replace new best game
        BEST_GAME=$COUNT
      fi
      ((GAMES_PLAYED++))
      UPDATE_PLAYER_RESULT=$($PSQL "UPDATE players SET games_played=$GAMES_PLAYED, best_game=$BEST_GAME WHERE user_name='$USERNAME';")
      game_on=false
    fi
  fi
done

