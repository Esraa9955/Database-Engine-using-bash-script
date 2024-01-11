#! usr/bin/bash

# get table name and make some validations

read -p "pls Enter table name : " tablename
while [[ -z $tablename || $tablename =~ ^[0-9] || $tablename == *['~`!@#$%^&*-+=/|\:.,;''"?><}{)(][']* ]]
do
echo -e "$invalid Invalid table name $NC"
read -p "pls Enter table name : " tablename
done

#convert spaces to underscore (_)
tablename=$(echo "$tablename" | tr ' ' '-')

if [ -f $path/$dbname/$tablename ] ;
then
echo -e "${invalid} Table ${tablename} already exists ${NC}"
else
touch $path/$dbname/$tablename
echo -e "${note} Table ${tablename} created succssfull! ${NC}"

# create metadata of table
read -p "Enter number of columns for table ${tablename} : " numcolumns
# validations on column number and convert it to integer
while ! [[ $numcolumns =~ ^[1-9][0-9]*$ ]]
do 
echo -e "$invalid Invaild number $NC"
read -p "Enter number of columns for table ${tablename} : " numcolumns
done

# convert tablename to integer  to operate 
 let numcolumns=$numcolumns

# DB engine does not accept less than two columns
# the table can not be empty

while [[ $numcolumns < 2 ]]
do
echo -e "$invalid Minimum Number Of Columns is 2 $NC"
read -p "Enter number of columns for table ${tablename} : " numcolumns
done



# by default first column is id and the constraint on it is PK
echo -e "${note} Note the first column name is id and it is PK ${NC}"
#loop on number of columns (numcolumns) to get the anme&type of each column (string and int)
column_name='       id      '
column_type='     integer   '
for ((i=2;i<=$numcolumns;i++))
do
read -p "Enter column ${i} Name : " colName

# make validations on column name

while [[ -z $colName || $colName =~ ^[0-9] || $colName == *['~`!@#$%^&*-+=/|\:.,;''"?><}{)(][']* ]]
do
echo -e "$invalid Invalid Column Name $NC"
read -p "pls Enter Column ${i} Name : " colName
done

#convert spaces to underscore in column name
colName=$(echo "$colName" | tr ' ' '-')

# check if the column exist or not 
while [[ $column_name == *$"{colName}"* ]] ;
do
echo -e "${invalid} column ${colName} exist ${NC}"
read -p "pls Enter Column $i Name : " colName
done

# Append column name to the existing names
column_name+="      |       $colName"


 # Get data type for the column
 echo -e "${note} Enter Data Types [VARCHAR|INTEGER|DATE] for column $colName ${NC}"
select choice in "VARCHAR" "INTEGER" "DATE" ;
do
case $choice in
"VARCHAR" ) column_type+="      |     VARCHAR";
break;;
"INTEGER" ) column_type+="      |     INTEGER";
break;;
"DATE" ) column_type+="      |       DATE";
break;;
* ) echo -e "${invalid}Invalid data type${NC}"; 
continue;;
esac
done

done

# write column name and thier datatype in the table file
echo $column_name >> $path/$dbname/$tablename
echo $column_type >> $path/$dbname/$tablename
echo -e "${note} your table [$tablename] metadata is : \n $column_name \n -----------------------------------------------------------------------------------------------------------------\n$column_type ${NC}"

fi
source db_menu.sh
