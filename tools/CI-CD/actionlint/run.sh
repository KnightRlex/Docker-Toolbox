#!/bin/sh

set -e

echo
echo "======================================"
echo "             ACTIONLINT"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-actionlint \
  -v /work:/repo:ro \
  --workdir /repo \
  rhysd/actionlint:latest \
  -color