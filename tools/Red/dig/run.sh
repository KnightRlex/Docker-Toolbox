#!/bin/sh

set -e

echo
echo "======================================"
echo "                DIG"
echo "======================================"
echo
echo "Dominio: $DOMINIO"
echo

docker run --rm \
  --name toolbox-dig \
  splooge/dnsutils:latest \
  dig "$DOMINIO"