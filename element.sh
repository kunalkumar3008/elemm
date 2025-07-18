#!/bin/bash

input=$1

MENU() {
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  # Check if argument provided
  if [[ -z $input ]]; then
    echo "Please provide an element as an argument."
    return
  fi

  # Try to match by number, symbol, name
  if [[ $input =~ ^[0-9]+$ ]]; then
    pos1=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $input")
  else
    pos2=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$input'")
    pos3=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$input'")
  fi

  # Set the found atomic number
  if [[ ! -z $pos1 ]]; then
    atomic_number=$pos1
  elif [[ ! -z $pos2 ]]; then
    atomic_number=$pos2
  elif [[ ! -z $pos3 ]]; then
    atomic_number=$pos3
  fi

  # If no match found
  if [[ -z $atomic_number ]]; then
    echo "I could not find that element in the database."
    return
  fi

  # Now safely fetch data
  symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $atomic_number")
  name=$($PSQL "SELECT name FROM elements WHERE atomic_number = $atomic_number")
  type_id=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $atomic_number")
  type=$($PSQL "SELECT type FROM types WHERE type_id = $type_id")
  atomic_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $atomic_number")
  melting_point_celsius=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $atomic_number")
  boiling_point_celsius=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $atomic_number")

  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
}

MENU "$input"
