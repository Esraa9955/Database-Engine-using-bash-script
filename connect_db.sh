#!/bin/bash
read -p "Enter database name to connect : " dbname
dbname=$(echo "$dbname" | tr ' ' '-')
if [[ -z $dbname || ! -d $path"/"$dbname ]] ; then
echo -e "${invalid}  Database not Found ${NC}"
source master_menu.sh
else
export $dbname
source db_menu.sh
fi