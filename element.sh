
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1'")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

$PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, RTRIM(RTRIM(properties.atomic_mass::TEXT, '0'), '.'), types.type, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number = $ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL MASS TYPE MELTING BOILING
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
