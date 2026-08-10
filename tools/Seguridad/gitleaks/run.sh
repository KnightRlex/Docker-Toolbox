#!/bin/sh

set -e

echo
echo "======================================"
echo "             GITLEAKS"
echo "======================================"
echo
echo "Analizando: /work"
echo

docker run --rm \
  --name toolbox-gitleaks \
  -v /work:/work:ro \
  zricethezav/gitleaks:latest \
  detect --source /work --no-git --redact -v