#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Daniel's Salon ~~~~~\n"

MAIN_MENU() {
  echo -e "\nWelcome to my Salon, how can I help you?"
  echo -e "\n1. View our services\n2. Schedule an appointment"

  read MAIN_MENU_SELECTION
  case $MAIN_MENU_SELECTION in
  1) LIST_AVAILABLE_SERVICES ;;
  2) SCHEDULE_APPOINTMENT ;;
  *) MAIN_MENU ;;
  esac
}

LIST_AVAILABLE_SERVICES() {
  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id;")
  echo "Here a list of our services:"
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  # at last return to main menu
  MAIN_MENU
}

SCHEDULE_APPOINTMENT() {
  echo "Please enter your phone number:"
  read PHONE_NUMBER
  echo $PHONE_NUMBER

  # at last return to main menu
  MAIN_MENU
}

MAIN_MENU