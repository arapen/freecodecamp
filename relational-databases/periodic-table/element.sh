#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.boiling_point_celsius, p.melting_point_celsius, t.type
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE e.atomic_number::text = '$1' OR e.symbol = '$1' OR e.name = '$1';")

if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
else
  IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS BOILING_POINT MELTING_POINT TYPE <<< "$ELEMENT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

fi
