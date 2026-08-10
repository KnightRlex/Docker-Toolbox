#!/bin/sh

set -e

echo
echo "======================================"
echo "            MARKDOWNLINT"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-markdownlint \
  -v /work:/md:ro \
  peterdavehello/markdownlint:latest \
  markdownlint .