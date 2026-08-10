#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "         ESPACIO EN DISCO"
    echo "======================================"
    echo
    echo "1. Ver que ocupa espacio en el proyecto"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)
        /engine/run-tool.sh \
            espacio-disco \
            60 \
            /tools/Utilidades/espacio-disco/run.sh \
            yes \
            yes \
            "" \
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