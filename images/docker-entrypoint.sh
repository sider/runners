#!/bin/bash

set -eo pipefail

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

RUNNERS_TIMEOUT=${RUNNERS_TIMEOUT:-30m}
args=()

while [[ -n "$1" ]]; do
  case "$1" in
  --timeout)
    shift
    if [[ -z "$1" ]]; then
      echo "'--timeout' requires DURATION" >&2
      exit 1
    fi
    RUNNERS_TIMEOUT="$1"
    ;;
  --timeout=*)
    RUNNERS_TIMEOUT="${1/--timeout=/}"
    ;;
  *)
    args+=("$1")
    ;;
  esac
  shift
done

exec /usr/bin/timeout --signal=SIGUSR2 --kill-after=10s "$RUNNERS_TIMEOUT" "${args[@]}"
