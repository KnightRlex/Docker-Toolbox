#!/bin/sh

set -e

GRUPO_DIR="$1"
TIMEOUT_SECONDS="$2"
KEEP_CACHE="$3"
KEEP_IMAGE="$4"

GRUPO_NOMBRE=$(basename "$GRUPO_DIR")
TOOLS_FILE="$GRUPO_DIR/tools.txt"

if [ ! -f "$TOOLS_FILE" ]; then
    echo "No se encontro tools.txt en $GRUPO_DIR"
    exit 1
fi

mkdir -p /report

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="/report/${GRUPO_NOMBRE}_${TIMESTAMP}.md"

{
    echo "# Auditoria: $GRUPO_NOMBRE"
    echo
    echo "Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
} > "$REPORT_FILE"

while IFS='|' read -r NOMBRE RUTA_RUN IMAGEN RUTA_CLEAN || [ -n "$NOMBRE" ]; do

    [ -z "$NOMBRE" ] && continue

    {
        echo
        echo "## $NOMBRE"
        echo
        echo '```'
    } >> "$REPORT_FILE"

    /engine/run-tool.sh \
        "$NOMBRE" \
        "$TIMEOUT_SECONDS" \
        "$RUTA_RUN" \
        "$KEEP_CACHE" \
        "$KEEP_IMAGE" \
        "$IMAGEN" \
        "$RUTA_CLEAN" \
        2>&1 | tee -a "$REPORT_FILE" || true

    echo '```' >> "$REPORT_FILE"

done < "$TOOLS_FILE"

echo
echo "======================================"
echo "  REPORTE GUARDADO"
echo "======================================"
echo
echo "$REPORT_FILE"