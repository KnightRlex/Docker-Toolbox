#!/bin/sh

set -e

echo
echo "======================================"
echo "          LIMPIAR CACHE TRIVY"
echo "======================================"
echo

if [ -d "/cache/trivy" ]; then
    echo "Eliminando contenido de la cache..."

    rm -rf /cache/trivy/*
    rm -rf /cache/trivy/.[!.]*
    rm -rf /cache/trivy/..?*
fi

echo
echo "Cache de Trivy eliminada."