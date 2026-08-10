#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "     PUERTOS DECLARADOS (CODIGO)"
    echo "======================================"
    echo
    echo "1. Buscar en el codigo"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)
        /engine/run-tool.sh \
            puertos-declarados \
            60 \
            /tools/Seguridad/puertos-declarados/run.sh \
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