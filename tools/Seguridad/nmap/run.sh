#!/bin/sh

set -e

echo
echo "======================================"
echo "               NMAP"
echo "======================================"
echo
echo "Host: $HOST"

if [ -n "$PUERTOS" ]; then
    echo "Puertos: $PUERTOS"
    echo
    docker run --rm \
      --name toolbox-nmap \
      instrumentisto/nmap:latest \
      -T4 -p "$PUERTOS" "$HOST"
else
    echo "Puertos: comunes (por defecto de nmap)"
    echo
    docker run --rm \
      --name toolbox-nmap \
      instrumentisto/nmap:latest \
      -T4 "$HOST"
fi