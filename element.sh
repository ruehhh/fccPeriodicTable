#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
else
  if [[ "$1" =~ ^[0-9]+$ ]]
    then
      QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements AS e JOIN properties AS p USING(atomic_number) JOIN types AS t USING(type_id) WHERE atomic_number = $1")
  else
    QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements AS e JOIN properties AS p USING(atomic_number) JOIN types AS t USING(type_id) WHERE symbol = '$1' or name = '$1'")
  fi
  if [[ -z $QUERY_RESULT ]]
  then
    echo I could not find that element in the database.
  else
    IFS='|'
    read -ra QRA <<< "$QUERY_RESULT"
    echo "The element with atomic number ${QRA[0]} is ${QRA[2]} (${QRA[1]}). It's a ${QRA[3]}, with a mass of ${QRA[4]} amu. ${QRA[2]} has a melting point of ${QRA[5]} celsius and a boiling point of ${QRA[6]} celsius."
  fi
fi

