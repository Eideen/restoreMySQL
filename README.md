# restoreMySQL
Restore many files sql files in a guided way

How to run:
```
cd [path to folder with sql files]
wget 
./db_restore.sh



>```
>
>Input username for mysql server [USER]:
>Input hostname for mysql server [localhost]:
>list of databases before:
>* information_schema
>* mysql
>* performance_schema
>Warning: importing database will overwrite your exsisting data!
>
>Are you sure, you wanted to import librenms [y/N]y
>librenms exist
>importing data in librenms
>8.24MiB 0:00:16 [ 519KiB/s] [====================================================>] 100%
>
>Are you sure, you wanted to import observium [y/N]
>observium exist
>importing data in observium
> 298MiB 0:02:39 [1.87MiB/s] [====================================================>] 100%
>list of databases after:
>* information_schema
>* librenms
>* mysql
>* observium
>* performance_schema
>```
