#!/bin/sh

set -e

echo
echo "======================================"
echo "                YQ"
echo "======================================"
echo

if [ ! -f "/work/$FILE" ]; then
    echo "No se encontro /work/$FILE"
    exit 1
fi

echo "Archivo    : $FILE"
echo "Expresion  : $EXPR"
echo

docker run --rm \
  --name toolbox-yq \
  -v /work:/workdir:ro \
  mikefarah/yq:latest \
  eval "$EXPR" "/workdir/$FILE"