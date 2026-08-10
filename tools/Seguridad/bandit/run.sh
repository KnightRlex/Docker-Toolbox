#!/bin/sh

set -e

echo
echo "======================================"
echo "               BANDIT"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-bandit \
  -v /work:/data:ro \
  cytopia/bandit:latest \
  -r /data