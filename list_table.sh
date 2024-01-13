#!/bin/bash

# check if there tables
let count=`ls  $path"/"$dbname | wc -l`
if [[ $count =  1 ]] ; then
echo  -e "${note} ******** You have only one Table *******${NC}"
ls -F $path"/"$dbname 

elif [[ $count  >   1 ]] ; then
echo  -e "${note} **** You have [${count}] Tables  ****${NC}"
ls -F $path"/"$dbname 

else
echo -e "${invalid} No Tables Found ${base}"

fi
source db_menu.sh   



