#!/usr/bin/bash

echo -e "${note} Database ${dbname} Tables....."
ls "${path}/${dbname}"
echo -e "${base} ${NC}"

# Prompt the user to enter the table name
read -p "Enter the table name: " tablename
tablename=$(echo "$tablename" | tr ' ' '_')

# Check if the table file exists
if [[ -z $tablename || ! -f "$path/$dbname/$tablename" ]]; then
    echo -e "${invalid} The Table ${tablename} Not Found!${NC}"
    source db_menu.sh
fi

# Get column names and datatypes from the table file
column_names=$(sed -n '1p' "$path/$dbname/$tablename")
column_types=$(sed -n '2p' "$path/$dbname/$tablename")

# Prompt the user to enter the data for each column
data=''
IFS='|' read -ra names_array <<< "$column_names"
IFS='|' read -ra types_array <<< "$column_types"

for ((i=0; i<${#names_array[@]}; i++)); do
    while true; do
        # Check if the column is PK (primary key)
        if [ "${names_array[$i]}" == "id" ]; then
            read -p "Enter data for ${names_array[$i]} (${types_array[$i]}): " value

            # Validate input for id to be an integer starting from 1
            if [[ ! $value =~ ^[1-9][0-9]*$ ]]; then
                echo -e "${invalid}Invalid ${names_array[$i]}. Please enter an integer starting from 1.${NC}"
            elif grep -q "^$value|" "$path/$dbname/$tablename"; then
                echo -e "${invalid}The entered id $value already exists. Please enter a unique id.${NC}"
            else
                break
            fi
        else
            # For non-id columns, proceed normally
            read -p "Enter data for ${names_array[$i]} (${types_array[$i]}): " value

            # Validate input based on data type using regex
            case ${types_array[$i]} in
                "VARCHAR")
                    if [[ ! $value =~ ^[a-zA-Z0-9_]+$ ]]; then
                        echo -e "${invalid}${names_array[$i]} must be a string.${NC}"
                    else
                        break
                    fi
                    ;;
                "INTEGER")
                    if [[ ! $value =~ ^[0-9]+$ ]]; then
                        echo -e "${invalid}${names_array[$i]} must be an integer.${NC}"
                    else
                        break
                    fi
                    ;;
                "DATE")
                    if [[ ! $value =~ ^[0-9]{1,2}-[0-9]{1,2}-[0-9]{4}$ ]]; then
                        echo -e "${invalid}${names_array[$i]} must be in DATE format (DD-MM-YYYY).${NC}"
                    else
                        break
                    fi
                    ;;
            esac
        fi
    done

    data+="$value|"
done

echo -e "$data"
data=${data%"|"}

# Append the data to the table file
echo "$data" >> "$path/$dbname/$tablename"

echo -e "${note} Data inserted successfully!${NC}"
source db_menu.sh