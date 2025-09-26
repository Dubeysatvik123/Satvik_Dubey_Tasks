#!/bin/bash
db_name= "$1"
db_user= "$2"
db_host= "$3"
db_port= "$4"
backup_dir= "$5"
retention_day= "$6"

#setup
DATE=$(date +%F-%H-%m-%s)
backup_f= "$backup_dir/${db_name}_backup.$DATE.sql.gz"
mkdir -p "$backup_dir"


#backup

pg_dump -h "$db_host" -p "$db_port" -U "$db_user" "$db_name" | gzip > "$backup_f"

if [[ $? -eq 0 ]]; then
	echo "Backup Successful"
else
	echo "Backup Unsucessful"
fi

