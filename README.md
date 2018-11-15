# restore MySQL database's
Restore many files sql files in a guided way.
Will import any sql fils.

## How to run:
```
cd [path to folder with sql files]
wget https://raw.githubusercontent.com/Eideen/restoreMySQL/master/db_restore.sh
./db_restore.sh
```
or 
```
./db_restore.sh [path to folder with sql files]
```

## Example of output:

>```
>$ll -h
>-rw-r--r-- 1 root root 8.3M Nov  7 22:22 db1.sql
>-rw-r--r-- 1 root root 299M Nov  7 22:22 db2.sql
>
>$./db_restore.sh
>Input username for mysql server [USER]:
>Input password for mysql server:
>Input hostname for mysql server [localhost]:
>list of databases before:
>* information_schema
>* mysql
>* performance_schema
>Warning: importing database will overwrite your exsisting data!
>
>Are you sure, you wanted to import db1 [y/N]y
>db1 exist
>importing data in db1
>8.24MiB 0:00:16 [ 519KiB/s] [====================================================>] 100%
>
>Are you sure, you wanted to import db2 [y/N]
>db2 exist
>importing data in db2
> 298MiB 0:02:39 [1.87MiB/s] [====================================================>] 100%
>list of databases after:
>* information_schema
>* db1
>* mysql
>* db2
>* performance_schema
>```
