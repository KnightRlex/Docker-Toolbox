#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "             OPENTOFU"
    echo "======================================"
    echo
    echo "1. Validar configuracion"
    echo "2. Limpiar cache"
    echo "3. Volver"
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
        echo "Caché de OpenTofu (providers):"
        echo "1. Conservar"
        echo "2. Eliminar"
        printf "Selecciona: "
        read CACHE_OPTION

        if [ "$CACHE_OPTION" = "2" ]; then
            KEEP_CACHE="no"
        else
            KEEP_CACHE="yes"
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

        /engine/run-tool.sh \
            opentofu \
            "$TIMEOUT" \
            /tools/IaC/opentofu/run.sh \
            "$KEEP_CACHE" \
            "$KEEP_IMAGE" \
            "ghcr.io/opentofu/opentofu:latest" \
            /tools/IaC/opentofu/clean.sh \
            || true

        ;;

    2)

        /tools/IaC/opentofu/clean.sh || true

        ;;

    3)
        break
        ;;

    *)
        echo
        echo "Opcion no valida."
        ;;

    esac

done