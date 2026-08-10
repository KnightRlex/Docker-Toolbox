#!/bin/sh

set -e

echo
echo "======================================"
echo "              BEARER"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-bearer \
  -v /work:/tmp/scan:ro \
  bearer/bearer:latest-amd64 \
  scan /tmp/scan