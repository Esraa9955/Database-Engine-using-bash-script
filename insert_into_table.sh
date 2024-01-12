#! /usr/bin/bash
#prompt the user to enter the table name
read -p "Enter the table name: " tablename
#check if the table file exists

if [ ! -f "$path/$dbname/$tablename" ] ;
then
echo -e "${invalid}Table $tablename does not exist. Exiting....${NC} "
#exit 1
fi
# get column names and datatypes from the table file
column_names=$(sed -n '1p' "$path/$dbname/$tablename")
column_types=$(sed -n '2p' "$path/$dbname/$tablename")

#prompt the user to enter the data for each column
data=''
IFS='|' read -ra names_array <<< "$column_names"
IFS='|' read -ra types_array <<< "$column_types"

for((i=0;i<${#names_array[@]};i++)) ;
do
read -p "Enter data for ${names_array[$i]} (${types_array[$i]}): " value
data+="$value|"
done
echo -e "$data"
data=${data%"|"}
# Append the data to the table file
echo $data >> $path/$dbname/$tablename
#echo -e "$path/$dbname/$tablename"

echo -e "${note} Data inserted successfully!${NC}"
source master_menu.sh
#source creat_table.sh
