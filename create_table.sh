#! usr/bin/bash

# get table name 

read -p "pls Enter table name : " tablename


if [ -f $path/$dbname/$tablename ] ;
then
echo -e "${invalid} Table ${tablename} already exists ${NC}"
else
touch $path/$dbname/$tablename
echo -e "${note} Table ${tablename} created succssfull! ${NC}"

# create metadata of table
read -p "Enter number of columns for table ${tablename} : " numcolumns

# convert tablename to integer  to operate 
 let numcolumns=$numcolumns





# by default first column is id and the constraint on it is PK
echo -e "${note} Note the first column name is id and it is PK ${NC}"
#loop on number of columns (numcolumns) to get the anme&type of each column (string and int)
column_name=''
column_type=''
for ((i=2;i<=$numcolumns;i++))
do
read -p "Enter column ${i} Name : " colName



# check if the column exist or not 
while [[ $column_name == *$"{colName}"* ]] ;
do
echo -e "${invalid} column ${colName} exist ${NC}"
read -p "pls Enter Column ${i} Name : " colName
done

# if this is first iteration, set 1st column id:primary key 
# if it is not then append new column name

if [ $i -eq 2 ] ;
then 
column_name+="id:"$colName
else
column_name+=":"$colName
fi


done

# write column name in the table file
echo $column_name >> $path/$dbname/$tablename
# get data type of the column
echo -e "${note} Enter Data Types [string|integer] ${NC}"
# get columns name from table
colNames=`cut -d ':' -f 2-$numcolumns $path/$dbname/$tablename`
IFS=':' read -ra colArray <<< $colNames
let index=0
for ((i=2;i<=numcolumns;i++))
do
echo "*****Enter data type for [" ${colNames[$index]} "] filed : "
index+=1
# only support string, integer and float
select choice in "string" "integer" 
do
case $choice in
"string" )
if [ $i -eq 2 ] ;
then
column_type=integer:string
else
column_type+=:string
fi
break;;


"integer" )

if [ $i -eq 2 ] ;
then
column_type=integer:integer
else
column_type+=:integer
fi
break;;





* )
echo -e "${invalid} Invalid data type ${NC}"
continue;;
esac
# end select
done
#end for
done

echo $column_type >> $path/$dbname/$tablename
echo -e "${note} your table [${tablename}] metadata is : \n $column_name \n $column_type ${NC}"

fi
source db_menu.sh
