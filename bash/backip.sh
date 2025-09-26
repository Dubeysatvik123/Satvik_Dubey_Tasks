#!/bin/bash
set -euo pipefail

act="$1"        
backup_type="$2"   
db_name="$3"
db_user="$4"
db_host="$5"
db_port="$6"
backup_dir="$7"
table_name="${8:-}"       
file="${9:-}" 

DATE=$(date +%F-%H-%M-%S)
mkdir -p "$backup_dir"

if [[ "$act" == "backup" ]]; then
    if [[ "$backup_type" == "full" ]]; then
        backup_f="$backup_dir/${db_name}_full_$DATE.sql.gz"
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" "$db_name" | gzip > "$backup_f"

    elif [[ "$backup_type" == "schema" ]]; then
        backup_f="$backup_dir/${db_name}_schema_$DATE.sql.gz"
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -s "$db_name" | gzip > "$backup_f"

    elif [[ "$backup_type" == "data" ]]; then
        backup_f="$backup_dir/${db_name}_data_$DATE.sql.gz"
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -a "$db_name" | gzip > "$backup_f"

    elif [[ "$backup_type" == "table" ]]; then
        if [[ -z "$table_name" ]]; then
            echo "Table name required"
            exit 1
        fi
        backup_f="$backup_dir/${db_name}_${table_name}_table_$DATE.sql.gz"
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -t "$table_name" "$db_name" | gzip > "$backup_f"

    else
        echo "Invalid backup type: $backup_type"
        exit 1
    fi

    echo "Backup Successful: $backup_f"

elif [[ "$act" == "restore" ]]; then
    if [[ -z "$file" ]]; then
        echo "Please provide the backup file to restore"
        exit 1
    fi
    if [[ ! -f "$file" ]]; then
        echo "File not found: $file"
        exit 1
    fi

    echo "Restoring from $file ..."
    gunzip -c "$file" | psql -h "$db_host" -p "$db_port" -U "$db_user" "$db_name"
    echo "Restore Successful into database: $db_name"

else
    echo "Usage:"
    echo "  $0 backup [full|schema|data|table] db_name db_user db_host db_port backup_dir [table_name]"
    echo "  $0 restore [full|schema|data|table] db_name db_user db_host db_port backup_dir [table_name] file"
    exit 1
fi

