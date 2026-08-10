#!/bin/sh

set -e

echo
echo "======================================"
echo "         LIMPIAR CACHE GRYPE"
echo "======================================"
echo

if [ -d "/cache/grype" ]; then
    echo "Eliminando contenido de la cache..."

    rm -rf /cache/grype/*
    rm -rf /cache/grype/.[!.]*
    rm -rf /cache/grype/..?*
fi

echo
echo "Cache de Grype eliminada."