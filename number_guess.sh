#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo -e "\nNumber Guessing Game\n"
echo "Enter your username:"
read USERNAME
USERNAME_AVAILABLE=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(user_id) WHERE username = '$USERNAME'")
BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM users INNER JOIN games USING(user_id) WHERE username = '$USERNAME'")
if [[ -z $USERNAME_AVAILABLE ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RANDOM_NUMBER=$((1 + $RANDOM % 1000))
GUESS=1
echo -e "\nGuess the secret number between 1 and 1000:"

while read NUMBER
do
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
  else
    if [[ $NUMBER -eq $RANDOM_NUMBER ]]
    then
    break;
    else 
      if [[ $NUMBER -gt $RANDOM_NUMBER ]]
      then
        echo -e "\nIt's lower than that, guess again:"
      elif [[ $NUMBER -lt $RANDOM_NUMBER ]]
      then
        echo -e "\nIt's higher than that, guess again:"
      fi
    fi
  fi
  GUESS=$(( $GUESS + 1 ))
done

if [[ $GUESS == 1 ]]
then
  echo -e "\nYou guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
else
  echo -e "\nYou guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
INSERT_GAME=$($PSQL "INSERT INTO games(number_of_guesses, user_id) VALUES($GUESS, $USER_ID)")