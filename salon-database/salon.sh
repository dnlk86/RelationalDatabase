#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Daniel's Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id;")
  echo -e "\nHere's a list of our services:"
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  echo -e "\nPlease enter the service number you want to schedule."

  read SERVICE_ID_SELECTED
  # if service does not exist
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED";)
  if [[ -z $SERVICE_NAME ]]
  then
    # alert the user and send to main menu
    MAIN_MENU "I'm sorry we do not offer that service."
  else
    echo -e "\nPlease enter your phone number:"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_NAME ]]
    then
      # register a new customer
      echo -e "You are not registered in our system yet, please enter your name:"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
      if [[ $INSERT_CUSTOMER_RESULT ]]
      then
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
        echo -e "\nPerfect $CUSTOMER_NAME, you are now registered in our database!"
      fi
    else
      # greet a returning customer
      echo -e "\nHi$CUSTOMER_NAME, it's great to have you back."
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
    # enter the time for the desired service
    echo -e "\nPlease enter the time you want to schedule an appointment (hh:mm):"
    read SERVICE_TIME
    INSERT_APPOINTENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  fi

}

MAIN_MENU