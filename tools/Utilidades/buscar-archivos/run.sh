#!/bin/sh

set -e

echo
echo "======================================"
echo "         BUSCAR ARCHIVOS"
echo "======================================"
echo

if [ -n "$CARPETA" ]; then
    TARGET="/work/$CARPETA"
else
    TARGET="/work"
fi

if [ ! -d "$TARGET" ]; then
    echo "La carpeta $TARGET no existe."
    exit 1
fi

echo "Patron: $PATRON"
echo "Carpeta: $TARGET"
echo "(excluye node_modules, .git, target, dist, build, .next, out, __pycache__, .venv, vendor)"
echo

RESULT=$(find "$TARGET" \
  \( -name node_modules -o -name .git -o -name target -o -name dist \
     -o -name build -o -name .next -o -name out -o -name __pycache__ \
     -o -name .venv -o -name vendor \) -prune \
  -o -iname "$PATRON" -print 2>/dev/null)

if [ -z "$RESULT" ]; then
    echo "Sin coincidencias."
else
    echo "$RESULT"
fi