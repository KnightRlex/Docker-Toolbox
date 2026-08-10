#!/bin/sh

set -e

echo
echo "======================================"
echo "              SEMGREP"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-semgrep \
  -v /work:/src:ro \
  semgrep/semgrep:latest \
  semgrep --config=p/ci /src