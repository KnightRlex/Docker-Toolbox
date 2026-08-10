#!/bin/sh

set -e

echo
echo "======================================"
echo "               CURL"
echo "======================================"
echo
echo "URL: $URL"
echo

docker run --rm \
  --name toolbox-curl \
  curlimages/curl:latest \
  -sS -I -L "$URL"