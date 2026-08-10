#!/bin/sh

set -e

echo
echo "======================================"
echo "            KUBECONFORM"
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

echo "Validando: $TARGET"
echo

docker run --rm \
  --name toolbox-kubeconform \
  -v "$TARGET:/manifests:ro" \
  ghcr.io/yannh/kubeconform:latest \
  -summary -ignore-missing-schemas /manifests