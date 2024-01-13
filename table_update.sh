#!/bin/bash

echo  -e "${note} ********Database ${dbname} Tables : ******************"
         ls  ${path}/${dbname}
echo -e "*******************************************************${NC}"    

     
read -p  "Please Enter Table Name To Update data : "  tablename

 if [ -f $path"/"$dbname"/"$tablename ] ; then
    
    count=`cat $path"/"$dbname"/"$tablename | wc -l `
    if [[ $count  -gt 2 ]] ; then   

# get Columns name from table[first record]

colNames=`cut -d '|' -f 2- $path"/"$dbname"/"$tablename`
IFS='|' read -ra colArray <<< $colNames


# get Columns data types from table [second record]
typeArray=`head -2 $path"/"$dbname"/"$tablename | tail -1 | cut -d '|' -f 2- `
IFS='|' read -ra dataType <<< $typeArray




read -p "Please Enter Record Id : " id

if [[  ! $id =~ ^[1-9][0-9]*$  ]] ; then
    echo -e "${invalid}  Invalid Id  ${NC}"
    source db_menu.sh;
else

# search if first field is = id return entire record
current=`awk -v id=$id -F"|" '{if(NR>2 && $1==id) print $0}' $path"/"$dbname"/"$tablename `

        if [[ ! -z $current ]] ; then
        record=()
        
# loop for fileds&datatype
for (( i=0;i<${#colArray[@]};i++));
do

echo "Enter New Value Of " ${colArray[$i]}  "["${dataType[$i]}"]" 
read value
       
        
        if [[ ${dataType[$i]} = "VARCHAR" ]] ;  then
            if [[ ! $value == *[a-zA-z0-9]* ]] ; then      
                echo -e "${invalid}" ${colArray[$i]} " must be string  ${base}"
                source db_menu.sh;
            else
            
            value=$(echo "$value" | tr ' ' '_')
            
                    record[$i]=$value
            fi
        
        elif [[ ${dataType[$i]} = "INTEGER" ]] ;  then
            if [[ ! $value =~ ^[0-9]*$ ]] ; then
                echo -e "${invalid}" ${colArray[$i]} " must be integer  ${base}"
                source db_menu.sh;
            else
                    record[$i]=$value
            fi  
        
        elif [[ ${dataType[$i]} = "DATE"  ]] ;  then
            if [[ ! $value =~ ^[0-9]{1,2}-[0-9]{1,2}-[0-9]{4}$  ]] ; then
                echo -e "${invalid}" ${colArray[$i]} " must be DATE  ${base}"
                source db_menu.sh;
            else
                    record[$i]=$value
            fi        
        fi
      
      
    
done


data=""
for item in "${record[@]}"; do
    data+="$item|"
done
data="$id|${data%"|"}"  # Remove the trailing " | "

updateRecord="${data}"
sed -i "/^$id/s/$current/$updateRecord/" "$path/$dbname/$tablename"


    else
     echo -e "${invalid} Record Not Found ${NC}"
        source db_menu.sh
    fi
fi

    echo -e "${note} Record Update Succssfully.  ${NC}"
    source db_menu.sh  
    

    else
    echo -e "${invalid} Table ${tablename} doesnot contain any records ${NC}"
    source db_menu.sh
    fi

else
    echo -e "${invalid} Table  ${tablename} doesnot exist  ${NC}"
    source db_menu.sh 
fi
