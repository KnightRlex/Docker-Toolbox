#!/bin/sh

set -e

echo
echo "======================================"
echo "             TERRAFORM"
echo "======================================"
echo
echo "Validando: /work"
echo "(se copia a una carpeta temporal dentro del contenedor;"
echo " tu proyecto montado nunca se modifica)"
echo

docker run --rm \
  --name toolbox-terraform \
  --entrypoint sh \
  -v /work:/work:ro \
  -v /cache/terraform:/tf-plugin-cache \
  -e TF_PLUGIN_CACHE_DIR=/tf-plugin-cache \
  hashicorp/terraform:latest \
  -c "cp -r /work /tmp/work && cd /tmp/work && terraform init -backend=false -input=false && terraform validate"