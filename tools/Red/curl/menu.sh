#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "               CURL"
    echo "======================================"
    echo
    echo "1. Verificar URL"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        printf "URL (ej: https://ejemplo.com): "
        read URL

        if [ -z "$URL" ]; then
            echo
            echo "Debes indicar una URL."
            continue
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

        URL="$URL" \
        /engine/run-tool.sh \
            curl \
            60 \
            /tools/Red/curl/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "curlimages/curl:latest" \
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