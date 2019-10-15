#!/bin/bash
# Shell script to backup MySQL database


#Files to restore

[ -z ${1+x} ] || cd $1

FILES=$(pwd)/*.sql
 if [ $(ls | grep '\.sql' | wc -l) == 0 ] 
  then
   echo "no databases to import in $(pwd)
    ./db_restore.sh [path to folder with sql files]"
  exit
 fi

#control for dependeces
# Linux bin paths
install=true
while $install ;do
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
PV="$(which pv)"
if [ -z $MYSQL ] || [ -z $MYSQLDUMP ] || [ -z $PV ]
then
 echo "Installing$RED missing dependeces{NC}"
  apt install mysqldump mariadb-client pv
 else install="false"
fi
done 

set -euo pipefail
IFS=$'\n\t'

#Text Colors
GREEN=`tput setaf 2`
RED=`tput setaf 1`
NC=`tput sgr0` #No color

#Output Strings
GOOD="${GREEN}NO${NC}"
BAD="${RED}YES${NC}"


# Set these variables

MyUSER=$(whoami)
read -r -t 60 -p "${NC}Input username for mysql server [$MyUSER]: $GREEN" 
if [[ $REPLY != "" ]]
then
MyUSER=$REPLY
fi

MyPASS=""
read -s -r -t 60 -p "${NC}Input password for mysql server: $GREEN"  
if [[ $REPLY != "" ]]
then
MyPASS=$REPLY
fi
echo
MyHOST="localhost"
read -r -t 60 -p "${NC}Input hostname for mysql server [$MyHOST]: $GREEN"  
if [[ $REPLY != "" ]]
then
MyHOST=$REPLY
fi


# DB skip list
SKIP="information_schema
performance_schema
another_one_db"

# Get all databases
DBS="$($MYSQL --connect-timeout=5 -h $MyHOST -u $MyUSER -p$MyPASS -Bse 'show databases')" || exit


listdb=""
echo -e "${NC}list of databases before:"
for i in $DBS
do
	echo "* $GREEN$i${NC}"
done

#dialog for import 
echo "Warning: importing database will overwrite your exsisting data!"
for f in $FILES
do
db=${f##*/} #removing text infront 
db=${db%.sql} #removing .sql

NEW=-1 #flag for status
 echo
 read -p "Are you sure, you wanted to import $GREEN$db${NC} [y/N]" -n 1 -r
 echo    # (optional) move to a new line 
	if [[ $REPLY =~ ^[Yy]$ ]]
		then
			listdb+="$db\n" #add the database to list.
			for i in $DBS #check if the dat exist
			do
			[ "$db" = "$i" ] && NEW=1 || : 
			done

			if [ "$NEW" == "-1" ]
				then
					echo "Creating database database $db"
					mysqladmin -h $MyHOST -u $MyUSER -p$MyPASS create $db

				else
					echo "$GREEN$db exist ${NC}"
			fi
						echo "importing data in $GREEN$db${NC}"
			pv $(pwd)/$db.sql | mysql -h $MyHOST -u $MyUSER -p$MyPASS  $db
	fi
done


if [ -z $listdb ] #check if there is datebase imported or quit
then
echo
echo "no databases selected to be to import" 
exit
fi

read -p "Do you like to update your database privilege [y/N]" -n 1 -r
 echo    # (optional) move to a new line
   if [[ $REPLY =~ ^[Yy]$ ]]
    then
  mysqladmin flush-privileges -h $MyHOST -u $MyUSER -p$MyPASS
  fi

listdb=$(echo ${listdb::-2}) #remove trail empty line
listdb=$(echo -e "$listdb")

# Get all databases
DBSold=$DBS
DBS="$($MYSQL -h $MyHOST -u $MyUSER -p$MyPASS -Bse 'show databases')"


echo -e "${NC}list of databases after:"

for db in $DBS
 do
NEW=-1
	for i in $DBSold
     do
    [ "$db" = "$i" ] && NEW=1 || : 
    done
    if [ "$NEW" != "-1" ]
     then
        echo "* ${NC}$db${NC}"
     else
        echo "* $GREEN$db${NC} "
    fi
done

exit
