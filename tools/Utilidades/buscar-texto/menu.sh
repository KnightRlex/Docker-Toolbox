#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "           BUSCAR TEXTO"
    echo "======================================"
    echo
    echo "1. Buscar patron en el proyecto"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        printf "Patron a buscar (ej: TODO|FIXME): "
        read PATRON

        if [ -z "$PATRON" ]; then
            echo
            echo "Debes indicar un patron."
            continue
        fi

        printf "Carpeta dentro del proyecto (vacio = todo el proyecto): "
        read CARPETA

        PATRON="$PATRON" CARPETA="$CARPETA" \
        /engine/run-tool.sh \
            buscar-texto \
            60 \
            /tools/Utilidades/buscar-texto/run.sh \
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