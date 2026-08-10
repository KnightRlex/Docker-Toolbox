#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "               BANDIT"
    echo "======================================"
    echo
    echo "1. Analizar codigo Python"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        echo
        printf "Tiempo maximo en minutos [3]: "
        read MINUTES

        if [ -z "$MINUTES" ]; then
            MINUTES=3
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
            bandit \
            "$TIMEOUT" \
            /tools/Seguridad/bandit/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "cytopia/bandit:latest" \
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