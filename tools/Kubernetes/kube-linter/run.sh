#!/bin/sh

set -e

echo
echo "======================================"
echo "            KUBE-LINTER"
echo "======================================"
echo

if [ -n "$CARPETA" ]; then
    TARGET="/work/$CARPETA"
else
    TARGET="/work"
fi

if [ ! -d "$TARGET" ]; then
    echo "La carpeta $TARGET no existe."
    exit 1
fi

echo "Analizando: $TARGET"
echo

docker run --rm \
  --name toolbox-kube-linter \
  -v "$TARGET:/data:ro" \
  stackrox/kube-linter:latest \
  lint /data