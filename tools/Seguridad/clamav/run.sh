#!/bin/sh

set -e

echo
echo "======================================"
echo "              CLAMAV"
echo "======================================"
echo
echo "Actualizando firmas (usa cache si existe) y analizando: /work"
echo

docker run --rm \
  --name toolbox-clamav \
  --entrypoint sh \
  -v /work:/scandir:ro \
  -v /cache/clamav:/var/lib/clamav \
  clamav/clamav:latest \
  -c "freshclam --quiet || true; clamscan -r /scandir"