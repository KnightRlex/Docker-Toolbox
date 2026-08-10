#!/bin/sh

set -e

echo
echo "======================================"
echo "            TRUFFLEHOG"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-trufflehog \
  -v /work:/pwd:ro \
  trufflesecurity/trufflehog:latest \
  filesystem /pwd