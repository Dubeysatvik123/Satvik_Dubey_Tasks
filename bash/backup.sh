#!/bin/bash

show_help() {
    echo "Usage:"
    echo "  $0 --action backup --type [full|schema|data|table] --db-name DB --db-user USER --db-host HOST --db-port PORT --backup-dir DIR [--table-name TABLE]"
    echo "  $0 --action restore --db-name DB --db-user USER --db-host HOST --db-port PORT --backup-dir DIR --file FILE"
    echo
    echo "Options:"
    echo "  --action       backup | restore"
    echo "  --type         full | schema | data | table (for backup)"
    echo "  --db-name      Database name"
    echo "  --db-user      Database user"
    echo "  --db-host      Database host (default: localhost)"
    echo "  --db-port      Database port (default: 5432)"
    echo "  --backup-dir   Directory to store/read backups"
    echo "  --table-name   Table name (for table backup)"
    echo "  --file         Backup file to restore"
    echo "  -h             Show this help"
    exit 0
}

# Default values
act=""
backup_type=""
db_name=""
db_user=""
db_host="localhost"
db_port="5432"
backup_dir=""
table_name=""
file=""

# Argument parsing with if/elif
if [[ "$1" == "-h" ]]; then
    show_help
fi

if [[ "$1" == "--action" ]]; then act="$2"; fi
if [[ "$3" == "--type" ]]; then backup_type="$4"; fi
if [[ "$5" == "--db-name" ]]; then db_name="$6"; fi
if [[ "$7" == "--db-user" ]]; then db_user="$8"; fi
if [[ "$9" == "--db-host" ]]; then db_host="${10}"; fi
if [[ "${11:-}" == "--db-port" ]]; then db_port="${12}"; fi
if [[ "${13:-}" == "--backup-dir" ]]; then backup_dir="${14}"; fi
if [[ "${15:-}" == "--table-name" ]]; then table_name="${16}"; fi
if [[ "${17:-}" == "--file" ]]; then file="${18}"; fi

DATE=$(date +%F-%H-%M-%S)
mkdir -p "$backup_dir"

if [[ "$act" == "backup" ]]; then
    if [[ "$backup_type" == "full" ]]; then
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" "$db_name" | gzip > "$backup_dir/${db_name}_full_$DATE.sql.gz"

    elif [[ "$backup_type" == "schema" ]]; then
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -s "$db_name" | gzip > "$backup_dir/${db_name}_schema_$DATE.sql.gz"

    elif [[ "$backup_type" == "data" ]]; then
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -a "$db_name" | gzip > "$backup_dir/${db_name}_data_$DATE.sql.gz"

    elif [[ "$backup_type" == "table" ]]; then
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -t "$table_name" "$db_name" | gzip > "$backup_dir/${db_name}_${table_name}_table_$DATE.sql.gz"
    fi

elif [[ "$act" == "restore" ]]; then
    gunzip -c "$file" | psql -h "$db_host" -p "$db_port" -U "$db_user" "$db_name"
fi

