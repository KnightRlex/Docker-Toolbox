#!/bin/sh

set -e

echo
echo "======================================"
echo "        LIMPIAR CACHE CLAMAV"
echo "======================================"
echo

if [ -d "/cache/clamav" ]; then
    echo "Eliminando contenido de la cache..."

    rm -rf /cache/clamav/*
    rm -rf /cache/clamav/.[!.]*
    rm -rf /cache/clamav/..?*
fi

echo
echo "Cache de ClamAV eliminada."