#!/bin/sh

set -e

echo
echo "======================================"
echo "             HADOLINT"
echo "======================================"
echo

DOCKERFILE=""

for f in /work/Dockerfile /work/dockerfile /work/DOCKERFILE; do
    if [ -f "$f" ]; then
        DOCKERFILE="$f"
        break
    fi
done

if [ -z "$DOCKERFILE" ]; then
    echo "No se encontro Dockerfile en /work"
    echo "(se probaron: Dockerfile, dockerfile, DOCKERFILE)"
    exit 1
fi

echo "Analizando: $DOCKERFILE"
echo

docker run --rm -i \
  --name toolbox-hadolint \
  hadolint/hadolint < "$DOCKERFILE"