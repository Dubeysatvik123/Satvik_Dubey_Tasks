#!/bin/bash

usage() {
    echo "Usage: $0 [-s | -t | -r | -l] -d <directory or full path to yaml>"
    exit 1
}

action=""
WORKDIR=""

while getopts "strld:h" opt; do
    case "$opt" in
        s) action="start" ;;
        t) action="stop" ;;
        r) action="restart" ;;
        l) action="logs" ;;
        d) WORKDIR="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

[ -z "$action" ] && { echo "❌ No action specified"; usage; }
[ -z "$WORKDIR" ] && { echo "❌ No directory specified"; usage; }

# Check if it's a directory or file
if [ -d "$WORKDIR" ]; then
    cd "$WORKDIR" || { echo "❌ Directory $WORKDIR not found"; exit 1; }
    COMPOSE_FILE="$WORKDIR/docker-compose.yml"
    [ ! -f "$COMPOSE_FILE" ] && COMPOSE_FILE="$WORKDIR/docker-compose.yaml"
else
    # it's a file
    COMPOSE_FILE="$WORKDIR"
    cd "$(dirname "$WORKDIR")" || { echo "❌ Directory not found"; exit 1; }
fi

# Check file exists
[ ! -f "$COMPOSE_FILE" ] && { echo "❌ Compose file $COMPOSE_FILE not found"; exit 1; }

case "$action" in
    start)   sudo docker-compose -f "$COMPOSE_FILE" up -d ;;
    stop)    sudo docker-compose -f "$COMPOSE_FILE" down ;;
    restart) sudo docker-compose -f "$COMPOSE_FILE" down && sudo docker-compose -f "$COMPOSE_FILE" up -d ;;
    logs)    sudo docker-compose -f "$COMPOSE_FILE" logs -f ;;
esac

