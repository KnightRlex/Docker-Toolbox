#!/bin/sh

set -e

echo
echo "======================================"
echo "              CHECKOV"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-checkov \
  -v /work:/work:ro \
  bridgecrew/checkov:latest \
  -d /work