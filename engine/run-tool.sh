#!/bin/sh

set -e

TOOL_NAME="$1"
TIMEOUT_SECONDS="$2"
TOOL_SCRIPT="$3"
KEEP_CACHE="${4:-yes}"
KEEP_IMAGE="${5:-yes}"
IMAGE_NAME="$6"
CLEAN_SCRIPT="$7"

if [ -z "$TOOL_NAME" ] || [ -z "$TIMEOUT_SECONDS" ] || [ -z "$TOOL_SCRIPT" ]; then
    echo
    echo "Uso:"
    echo "run-tool.sh TOOL_NAME TIMEOUT_SECONDS TOOL_SCRIPT KEEP_CACHE KEEP_IMAGE IMAGE_NAME CLEAN_SCRIPT"
    exit 1
fi

echo
echo "======================================"
echo "       EJECUTANDO HERRAMIENTA"
echo "======================================"
echo
echo "Herramienta : $TOOL_NAME"
echo "Timeout     : ${TIMEOUT_SECONDS}s"
echo

cleanup() {

    echo
    echo "======================================"
    echo "          LIMPIEZA FINAL"
    echo "======================================"
    echo

    echo "Limpiando contenedores de $TOOL_NAME..."

    docker rm -f "toolbox-$TOOL_NAME" 2>/dev/null || true
    docker rm -f "toolbox-$TOOL_NAME-update" 2>/dev/null || true
    docker rm -f "toolbox-$TOOL_NAME-clean" 2>/dev/null || true

    # --------------------------------------
    # 1. CACHE
    # --------------------------------------

    if [ "$KEEP_CACHE" = "no" ] && [ -n "$CLEAN_SCRIPT" ]; then

        echo
        echo "Eliminando caché de $TOOL_NAME..."

        "$CLEAN_SCRIPT"

    else

        echo
        echo "Caché de $TOOL_NAME: conservar"

    fi

    # --------------------------------------
    # 2. IMAGEN
    # --------------------------------------

    if [ "$KEEP_IMAGE" = "no" ] && [ -n "$IMAGE_NAME" ]; then

        echo
        echo "Eliminando imagen:"
        echo "$IMAGE_NAME"

        i=0
        REMOVED="no"
        while [ "$i" -lt 3 ]; do
            if docker image rm -f "$IMAGE_NAME" >/tmp/rmimg.log 2>&1; then
                REMOVED="yes"
                break
            fi
            i=$((i + 1))
            sleep 1
        done

        if [ "$REMOVED" = "yes" ] || ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
            echo "Imagen eliminada correctamente."
        else
            echo "AVISO: no se pudo eliminar la imagen. Detalle:"
            cat /tmp/rmimg.log 2>/dev/null || true
        fi

    else

        echo
        echo "Imagen Docker: conservar"

    fi
}

trap cleanup EXIT INT TERM

set +e

timeout "$TIMEOUT_SECONDS" "$TOOL_SCRIPT"

EXIT_CODE=$?

set -e

if [ "$EXIT_CODE" -eq 124 ]; then

    echo
    echo "======================================"
    echo "              TIMEOUT"
    echo "======================================"
    echo
    echo "La herramienta superó el tiempo límite."
    echo "Tiempo permitido: ${TIMEOUT_SECONDS} segundos."
    echo

    exit 124
fi

exit "$EXIT_CODE"