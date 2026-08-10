#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "                DIVE"
    echo "======================================"
    echo
    echo "1. Analizar imagen"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        printf "Nombre de la imagen a analizar (ej: docker-toolbox:latest): "
        read IMAGEN

        if [ -z "$IMAGEN" ]; then
            echo
            echo "Debes indicar una imagen."
            continue
        fi

        echo
        printf "Tiempo maximo en minutos [5]: "
        read MINUTES

        if [ -z "$MINUTES" ]; then
            MINUTES=5
        fi

        TIMEOUT=$((MINUTES * 60))

        echo
        echo "Imagen Docker de Dive (la herramienta, no la que analizas):"
        echo "1. Conservar"
        echo "2. Eliminar"
        printf "Selecciona: "
        read IMAGE_OPTION

        if [ "$IMAGE_OPTION" = "2" ]; then
            KEEP_IMAGE="no"
        else
            KEEP_IMAGE="yes"
        fi

        IMAGEN="$IMAGEN" \
        /engine/run-tool.sh \
            dive \
            "$TIMEOUT" \
            /tools/Dockerfile/dive/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "wagoodman/dive:latest" \
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