#!/bin/sh

set -e

echo
echo "======================================"
echo "                JQ"
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
  --name toolbox-jq \
  -v /work:/work:ro \
  ghcr.io/jqlang/jq:latest \
  "$EXPR" "/work/$FILE"