#! /usr/bin/bash
echo  -e "${note} Database ${dbname} Tables....."
ls  ${path}/${dbname}
echo -e "${base} ${NC}" 
#prompt the user to enter the table name
read -p "Enter the table name: " tablename
tablename=$(echo "$tablename" | tr ' ' '_')
#check if the table file exists
if [[ -z $tablename || ! -f $path/$dbname/$tablename ]] ; then
echo -e "${invalid} The Table ${tablename} NOt Found!${NC}"
source db_menu.sh
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
# check if the column is PK (primary key)
if [ "${names_array[$i]}" == "id" ]; then
while true; do
read -p "Enter data for ${names_array[$i]} (${types_array[$i]}): " value 
 # check if the entered id already exists in the table
if ! grep -q "|$value|" "$path/$dbname/$tablename"; then
break
else
echo -e "${invalid}The entered id $value already exists. Please enter a unique id.${NC}"
fi
done
else
# for non-id columns, proceed normally
read -p "Enter data for ${names_array[$i]} (${types_array[$i]}): " value
fi
data+="$value|"
done
echo -e "$data"
data=${data%"|"}
# Append the data to the table file
echo $data >> $path/$dbname/$tablename
#echo -e "$path/$dbname/$tablename"

echo -e "${note} Data inserted successfully!${NC}"
source db_menu.sh

source master_menu.sh

