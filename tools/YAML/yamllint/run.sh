#!/bin/sh

set -e

echo
echo "======================================"
echo "             YAMLLINT"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-yamllint \
  -v /work:/data:ro \
  cytopia/yamllint:latest \
  .