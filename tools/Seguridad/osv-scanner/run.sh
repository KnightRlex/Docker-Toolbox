#!/bin/sh

set -e

echo
echo "======================================"
echo "            OSV-SCANNER"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-osv-scanner \
  -v /work:/src:ro \
  ghcr.io/google/osv-scanner:latest \
  -r /src