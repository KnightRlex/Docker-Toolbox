#!/bin/sh

set -e

echo
echo "======================================"
echo "       LIMPIAR CACHE OPENTOFU"
echo "======================================"
echo

if [ -d "/cache/opentofu" ]; then
    echo "Eliminando contenido de la cache..."

    rm -rf /cache/opentofu/*
    rm -rf /cache/opentofu/.[!.]*
    rm -rf /cache/opentofu/..?*
fi

echo
echo "Cache de OpenTofu eliminada."