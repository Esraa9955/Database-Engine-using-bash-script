#!/bin/bash

# check if there databases
count=`ls ${path} | wc -l`

if [[ $count =  1 ]] ; then
echo  -e "${note} ******** You have only one Database *******${NC}"
ls -F ${path} | tr '/' ' '
elif [[ $count >  1 ]] ; then
echo  -e "${note} **** You have [${count}] Databases  ****${NC}"
ls -F ${path} | tr '/' ' '
else
echo -e "${invalid} No Databases Found ${NC}"
fi

source master_menu.sh  
