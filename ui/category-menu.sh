#!/bin/sh

set -e

CATEGORY="$1"

if [ -z "$CATEGORY" ] || [ ! -d "/tools/$CATEGORY" ]; then
    echo
    echo "Categoria no valida."
    exit 1
fi

while true
do

    echo
    echo "======================================"
    echo " $CATEGORY"
    echo "======================================"
    echo

    set --
    for menu in /tools/"$CATEGORY"/*/menu.sh; do
        [ -f "$menu" ] || continue
        tool=$(basename "$(dirname "$menu")")
        set -- "$@" "$tool"
    done

    if [ "$#" -eq 0 ]; then
        echo "Esta categoria aun no tiene herramientas."
    else
        i=1
        for tool in "$@"; do
            echo "$i. $tool"
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

    *[!0-9]*|'')
        echo
        echo "Opcion no valida."
        ;;

    *)
        if [ "$#" -gt 0 ] && [ "$OPTION" -ge 1 ] && [ "$OPTION" -le "$#" ]; then
            eval "TOOL=\${$OPTION}"
            /tools/"$CATEGORY"/"$TOOL"/menu.sh || true
        else
            echo
            echo "Opcion no valida."
        fi
        ;;

    esac

done