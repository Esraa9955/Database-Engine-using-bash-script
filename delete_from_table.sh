#!/bin/bash

echo  -e "${note} ********Database ${dbname} Tables : ************"
         ls  ${path}/${dbname}
echo -e "*******************************************************${NC}"         

read -p  "Enter Table Name To Delete data : "  tablename

if [ -f $path"/"$dbname"/"$tablename ] ; then

# check if contains record
    count=`cat $path"/"$dbname"/"$tablename | wc -l ` 
    if [[ $count> 2 ]] ; then
    

echo -e "${invalid} please choose : ${NC}"
select choice in "Delete All Records" "Delete Specific Record By Id"  "Exit"
do
case $choice in 

"Delete All Records" ) 
echo -e "${invalid}Are you sure to delete  all records from ${tablename} ? [y/n] : ${NC}  " 
read ans
  if [[ $ans == "y" || $ans == "Y" ]] ; then 
    sed -i '3,$d' $path"/"$dbname"/"$tablename 
    echo -e "${note} ${tablename} Records deleted succssfully. ${NC}"
    source db_menu.sh;
fi
;;


"Delete Specific Record By Id" )
    read -p "Please Enter Record id : " id
if [[  ! $id =~ ^[1-9][0-9]*$  ]] ; then
    echo -e "${invalid}  Invalid Id ${NC}"
    source db_menu.sh;
else


row=$(awk -F"|" -v id="$id" '{if($1==id) print $0}' "$path/$dbname/$tablename")
        if [[ -z $row ]] ; then
            echo -e "${invaild} Record Not Found ${NC}"
            source db_menu.sh;
        else
        echo -e "${invalid}Are you sure to delete Record ${row} ? [y/n] : ${NC}  " 
        read ans
        if [[ $ans == "y" || $ans == "Y" ]] ; then 
            sed -i "/${row}/d" $path"/"$dbname"/"$tablename
            echo -e "${note} Record deleted from ${tablename}  succssfully ${NC}"
        fi
          source db_menu.sh;
        fi

fi
;;



"Exit" ) break 
    source db_menu.sh ;;


* ) 
echo -e "${invalid} Invalid choice ${NC} "
source db_menu.sh;
;;


esac
done

# Table is empty
    else
    echo -e "${invalid} Table ${tablename} doesnot contain any records ${NC}"
    source db_menu.sh
fi


# Table doesnot exist
else
    echo -e "${invalid} Table  ${tablename}  doesnot exist ${NC}"
    source db_menu.sh 
fi
