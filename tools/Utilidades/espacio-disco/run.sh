#!/bin/sh

set -e

echo
echo "======================================"
echo "         ESPACIO EN DISCO"
echo "======================================"
echo
echo "Carpetas mas pesadas dentro de /work:"
echo

du -sh /work/*/ 2>/dev/null | sort -rh | head -n 20