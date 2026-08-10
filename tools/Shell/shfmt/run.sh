#!/bin/sh

set -e

echo
echo "======================================"
echo "               SHFMT"
echo "======================================"
echo
echo "Verificando formato en: /work"
echo

docker run --rm \
  --name toolbox-shfmt \
  -v /work:/work:ro \
  mvdan/shfmt:latest \
  -d /work