#!/bin/sh

set -e

echo
echo "======================================"
echo "             OPENTOFU"
echo "======================================"
echo
echo "Validando: /work"
echo "(se copia a una carpeta temporal dentro del contenedor;"
echo " tu proyecto montado nunca se modifica)"
echo

docker run --rm \
  --name toolbox-opentofu \
  --entrypoint sh \
  -v /work:/work:ro \
  -v /cache/opentofu:/tf-plugin-cache \
  -e TF_PLUGIN_CACHE_DIR=/tf-plugin-cache \
  ghcr.io/opentofu/opentofu:latest \
  -c "cp -r /work /tmp/work && cd /tmp/work && tofu init -backend=false -input=false && tofu validate"