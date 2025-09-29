#!/bin/bash

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

ls $WORKDIR
case "$action" in
    start)   sudo docker-compose  up -d ;;
    stop)    sudo docker-compose   down ;;
    restart) sudo docker-compose  down && sudo docker-compose -f "$COMPOSE_FILE" up -d =;;
    logs)    sudo docker-compose logs ;;
esac
