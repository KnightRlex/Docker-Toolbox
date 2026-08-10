#!/bin/sh

set -e

echo
echo "======================================"
echo "       LIMPIAR CACHE TERRAFORM"
echo "======================================"
echo

if [ -d "/cache/terraform" ]; then
    echo "Eliminando contenido de la cache..."

    rm -rf /cache/terraform/*
    rm -rf /cache/terraform/.[!.]*
    rm -rf /cache/terraform/..?*
fi

echo
echo "Cache de Terraform eliminada."