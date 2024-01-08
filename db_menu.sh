#!/bin/bash
echo -e "${note} **** You connected to database : ${dbname} ***${NC}" 

select option in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Back To Menu"
do
case $option in
"Create Table" )
    source create_table.sh;;
"List Tables" )
    source list_table.sh;; 
"Drop Table" )
    source drop_table.sh;;
"Insert into Table" )
    source insert_into_table.sh ;;
"Select From Table" )
    source select_from_table.sh ;;
"Delete From Table" )
    source delete_from_table.sh;;
 "Update Table" )
    source table_update.sh;;
 "Back To Menu" )
    source master_menu.sh;;
* ) 
    echo -e "${invalid} Invalid option ${NC}" ;; 
esac
done
