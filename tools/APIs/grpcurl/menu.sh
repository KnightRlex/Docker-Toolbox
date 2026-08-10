#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "              GRPCURL"
    echo "======================================"
    echo
    echo "1. Listar servicios gRPC"
    echo "2. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    1)

        printf "Host:puerto (ej: localhost:50051): "
        read TARGET

        if [ -z "$TARGET" ]; then
            echo
            echo "Debes indicar host:puerto."
            continue
        fi

        echo
        echo "Conexion:"
        echo "1. Plaintext (sin TLS)"
        echo "2. TLS"
        printf "Selecciona: "
        read TLS_OPTION

        if [ "$TLS_OPTION" = "1" ]; then
            PLAINTEXT="yes"
        else
            PLAINTEXT="no"
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

        TARGET="$TARGET" PLAINTEXT="$PLAINTEXT" \
        /engine/run-tool.sh \
            grpcurl \
            60 \
            /tools/APIs/grpcurl/run.sh \
            yes \
            "$KEEP_IMAGE" \
            "fullstorydev/grpcurl:latest" \
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