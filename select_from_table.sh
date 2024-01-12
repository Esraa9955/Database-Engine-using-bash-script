#!/bin/bash

echo  -e "${note} ********Database ${dbname} Tables : ************"
         ls  ${path}/${dbname}
echo -e "*******************************************************${NC}"  

      
read -p  "Enter Table Name To Select data : "  tablename
# check table exists
if [ -f $path"/"$dbname"/"$tablename ] ; then
    # check if contains record
    count=`cat $path"/"$dbname"/"$tablename | wc -l `
    if [[ $count > 2 ]] ; then
    
    
 colNames=`cut -d '|' -f 2- $path/$dbname/$tablename`    
echo -e "${invalid} please choose : ${NC}"
select choice in "Select All Records" "Select Specific Record By Id"     "Select All Values in Specific Column" "Exit"
do
case $choice in 
"Select All Records" ) 
awk -F"|" '{ if(NR==1) print $0  } {if(NR>2) print $0  }  ' $path"/"$dbname"/"$tablename 
;;


"Select Specific Record By Id" )
read -p "Please Enter Record id : " id
if [[  ! $id =~ ^[1-9][0-9]*$  ]] ; then
    echo -e "${invalid}  Invalid Id  ${NC}"
    source db_menu.sh;

else

row=`awk -F"|" -v id=$id '{if($1==id) print $0}' $path"/"$dbname"/"$tablename`
    if [[ -z $row ]] ; then
            echo -e "${invalid} Record Not Found ${NC}"
            source db_menu.sh;
    else
        awk -v id=$id -F"|" ' { if(NR==1) print $0 }    {if(NR>2 && $1==id) print $0}' $path"/"$dbname"/"$tablename 
    fi    
fi
;;





  "Select All Values in Specific Column")
  columns=$(head -n 1 $path"/"$dbname"/"$tablename)
    IFS='|' read -r -a col_array <<< "$columns"
                    echo "Select the column to display all values:"
                    select colname in "${col_array[@]}"; do
                        if [[ ! -z $colname ]]; then
                            col_index=$(awk -F"|" -v colname="$colname" '{for (i=1; i<=NF; i++) {if ($i == colname) {print i; exit}}}' $path"/"$dbname"/"$tablename)
                            awk -F"|" -v col_index="$col_index" '{print $col_index}' $path"/"$dbname"/"$tablename
                        else
                            echo -e "${invalid} Invalid Option ${NC}"
                            source db_menu.sh;
                        fi
                        break
                    done
                    ;;





"Exit" ) break ;;
* ) echo -e "${invalid} Invalid Option ${NC} ";;

esac
done


    else
    echo -e "${invalid} Table ${tablename} dose not contain any records ${NC}"
    fi
source db_menu.sh
else
    echo -e "${invalid} Table  ${tablename} doesnot exist ${NC}"
    source db_menu.sh 
fi
