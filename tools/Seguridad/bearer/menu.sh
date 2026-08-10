#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "              BEARER"
    echo "======================================"
    echo
    echo "1. Analizar datos sensibles"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        echo
        printf "Tiempo maximo en minutos [5]: "
        read MINUTES

        if [ -z "$MINUTES" ]; then
            MINUTES=5
        fi

        TIMEOUT=$((MINUTES * 60))

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

        /engine/run-tool.sh \
            bearer \
            "$TIMEOUT" \
            /tools/Seguridad/bearer/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "bearer/bearer:latest-amd64" \
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