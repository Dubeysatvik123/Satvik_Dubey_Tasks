#!/bin/bash



act=""
backup_type=""
db_name=""
db_user=""
db_host="localhost"
db_port="5432"
backup_dir=""
table_name=""


show_help() {
    echo "Usage:"
    echo "  $0 -a backup -t [full|schema|data|table] -d DB -u USER [-H HOST] [-P PORT] -b DIR [-T TABLE]"
    echo "  $0 -a restore -t [full|schema|data|table] -d DB -u USER [-H HOST] [-P PORT] -b DIR [-T TABLE]"
    echo
    echo "Options:"
    echo "  -a  Action: backup | restore"
    echo "  -t  Type: full | schema | data | table"
    echo "  -d  Database name"
    echo "  -u  Database user"
    echo "  -H  Database host (default: localhost)"
    echo "  -P  Database port (default: 5432)"
    echo "  -b  Backup directory"
    echo "  -T  Table name (required for table type)"
    echo "  -h  Show this help"
    exit 0
}



while getopts "a:t:d:u:H:P:b:T:h" opt; do
    case "$opt" in
        a) act="$OPTARG" ;;
        t) backup_type="$OPTARG" ;;
        d) db_name="$OPTARG" ;;
        u) db_user="$OPTARG" ;;
        H) db_host="$OPTARG" ;;
        P) db_port="$OPTARG" ;;
        b) backup_dir="$OPTARG" ;;
        T) table_name="$OPTARG" ;;
        h) show_help ;;
        *) echo "Unknown option: $opt"; show_help ;;
    esac
done



if [[ -z "$act" ]] || [[ -z "$backup_type" ]] || [[ -z "$db_name" ]] || [[ -z "$db_user" ]] || [[ -z "$backup_dir" ]]; then
    echo "Error: Missing required options"
    show_help
fi

DATE=$(date +%F-%H-%M-%S)
mkdir -p "$backup_dir"



if [[ "$act" == "backup" ]]; then
    if [[ "$backup_type" == "full" ]]; then
        backup_file="$backup_dir/${db_name}_full_$DATE.sql.gz"
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" "$db_name" | gzip > "$backup_file"

    elif [[ "$backup_type" == "schema" ]]; then
        backup_file="$backup_dir/${db_name}_schema_$DATE.sql.gz"
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -s "$db_name" | gzip > "$backup_file"

    elif [[ "$backup_type" == "data" ]]; then
        backup_file="$backup_dir/${db_name}_data_$DATE.sql.gz"
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -a "$db_name" | gzip > "$backup_file"

    elif [[ "$backup_type" == "table" ]]; then
        if [[ -z "$table_name" ]]; then
            echo "Error: Table name required for table backup"
            exit 1
        fi
        backup_file="$backup_dir/${db_name}_${table_name}_table_$DATE.sql.gz"
        pg_dump -h "$db_host" -p "$db_port" -U "$db_user" -t "$table_name" "$db_name" | gzip > "$backup_file"

    else
        echo "Error: Invalid backup type"
        exit 1
    fi

    echo "Backup successful: $backup_file"



elif [[ "$act" == "restore" ]]; then

    if [[ "$backup_type" == "full" ]]; then
        file=$(ls -t "$backup_dir/${db_name}_full_"*.sql.gz 2>/dev/null | head -1)
    elif [[ "$backup_type" == "schema" ]]; then
        file=$(ls -t "$backup_dir/${db_name}_schema_"*.sql.gz 2>/dev/null | head -1)
    elif [[ "$backup_type" == "data" ]]; then
        file=$(ls -t "$backup_dir/${db_name}_data_"*.sql.gz 2>/dev/null | head -1)
    elif [[ "$backup_type" == "table" ]]; then
        if [[ -z "$table_name" ]]; then
            echo "Error: Table name required for table restore"
            exit 1
        fi
        file=$(ls -t "$backup_dir/${db_name}_${table_name}_table_"*.sql.gz 2>/dev/null | head -1)
    else
        echo "Error: Invalid restore type"
        exit 1
    fi

    if [[ ! -f "$file" ]]; then
        echo "Error: Backup file not found for type $backup_type"
        exit 1
    fi

    echo "Restoring $backup_type from $file ..."
    gunzip -c "$file" | psql -h "$db_host" -p "$db_port" -U "$db_user" "$db_name"
    echo "Restore successful into database: $db_name"

else
    echo "Error: Invalid action: $act"
    show_help
fi

