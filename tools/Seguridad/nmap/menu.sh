#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "               NMAP"
    echo "======================================"
    echo
    echo "1. Escanear host"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        echo
        echo "Escaneo activo: usalo solo contra equipos que controlas"
        echo "o tienes autorizacion explicita para probar."
        echo

        printf "Host o IP a escanear: "
        read HOST

        if [ -z "$HOST" ]; then
            echo
            echo "Debes indicar un host."
            continue
        fi

        printf "Puertos (ej: 1-1000, 22,80,443, vacio = puertos comunes): "
        read PUERTOS

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

        HOST="$HOST" PUERTOS="$PUERTOS" \
        /engine/run-tool.sh \
            nmap \
            "$TIMEOUT" \
            /tools/Seguridad/nmap/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "instrumentisto/nmap:latest" \
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