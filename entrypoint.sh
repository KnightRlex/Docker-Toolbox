#!/bin/sh

set -e

echo "======================================"
echo "        DOCKER TOOLBOX"
echo "======================================"
echo

echo "Iniciando Docker interno..."

dockerd-entrypoint.sh &
DOCKERD_PID=$!

echo "Esperando Docker..."

until docker info >/dev/null 2>&1
do
    sleep 1
done

echo
echo "Docker interno funcionando."
echo

while true
do

    echo
    echo "======================================"
    echo "          DOCKER TOOLBOX"
    echo "======================================"
    echo

    set --
    for dir in /tools/*/; do
        [ -d "$dir" ] || continue
        cat=$(basename "$dir")
        set -- "$@" "$cat"
    done

    i=1
    for cat in "$@"; do
        echo "$i. $cat"
        i=$((i + 1))
    done

    echo
    echo "C. Gestionar cache"
    echo
    echo "S. Salir"
    echo

    printf "Selecciona una opcion: "
    read OPTION

    case "$OPTION" in

    c|C)
        /ui/cache/menu.sh || true
        ;;

    s|S)
        echo
        echo "Saliendo de Docker Toolbox..."
        break
        ;;

    *[!0-9]*|'')
        echo
        echo "Opcion no valida."
        ;;

    *)
        if [ "$#" -gt 0 ] && [ "$OPTION" -ge 1 ] && [ "$OPTION" -le "$#" ]; then
            eval "CATEGORY=\${$OPTION}"
            /ui/category-menu.sh "$CATEGORY" || true
        else
            echo
            echo "Opcion no valida."
        fi
        ;;

    esac

done

kill "$DOCKERD_PID" 2>/dev/null || true