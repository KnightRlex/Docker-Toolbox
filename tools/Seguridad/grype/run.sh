#!/bin/sh

set -e

echo
echo "======================================"
echo "               GRYPE"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-grype \
  --user 0 \
  -v /work:/work:ro \
  -v /cache/grype:/root/.cache/grype \
  anchore/grype:latest \
  dir:/work