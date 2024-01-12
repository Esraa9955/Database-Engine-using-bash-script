#!/bin/bash

read -p "Enter database name you want to drop : " dbname

dbname=$(echo "$dbname" | tr ' ' '_')

if [[ -z $dbname || ! -d $path"/"$dbname ]] ; then
    echo -e "${invalid}  Database ${dbname} not Found ${NC}"
else
    echo -e "${invalid} Are you sure to delete ${dbname} [y/n] : ${NC}  " 
    read ans
    if [[ $ans == "y" || $ans == "Y" ]] ; then 
        rm -r $path"/"$dbname 
        echo -e "${note} Database ${dbname} deleted succssfully. ${NC}"
    fi
fi
source master_menu.sh
