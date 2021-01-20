#!/bin/bash

set -eo pipefail

if [[ -n "$EXTRA_CERTIFICATE" ]]; then
  echo "Run update-ca-certificates(8) to add the specified certificate" >&2
  echo "$EXTRA_CERTIFICATE" | base64 --decode > /usr/local/share/ca-certificates/extra-cert.crt
  sudo update-ca-certificates
  unset EXTRA_CERTIFICATE
fi

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

export RUNNERS_TIMEOUT

exec /usr/bin/timeout --signal=SIGUSR2 --kill-after=10s "$RUNNERS_TIMEOUT" "${args[@]}"
