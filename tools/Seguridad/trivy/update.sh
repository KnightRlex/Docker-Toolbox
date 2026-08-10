#!/bin/sh

set -e

echo
echo "======================================"
echo "        ACTUALIZANDO TRIVY DB"
echo "======================================"
echo

docker run --rm \
  --name toolbox-trivy-update \
  -v /cache/trivy:/root/.cache/trivy \
  aquasec/trivy:latest \
  image --download-db-only

echo
echo "DB de Trivy actualizada."