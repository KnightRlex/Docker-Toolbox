#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "                JQ"
    echo "======================================"
    echo
    echo "1. Consultar archivo JSON"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        echo
        printf "Archivo dentro de tu proyecto (ej: package.json): "
        read FILE

        if [ -z "$FILE" ]; then
            echo
            echo "Debes indicar un archivo."
            continue
        fi

        printf "Expresion jq (ej: .dependencies): "
        read EXPR

        if [ -z "$EXPR" ]; then
            EXPR="."
        fi

        echo
        echo "Imagen Docker:"
        echo "1. Conservar"
        echo "2. Eliminar"
        printf "Selecciona: "
        read IMAGE_OPTION

        if [ "$IMAGE_OPTION" = "2" ]; then
            KEEP_IMAGE="no"
        else
            KEEP_IMAGE="yes"
        fi

        FILE="$FILE" EXPR="$EXPR" \
        /engine/run-tool.sh \
            jq \
            60 \
            /tools/Utilidades/jq/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "ghcr.io/jqlang/jq:latest" \
            "" \
            || true

        ;;

    2)
        break
        ;;

    *)
        echo
        echo "Opcion no valida."
        ;;

    esac

done