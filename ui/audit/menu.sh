#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "              AUDITORIA"
    echo "======================================"
    echo

    set --
    for info in /ui/audit/grupos/*/info.txt; do
        [ -f "$info" ] || continue
        grupo=$(basename "$(dirname "$info")")
        set -- "$@" "$grupo"
    done

    if [ "$#" -eq 0 ]; then
        echo "No hay grupos de auditoria configurados."
    else
        i=1
        for grupo in "$@"; do
            TITULO=$(head -n 1 "/ui/audit/grupos/$grupo/info.txt")
            echo "$i. $TITULO"
            i=$((i + 1))
        done
    fi

    echo
    echo "V. Volver"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    v|V)
        break
        ;;

    *)
        case "$OPTION" in
            ''|*[!0-9]*)
                echo
                echo "Opcion no valida."
                continue
                ;;
        esac

        if [ "$#" -eq 0 ] || [ "$OPTION" -lt 1 ] || [ "$OPTION" -gt "$#" ]; then
            echo
            echo "Opcion no valida."
            continue
        fi

        eval "GRUPO=\${$OPTION}"

        echo
        echo "======================================"
        cat "/ui/audit/grupos/$GRUPO/info.txt"
        echo
        echo "Herramientas que ejecuta:"
        cut -d'|' -f1 "/ui/audit/grupos/$GRUPO/tools.txt"
        echo "======================================"
        echo
        printf "Ejecutar esta auditoria? (s/N): "
        read CONFIRM

        case "$CONFIRM" in
        s|S) ;;
        *) continue ;;
        esac

        echo
        printf "Tiempo maximo por herramienta en minutos [5]: "
        read MINUTES

        if [ -z "$MINUTES" ]; then
            MINUTES=5
        fi

        TIMEOUT=$((MINUTES * 60))

        echo
        echo "Cache (aplica a todas las herramientas que usan cache):"
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
        echo "Imagen Docker (aplica a todas):"
        echo "1. Conservar"
        echo "2. Eliminar"
        printf "Selecciona: "
        read IMAGE_OPTION

        if [ "$IMAGE_OPTION" = "2" ]; then
            KEEP_IMAGE="no"
        else
            KEEP_IMAGE="yes"
        fi

        /ui/audit/run-grupo.sh \
            "/ui/audit/grupos/$GRUPO" \
            "$TIMEOUT" \
            "$KEEP_CACHE" \
            "$KEEP_IMAGE" \
            || true

        ;;

    esac

done