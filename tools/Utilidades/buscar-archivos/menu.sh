#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "         BUSCAR ARCHIVOS"
    echo "======================================"
    echo
    echo "1. Buscar por nombre/extension"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        printf "Patron de nombre (ej: *.json, usa el asterisco): "
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
            buscar-archivos \
            60 \
            /tools/Utilidades/buscar-archivos/run.sh \
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