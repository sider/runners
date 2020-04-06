#!/bin/bash
set -euo pipefail

# https://docs.bugsnag.com/build-integrations
json_fmt='
{
  "apiKey": "%s",
  "appVersion": "%s",
  "releaseStage": "production",
  "builderName": "GitHub Actions",
  "sourceControl": {
    "provider": "github",
    "repository": "https://github.com/sider/runners",
    "revision": "%s"
}'
json=$(printf "$json_fmt" "$BUGSNAG_API_KEY" "$APP_VERSION" "$SOURCE_REVISION")
curl https://build.bugsnag.com/ --header 'Content-Type: application/json' --data "$json"
