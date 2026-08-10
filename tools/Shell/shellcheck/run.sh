#!/bin/sh

set -e

echo
echo "======================================"
echo "            SHELLCHECK"
echo "======================================"
echo

FILES=$(find /work -name "*.sh" 2>/dev/null)

if [ -z "$FILES" ]; then
    echo "No se encontraron archivos .sh en /work"
    exit 0
fi

ARGS=""
for f in $FILES; do
    REL=${f#/work/}
    ARGS="$ARGS /mnt/$REL"
done

echo "Analizando scripts .sh en /work"
echo

docker run --rm \
  --name toolbox-shellcheck \
  -v /work:/mnt:ro \
  koalaman/shellcheck:stable $ARGS