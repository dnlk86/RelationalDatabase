#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Daniel's Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  LIST_AVAILABLE_SERVICES

  echo -e "\nHow can I help you?"

  # echo -e "\n1. Schedule an appointment\n2. Exit"

  read SERVICE_SELECTION
  case $SERVICE_SELECTION in
  1) HAIRCUT ;;
  2) HAIRSTYLE ;;
  3) HAIRTRIM ;;
  4) HAIRSHAVE ;;
  5) BEARDTRIM ;;
  6) BEARDSHAVE ;;
  *) MAIN_MENU "I'm sorry we do not offer that service." ;;
  esac
}

LIST_AVAILABLE_SERVICES() {
  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id;")
  echo "Here a list of our services:"
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

SCHEDULE_APPOINTMENT() {
  echo "Please enter your phone number:"
  read PHONE_NUMBER
  echo $PHONE_NUMBER

  # at last return to main menu
  MAIN_MENU
}

MAIN_MENU