#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "                DIG"
    echo "======================================"
    echo
    echo "1. Consultar dominio"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        printf "Dominio a consultar (ej: ejemplo.com): "
        read DOMINIO

        if [ -z "$DOMINIO" ]; then
            echo
            echo "Debes indicar un dominio."
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

        DOMINIO="$DOMINIO" \
        /engine/run-tool.sh \
            dig \
            60 \
            /tools/Red/dig/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "splooge/dnsutils:latest" \
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