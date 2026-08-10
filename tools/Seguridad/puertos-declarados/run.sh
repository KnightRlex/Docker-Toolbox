#!/bin/sh

set -e

echo
echo "======================================"
echo "     PUERTOS DECLARADOS (CODIGO)"
echo "======================================"
echo
echo "Buscando referencias a puertos en: /work"
echo "(excluye node_modules, .git, target, dist, build, .next, out, __pycache__, .venv, vendor)"
echo

FOUND=""

find /work \
  \( -name node_modules -o -name .git -o -name target -o -name dist \
     -o -name build -o -name .next -o -name out -o -name __pycache__ \
     -o -name .venv -o -name vendor \) -prune \
  -o -type f -print 2>/dev/null | while IFS= read -r f; do

    grep -nE \
      -e 'EXPOSE[[:space:]]+[0-9]+' \
      -e '[Pp][Oo][Rr][Tt][[:space:]]*[:=][[:space:]]*[0-9]{2,5}' \
      -e 'listen\([0-9]{2,5}' \
      -e '- ["'"'"']?[0-9]{2,5}:[0-9]{2,5}' \
      "$f" 2>/dev/null | sed "s|^|$f:|"

done > /tmp/puertos.log

if [ -s /tmp/puertos.log ]; then
    cat /tmp/puertos.log
else
    echo "No se encontraron referencias explicitas a puertos."
fi

echo
echo "Busqueda finalizada."