#!/bin/sh

set -e

echo
echo "======================================"
echo "                DIVE"
echo "======================================"
echo
echo "Analizando imagen: $IMAGEN"
echo "(la imagen debe existir ya en el motor Docker interno;"
echo " verifica el nombre exacto con: docker exec docker-toolbox docker images)"
echo

docker run --rm \
  --name toolbox-dive \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e CI=true \
  wagoodman/dive:latest \
  "$IMAGEN"