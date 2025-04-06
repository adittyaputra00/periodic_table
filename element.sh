# Script to fetch element details from PostgreSQL database
#!/bin/bash

# Connect to the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if argument was provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Determine search condition (number or text)
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
    FROM elements 
    INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id) 
    WHERE atomic_number = $1;")
else
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
    FROM elements 
    INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id) 
    WHERE symbol ILIKE '$1' OR name ILIKE '$1';")
fi

# If no result found
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Parse and display
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$ELEMENT"
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

