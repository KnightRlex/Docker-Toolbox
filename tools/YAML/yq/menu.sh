#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "                YQ"
    echo "======================================"
    echo
    echo "1. Consultar archivo YAML"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        echo
        printf "Archivo dentro de tu proyecto (ej: docker-compose.yml): "
        read FILE

        if [ -z "$FILE" ]; then
            echo
            echo "Debes indicar un archivo."
            continue
        fi

        printf "Expresion yq (ej: .services): "
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
            yq \
            60 \
            /tools/YAML/yq/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "mikefarah/yq:latest" \
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