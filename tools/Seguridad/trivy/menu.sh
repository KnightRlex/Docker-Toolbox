#!/bin/sh

set -e

while true
do

echo
echo "======================================"
echo "               TRIVY"
echo "======================================"
echo
echo "1. Analizar proyecto"
echo "2. Actualizar DB"
echo "3. Limpiar cache"
echo "4. Volver"
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
    echo "Caché de Trivy:"
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

    echo
    echo "======================================"
    echo "           CONFIGURACION"
    echo "======================================"
    echo
    echo "Tiempo máximo : ${MINUTES} minutos"

    if [ "$KEEP_CACHE" = "yes" ]; then
        echo "Caché         : Conservar"
    else
        echo "Caché         : Eliminar"
    fi

    if [ "$KEEP_IMAGE" = "yes" ]; then
        echo "Imagen Docker  : Conservar"
    else
        echo "Imagen Docker  : Eliminar"
    fi

    echo

    /engine/run-tool.sh \
        trivy \
        "$TIMEOUT" \
        /tools/Seguridad/trivy/run.sh \
        "$KEEP_CACHE" \
        "$KEEP_IMAGE" \
        "aquasec/trivy:latest" \
        /tools/Seguridad/trivy/clean.sh \
        || true

    ;;

2)

    echo
    printf "Tiempo maximo en minutos [5]: "
    read MINUTES

    if [ -z "$MINUTES" ]; then
        MINUTES=5
    fi

    TIMEOUT=$((MINUTES * 60))

    /engine/run-tool.sh \
        trivy-update \
        "$TIMEOUT" \
        /tools/Seguridad/trivy/update.sh \
        yes \
        yes \
        "aquasec/trivy:latest" \
        "" \
        || true

    ;;

3)

    /tools/Seguridad/trivy/clean.sh || true

    ;;

4)

    break

    ;;

*)

    echo
    echo "Opcion no valida."

    ;;

esac

done