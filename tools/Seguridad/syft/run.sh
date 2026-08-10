#!/bin/sh

set -e

echo
echo "======================================"
echo "               SYFT"
echo "======================================"
echo
echo "Generando SBOM de: /work"
echo

docker run --rm \
  --name toolbox-syft \
  -v /work:/work:ro \
  anchore/syft:latest \
  dir:/work