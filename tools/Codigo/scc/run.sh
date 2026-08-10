#!/bin/sh

set -e

echo
echo "======================================"
echo "                SCC"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-scc \
  -v /work:/work:ro \
  --entrypoint scc \
  ghcr.io/boyter/scc:latest \
  /work