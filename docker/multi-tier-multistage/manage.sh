#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

action=""
WORKDIR=""
COMPOSE_FILE="docker-compose.yaml"

usage() {
    cat <<EOF
Usage: $(basename "$0") [-s|-t|-r|-l] [-d WORKDIR] [-f COMPOSE_FILE]

Options:
  -s                 Start services (docker compose up -d)
  -t                 Stop services (docker compose down)
  -r                 Restart services (down then up -d)
  -l                 Show logs (docker compose logs -f)
  -d WORKDIR         Directory containing docker-compose file (default: current dir)
  -f COMPOSE_FILE    Compose file name (default: docker-compose.yaml)
  -h                 Show this help

Examples:
  $(basename "$0") -s -d /path/to/project
  $(basename "$0") -l -d /path/to/project -f compose.yml
EOF
}

# Determine docker compose command (prefer docker compose, fallback to docker-compose)
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD=(docker-compose)
else
  echo "Error: Neither 'docker compose' nor 'docker-compose' is available in PATH." >&2
  exit 1
fi

while getopts ":strld:f:h" opt; do
  case "$opt" in
    s) action="start" ;;
    t) action="stop" ;;
    r) action="restart" ;;
    l) action="logs" ;;
    d) WORKDIR="$OPTARG" ;;
    f) COMPOSE_FILE="$OPTARG" ;;
    h) usage; exit 0 ;;
    :) echo "Error: -$OPTARG requires an argument" >&2; usage; exit 1 ;;
    \?) echo "Error: Invalid option -$OPTARG" >&2; usage; exit 1 ;;
  esac
done

# Default to current directory if -d not provided
if [[ -z "$WORKDIR" ]]; then
  WORKDIR="$(pwd)"
fi

if [[ -z "$action" ]]; then
  echo "Error: Please specify one of -s|-t|-r|-l" >&2
  usage
  exit 1
fi

if [[ ! -d "$WORKDIR" ]]; then
  echo "Error: WORKDIR does not exist: $WORKDIR" >&2
  exit 1
fi

pushd "$WORKDIR" >/dev/null

if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo "Error: Compose file not found: $WORKDIR/$COMPOSE_FILE" >&2
  popd >/dev/null
  exit 1
fi

case "$action" in
  start)
    "${COMPOSE_CMD[@]}" -f "$COMPOSE_FILE" up -d
    ;;
  stop)
    "${COMPOSE_CMD[@]}" -f "$COMPOSE_FILE" down
    ;;
  restart)
    "${COMPOSE_CMD[@]}" -f "$COMPOSE_FILE" down
    "${COMPOSE_CMD[@]}" -f "$COMPOSE_FILE" up -d
    ;;
  logs)
    "${COMPOSE_CMD[@]}" -f "$COMPOSE_FILE" logs -f
    ;;
  *)
    echo "Error: Unknown action $action" >&2
    usage
    popd >/dev/null
    exit 1
    ;;
esac

popd >/dev/null


