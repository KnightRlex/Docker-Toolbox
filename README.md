# Docker Toolbox

Herramientas de análisis (seguridad, linting, etc.) ejecutadas de forma aislada vía Docker-in-Docker. No requiere instalar nada en Windows salvo Docker Desktop.


## Requisitos


- Docker Desktop


## Build

docker build -t docker-toolbox .


## Ejecutar (comando recomendado — cache persistente en tu proyecto)


docker run --rm -it --privileged -v "RUTA\_DE\_TU\_PROYECTO:/work:ro" -v ".\\cache\\trivy:/cache/trivy" -v docker-toolbox-images:/var/lib/docker docker-toolbox


Reemplaza `RUTA\_DE\_TU\_PROYECTO` por la ruta absoluta del proyecto que quieres

analizar (ej. `C:\\Users\\tu-usuario\\mi-proyecto`).

Ejemplo para Tirvy con cache guardado en raiz/cache/trivy:

docker run --rm -it --privileged --name docker-toolbox -v "D:\ruta:/work:ro" -v ".\cache\trivy:/cache/trivy" -v docker-toolbox-images:/var/lib/docker docker-toolbox

Para verificar si elimino o conservo imagenes solo se ejecuta:

docker exec docker-toolbox docker images

### Qué hace cada flag


| Flag | Para qué sirve |

|---|---|

| `--rm` | Borra el contenedor de Docker Toolbox al salir (no el cache, no las imágenes descargadas — esas viven en `docker-toolbox-images`) |

| `-it` | Modo interactivo, necesario para el menú |

| `--privileged` | Requerido por Docker-in-Docker (dind) |

| `-v "RUTA:/work:ro"` | Monta tu proyecto de solo lectura. Ninguna herramienta puede escribir/modificar tu código |

| `-v ".\\cache\\<tool>:/cache/<tool>"` | Uno por cada herramienta que tenga cache/DB propia. Sin este flag, el cache de esa herramienta se pierde al cerrar el contenedor (ver sección de abajo) |

| `-v docker-toolbox-images:/var/lib/docker` | Volumen con nombre donde vive el motor Docker interno: aquí se guardan las imágenes descargadas (trivy, hadolint, etc.) para no re-descargarlas cada vez |


### ⚠️ Si NO agregas el `-v` de cache de una herramienta


El cache de esa herramienta se escribe igual dentro del contenedor

(`/cache/<tool>`), pero como no está conectado a ninguna carpeta de Windows,

vive únicamente en la capa temporal del propio contenedor de Docker Toolbox.

Al usar `--rm`, esa capa se destruye al salir — el cache desaparece por

completo y la próxima vez se vuelve a descargar/generar desde cero. No se

guarda "en la imagen" en sentido estricto (las imágenes de Docker son

inmutables), pero el efecto práctico es el mismo: se pierde.


### Flags de cache por herramienta (agregar una línea `-v` por cada una)


| Herramienta | Flag |

|---|---|

| Trivy | `-v ".\\cache\\trivy:/cache/trivy"` |

| Grype | -v ".\cache\grype:/cache/grype" |

| ClamAV | -v ".\cache\clamav:/cache/clamav" |

| Terraform | -v ".\cache\terraform:/cache/terraform" |

| OpenTofu | -v ".\cache\opentofu:/cache/opentofu" |


## Otras formas de ejecutarlo (catálogo completo)


### Sin cache persistente (todo efímero, nada se guarda ni en tu proyecto ni en imágenes)


Útil para una prueba rápida y aislada, sin dejar rastro:


docker run --rm -it --privileged -v "RUTA\_DE\_TU\_PROYECTO:/work:ro" docker-toolbox


### Sin `--rm` (el contenedor se conserva después de salir, útil para depurar)


docker run -it --privileged --name toolbox -v "RUTA\_DE\_TU\_PROYECTO:/work:ro" -v ".\\cache\\trivy:/cache/trivy" -v docker-toolbox-images:/var/lib/docker docker-toolbox


Para volver a entrar al mismo contenedor después:


docker start -ai toolbox


Para borrarlo cuando ya no lo necesites:


docker rm -f toolbox

## Leer las notas en las herraminetas que contengan para obtener mas informacióon

### Grype aun no funciona
