#!/usr/bin/bash
# get database name from user and make some regular expressions (regex) on it
read -p "Enter database name : " dbname
while [[ -z $dbname || $dbname =~ ^[0-9] || $dbname == *['~`!@#$%^&*-+=/|\:.,;''"?><}{)(][']* ]]
do 
echo -e "${invalid} Invaild Name ${NC}"
read -p "Enter database name  : " dbname
done
#convert spaces to underscore (_)
dbname=$(echo "$dbname" | tr ' ' '-')
#check if DB exists
if [ -d $path/$dbname ] ;
then
echo -e "${invalid} Database ${dbname} already exists ${NC}"
else
mkdir $path/$dbname
echo -e "${note} Database ${dbname} created succssfully ${NC}"
fi
source master_menu.sh