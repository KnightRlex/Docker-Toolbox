#!/bin/sh

set -e

echo
echo "======================================"
echo "              TFLINT"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-tflint \
  -v /work:/data:ro \
  ghcr.io/terraform-linters/tflint:latest