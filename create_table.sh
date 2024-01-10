#! usr/bin/bash

# get table name and make some validations

read -p "pls Enter table name : " tablename
while [[ -z $tablename || $tablename =~ ^[0-9] || $tablename == *['~`!@#$%^&*-+=/|\:.,;''"?><}{)(][']* ]]
do
echo -e "$invalid Invalid table name $NC"
read -p "pls Enter table name : " tablename
done

#convert spaces to underscore (_)
dbname=$(echo "$dbname" | tr ' ' '-')

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
column_name=''
column_type=''
for ((i=2;i<=$numcolumns;i++))
do
read -p "Enter column ${i} Name : " colName

# make validations on column name

while [[ -z $colName || $colName =~ ^[0-9] || $colName == *['~`!@#$%^&*-+=/|\:.,;''"?><}{)(][']* ]]
do
echo -e "$invalid Invalid Column Name $NC"
read -p "pls Enter Column ${i} Name : " colName
done

#convert spaces to underscore (_)
colName=$(echo "$colName" | tr ' ' '-')

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
column_name+="id     :"$colName
else
column_name+="     :"$colName
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
echo "*****Enter data type for [" ${colArray[$index]} "] column : "
index+=1
# only support string, integer and float
select choice in "string" "integer" "float"
do
case $choice in
"string" )
if [ $i -eq 2 ] ;
then
column_type=integer:string
else
column_type+="      :"string
fi
break;;

"integer" )

if [ $i -eq 2 ] ;
then
column_type=integer:integer
else
column_type+="      :"integer
fi
break;;

"float" )

if [ $i -eq 2 ] ;
then
column_type=integer:float
else
column_type+="      :"float
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
