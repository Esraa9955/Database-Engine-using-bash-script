#! /usr/bin/bash
export invalid='\033[1;31m'
export NC='\033[0m'
export note='\033[0;34m'

#DB path
export path="./database"
# if this is the first time run the script, create database directory
if [ ! -d database ]
then
mkdir database
fi


# database menu

select choose in "create Database" "List Database" "Connect Database" "Drop Database" "Exit"
do
case $choose in
"create Database" )
        source create_db.sh
        ;;
"List Database" )
        source list_db.sh
        ;;
"Connect Database" )
        source connect_db.sh
        ;;
"Drop Database" )
        source drop_db.sh;;
"Exit" )
        break
        ;;
*)
        echo -e "$invalid Invalid Option $NC"
        ;;
esac
done
