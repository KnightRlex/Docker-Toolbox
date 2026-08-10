#!/bin/sh

set -e

while true
do

    echo
    echo "======================================"
    echo "       GESTION GLOBAL DE CACHE"
    echo "======================================"
    echo

    set --
    for clean in /tools/*/*/clean.sh; do
        [ -f "$clean" ] || continue
        tool=$(basename "$(dirname "$clean")")
        set -- "$@" "$tool"
    done

    if [ "$#" -eq 0 ]; then
        echo "No hay herramientas con cache registrada."
    else
        i=1
        for tool in "$@"; do
            if [ -d "/cache/$tool" ]; then
                SIZE=$(du -sh "/cache/$tool" 2>/dev/null | cut -f1)
            else
                SIZE="0B"
            fi
            echo "$i. $tool ($SIZE)"
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

        eval "TOOL=\${$OPTION}"

        while true
        do
            echo
            echo "======================================"
            echo "         CACHE: $TOOL"
            echo "======================================"
            echo

            if [ -d "/cache/$TOOL" ]; then
                SIZE=$(du -sh "/cache/$TOOL" 2>/dev/null | cut -f1)
            else
                SIZE="0B"
            fi

            echo "Tamaño actual: $SIZE"
            echo
            echo "1. Limpiar cache"
            echo "V. Volver"
            echo

            printf "Selecciona una opcion: "
            read SUB_OPTION

            case "$SUB_OPTION" in

            1)
                for clean in /tools/*/"$TOOL"/clean.sh; do
                    [ -f "$clean" ] && "$clean" || true
                done
                ;;

            v|V)
                break
                ;;

            *)
                echo
                echo "Opcion no valida."
                ;;

            esac

        done
        ;;

    esac

done