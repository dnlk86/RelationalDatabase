#!/bin/bash

PSQL="psql -X -U freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # check if argument is numeric
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    # if not numeric check for symbol or name
    ELEMENT_QUERY_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1' OR name='$1';";)
  else
    # if numeric check for atomic number
    ELEMENT_QUERY_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1;";)
  fi
  # check the result
  if [[ -z $ELEMENT_QUERY_RESULT ]]
  then
    # if result does not exist alert the user
    echo "I could not find that element in the database."
  else
    # if the result exists output all the information
    echo "$ELEMENT_QUERY_RESULT" | while IFS='|' read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi