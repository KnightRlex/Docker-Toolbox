#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "            KUBE-LINTER"
    echo "======================================"
    echo
    echo "1. Analizar manifiestos"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        printf "Carpeta con manifiestos (vacio = todo el proyecto): "
        read CARPETA

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

        CARPETA="$CARPETA" \
        /engine/run-tool.sh \
            kube-linter \
            "$TIMEOUT" \
            /tools/Kubernetes/kube-linter/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "stackrox/kube-linter:latest" \
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