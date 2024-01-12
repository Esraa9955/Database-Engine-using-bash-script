# !/usr/bin/bash
read -p "Enter the table name you want to Drop: " tablename
tablename=$(echo "$tablename" | tr ' ' '_')
if [[ -z $tablename || ! -f $path/$dbname/$tablename ]] ; then
echo -e "${invalid} The Table ${tablename} NOt Found!${NC}"
else
    echo -e "${invalid} Are you sure to delete ${tablename} [y/n] : ${NC}  " 
  
    read answer
    if [[ $answer == "y" || $answer == "Y" ]] ; then
        rm -r $path/$dbname/$tablename
        echo -e "${note} Table ${tablename} deleted successfully.${NC}"
    fi


fi
source db_menu.sh

source master_menu.sh