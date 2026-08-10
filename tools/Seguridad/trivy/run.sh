#!/bin/sh

set -e

echo
echo "======================================"
echo "              TRIVY"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-trivy \
  -v /work:/work:ro \
  -v /cache/trivy:/root/.cache/trivy \
  aquasec/trivy:latest \
  fs /work