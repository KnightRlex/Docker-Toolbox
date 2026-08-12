# Docker Toolbox

Herramientas de análisis (seguridad, linting, IaC, Kubernetes, y más) ejecutadas
de forma aislada dentro de un motor Docker interno (Docker-in-Docker). No
requiere instalar nada en Windows/Linux/Mac salvo Docker Desktop — llévalo en
un USB, cópialo a otra PC, y funciona igual.

## Índice

- [Requisitos](#requisitos)
- [Build](#build)
- [Ejecutar](#ejecutar)
- [Solo lectura y la carpeta report](#solo-lectura-y-la-carpeta-report)
- [Catálogo de herramientas](#catálogo-de-herramientas)
- [Sistema de Auditoría](#sistema-de-auditoría)
- [Cómo agregar una herramienta nueva](#cómo-agregar-una-herramienta-nueva)
- [Cómo agregar una categoría nueva](#cómo-agregar-una-categoría-nueva)
- [Notas de mantenimiento](#notas-de-mantenimiento)

## Requisitos

- Docker Desktop (Windows, Mac o Linux)

## Build

```
docker build -t docker-toolbox .
```

Reconstruye siempre que agregues o modifiques cualquier archivo `.sh` — el
`Dockerfile` aplica automáticamente permisos de ejecución y corrige
terminaciones de línea a cualquier script nuevo bajo `tools/`, `ui/` o
`engine/`, sin que tengas que tocar el `Dockerfile` para eso.

## Ejecutar

Comando recomendado (persiste cache e imágenes entre ejecuciones, guarda
reportes de auditoría en tu proyecto):

```
docker run --rm -it --privileged --name docker-toolbox -v "RUTA_DE_TU_PROYECTO:/work:ro" -v ".\report:/work/report" -v ".\cache\trivy:/cache/trivy" -v ".\cache\grype:/cache/grype" -v ".\cache\clamav:/cache/clamav" -v ".\cache\terraform:/cache/terraform" -v ".\cache\opentofu:/cache/opentofu" -v docker-toolbox-images:/var/lib/docker docker-toolbox
```

Reemplaza `RUTA_DE_TU_PROYECTO` por la ruta absoluta del proyecto que quieres
analizar. Ejecuta el comando **desde dentro de la carpeta del proyecto** en
CMD, ya que las rutas `.\cache\...` y `.\report` son relativas a donde corres
el comando.

### Qué hace cada flag

| Flag | Para qué sirve |
|---|---|
| `--rm` | Borra el contenedor de Docker Toolbox al salir (no borra cache ni imágenes descargadas, esas viven aparte) |
| `-it` | Modo interactivo, necesario para el menú |
| `--privileged` | Requerido por Docker-in-Docker |
| `--name docker-toolbox` | Nombre fijo, para poder hacer `docker exec docker-toolbox ...` desde otra terminal sin buscar el ID |
| `-v "RUTA:/work:ro"` | Monta tu proyecto de solo lectura. Ninguna herramienta puede modificar tu código |
| `-v ".\report:/work/report"` | Única excepción de escritura — aquí se guardan los reportes de auditoría (ver sección dedicada abajo) |
| `-v ".\cache\<tool>:/cache/<tool>"` | Uno por cada herramienta con cache/DB propia. Sin este flag, esa herramienta re-descarga su base cada vez |
| `-v docker-toolbox-images:/var/lib/docker` | Volumen donde vive el motor Docker interno — aquí se guardan las imágenes descargadas (Trivy, Hadolint, etc.) para no re-descargarlas |

### Flags de cache por herramienta

| Herramienta | Flag |
|---|---|
| Trivy | `-v ".\cache\trivy:/cache/trivy"` |
| Grype | `-v ".\cache\grype:/cache/grype"` |
| ClamAV | `-v ".\cache\clamav:/cache/clamav"` |
| Terraform | `-v ".\cache\terraform:/cache/terraform"` |
| OpenTofu | `-v ".\cache\opentofu:/cache/opentofu"` |

Todas las demás herramientas no tienen cache propio — no necesitan flag.

### Otras formas de ejecutarlo

**Sin cache ni reportes persistentes (todo efímero, no deja rastro):**

```
docker run --rm -it --privileged -v "RUTA_DE_TU_PROYECTO:/work:ro" docker-toolbox
```

**Sin `--rm` (el contenedor se conserva, útil para depurar):**

```
docker run -it --privileged --name docker-toolbox -v "RUTA_DE_TU_PROYECTO:/work:ro" -v ".\report:/work/report" -v docker-toolbox-images:/var/lib/docker docker-toolbox
```

Para volver a entrar después: `docker start -ai docker-toolbox`
Para borrarlo cuando ya no lo necesites: `docker rm -f docker-toolbox`

## Ejecutar (comando recomendado — cache persistente en tu proyecto)


docker run --rm -it --privileged -v "RUTA\_DE\_TU\_PROYECTO:/work:ro" -v ".\\cache\\trivy:/cache/trivy" -v docker-toolbox-images:/var/lib/docker docker-toolbox


Reemplaza `RUTA\_DE\_TU\_PROYECTO` por la ruta absoluta del proyecto que quieres

analizar (ej. `C:\\Users\\tu-usuario\\mi-proyecto`).

Ejemplo con cache guardado en raiz/cache/ y analizando todo el proyecto:

docker run --rm -it --privileged --name docker-toolbox -v "C:\RUTA\docker-toolbox:/work:ro" -v ".\report:/work/report" -v ".\cache\trivy:/cache/trivy" -v ".\cache\grype:/cache/grype" -v ".\cache\clamav:/cache/clamav" -v ".\cache\terraform:/cache/terraform" -v ".\cache\opentofu:/cache/opentofu" -v docker-toolbox-images:/var/lib/docker docker-toolbox

Para verificar si elimino o conservo imagenes solo se ejecuta:

docker exec docker-toolbox docker images

## Solo lectura y la carpeta report

`/work` está montado de solo lectura (`:ro`) — ninguna herramienta puede
modificar tu proyecto, ni por accidente. La única excepción deliberada es
`/work/report`, montada por separado con permiso de escritura, exclusivamente
para que el sistema de auditoría guarde ahí sus reportes. Ningún otro punto de
`/work` tiene permiso de escritura.

## Catálogo de herramientas

### Dockerfile
| Herramienta | Qué hace | Cache |
|---|---|---|
| Hadolint | Malas prácticas en el `Dockerfile` (texto, no la imagen construida) | No |
| Dive | Eficiencia de la imagen ya construida, capa por capa | No |

### Seguridad
| Herramienta | Qué hace | Cache |
|---|---|---|
| Trivy | CVEs, secretos, IaC, SBOM — escáner todo-en-uno | Sí |
| Grype | Segundo escáner de CVEs, base de datos independiente | Sí |
| OSV-Scanner | Tercer escáner de CVEs, basado en la base OSV de Google | No |
| Gitleaks | Contraseñas/API keys/tokens expuestos | No |
| TruffleHog | Igual, más verificación de si el secreto sigue activo | No |
| Semgrep | SAST: patrones de código inseguro por lenguaje | No |
| Bandit | SAST específico de Python | No |
| Bearer | SAST orientado a datos sensibles/privacidad | No |
| Checkov | Malas configuraciones de seguridad en IaC | No |
| Syft | Inventario (SBOM) de dependencias, no busca CVEs | No |
| ClamAV | Antivirus tradicional, firmas de malware conocido | Sí |
| Puertos declarados | Búsqueda heurística de `EXPOSE`/`listen()` en el código | No |
| nmap | Escaneo activo de red real contra un host/IP (pide host, no analiza `/work`) | No |

### Shell
| Herramienta | Qué hace |
|---|---|
| ShellCheck | Errores y malas prácticas en scripts `.sh` |
| shfmt | Verifica formato/indentación consistente (solo diff, no corrige) |

### YAML
| Herramienta | Qué hace |
|---|---|
| yamllint | Sintaxis y estilo de archivos YAML |
| yq | Consulta valores de un YAML puntual (pide archivo + expresión) |

### Código
| Herramienta | Qué hace |
|---|---|
| scc | Cuenta líneas de código/comentarios/archivos por lenguaje |

### IaC
| Herramienta | Qué hace | Cache |
|---|---|---|
| tflint | Linter de Terraform | No |
| Terraform (validate) | Valida sintaxis de configuración Terraform | Sí (providers) |
| OpenTofu (validate) | Igual, para el fork libre OpenTofu | Sí (providers) |

### Kubernetes
| Herramienta | Qué hace |
|---|---|
| kubeconform | Valida manifiestos contra el esquema oficial de Kubernetes |
| kube-linter | Revisa buenas prácticas de seguridad en manifiestos |

### Utilidades
| Herramienta | Qué hace |
|---|---|
| jq | Consulta valores de un JSON puntual (pide archivo + expresión) |
| buscar-texto | Busca un patrón dentro del contenido de archivos (pide patrón) |
| buscar-archivos | Busca archivos por nombre/extensión (pide patrón) |
| espacio-disco | Muestra qué carpetas ocupan más espacio en el proyecto |
| markdownlint | Estilo/formato de archivos Markdown |

### Red
| Herramienta | Qué hace |
|---|---|
| curl | Verifica estado/headers de una URL (pide URL) |
| dig | Consulta DNS de un dominio (pide dominio) |

### APIs
| Herramienta | Qué hace |
|---|---|
| grpcurl | Lista servicios gRPC de un servidor (pide host:puerto) |

### CI/CD
| Herramienta | Qué hace |
|---|---|
| actionlint | Sintaxis y buenas prácticas de workflows de GitHub Actions |

## Cómo agregar una herramienta nueva

Cada herramienta vive en `tools/<Categoria>/<nombre>/` y sigue este contrato
mínimo:

- `menu.sh` (obligatorio): pide los datos necesarios (minutos, cache, imagen,
  o algún dato específico como host/archivo/patrón) y llama a
  `/engine/run-tool.sh` con esos valores.
- `run.sh` (obligatorio): el `docker run` real que ejecuta la herramienta
  contra `/work`.
- `clean.sh` (opcional): solo si la herramienta tiene cache/DB propia que
  limpiar.

### Ejemplo: agregar una herramienta nueva a una categoría existente

Digamos que quieres agregar otra herramienta de seguridad, junto a Trivy y
Grype:

```
mkdir tools\Seguridad\mi-herramienta-nueva
```

Crea `tools/Seguridad/mi-herramienta-nueva/menu.sh` (copia el patrón de
`tools/Seguridad/hadolint/menu.sh` o cualquier otra herramienta simple como
plantilla) y `run.sh` con el `docker run` correspondiente. Reconstruye:

```
docker build -t docker-toolbox .
```

La herramienta aparece sola en el menú de "Seguridad" — no hay que tocar
`ui/category-menu.sh` ni ningún otro archivo, porque ese menú escanea
`/tools/<categoria>/*/menu.sh` automáticamente.

Si además tiene cache, agrega su `clean.sh` y un flag `-v` nuevo a tu comando
de ejecución (ver tabla de cache arriba) — aparecerá sola también en
"Gestionar cache", que escanea `/tools/*/*/clean.sh` automáticamente.

Si quieres que también corra desde Auditoría, agrégala a `tools.txt` del
grupo que le corresponda (ver sección de Auditoría arriba).

## Cómo agregar una categoría nueva

Simplemente crea la carpeta con el nombre de la categoría y adentro tu
primera herramienta:

```
mkdir tools\MiCategoriaNueva\mi-herramienta
```

Con `menu.sh` y `run.sh` dentro (mismo contrato de arriba), reconstruye, y la
categoría aparece sola en el menú principal — no hay que tocar
`entrypoint.sh` ni ningún otro archivo. El orden en el menú es alfabético por
nombre de carpeta.

### ⚠️ Si NO agregas el `-v` de cache de una herramienta


El cache de esa herramienta se escribe igual dentro del contenedor

(`/cache/<tool>`), pero como no está conectado a ninguna carpeta de Windows,

vive únicamente en la capa temporal del propio contenedor de Docker Toolbox.

Al usar `--rm`, esa capa se destruye al salir — el cache desaparece por

completo y la próxima vez se vuelve a descargar/generar desde cero. No se

guarda "en la imagen" en sentido estricto (las imágenes de Docker son

inmutables), pero el efecto práctico es el mismo: se pierde.

## Sistema de Auditoría

La opción **"A. Auditoria"** del menú principal ejecuta varias herramientas
relacionadas en una sola pasada, con una sola configuración de
tiempo/cache/imagen aplicada a todas, y guarda un reporte en `report/` en la
raíz de tu proyecto.

### Grupos disponibles

| Grupo | Herramientas |
|---|---|
| Vulnerabilidades | Trivy, Grype, OSV-Scanner |
| Secretos | Gitleaks, TruffleHog |
| Código peligroso (SAST) | Semgrep, Bandit, Bearer |
| Virus/Malware | ClamAV |
| Buenas prácticas Dockerfile | Hadolint |
| Infraestructura (IaC) | Checkov, tflint, Terraform, OpenTofu |
| Kubernetes | kubeconform, kube-linter |
| Estilo y formato | ShellCheck, shfmt, yamllint, markdownlint |
| CI/CD | actionlint |
| Inventario (SBOM) | Syft |
| Metadatos del proyecto | scc, espacio-disco, puertos-declarados |
| **Auditoría completa** | Las 25 anteriores juntas |

No incluidas en grupos (necesitan un dato específico cada vez, se usan
individualmente): `nmap`, `dig`, `curl`, `grpcurl`, `jq`, `yq`,
`buscar-texto`, `buscar-archivos`, `Dive`.

### Formato del reporte

Se guarda como `report/<grupo>_<fecha>-<hora>.md`, con un encabezado `##` por
cada herramienta ejecutada y su salida completa debajo, en un bloque de
código — para distinguir sin ambigüedad qué herramienta dijo qué:

```markdown
# Auditoria: vulnerabilidades

Fecha: 2026-08-10 15:30:00

## trivy

​```
(salida completa de Trivy)
​```

## grype

​```
(salida completa de Grype)
​```
```

### Cómo agregar una herramienta a un grupo existente

Edita `ui/audit/grupos/<grupo>/tools.txt` y agrega una línea con este
formato (deja el último campo vacío si la herramienta no tiene cache):

```
nombre|ruta/a/run.sh|nombre-de-la-imagen|ruta/a/clean.sh
```

No hace falta tocar ningún script ni el menú — se lee automáticamente en el
siguiente arranque.

Cómo agregar una herramienta a un grupo existente

Edita ui/audit/grupos/<grupo>/tools.txt y agrega una línea con este formato (deja el último campo vacío si la herramienta no tiene cache):

nombre|ruta/a/run.sh|nombre-de-la-imagen|ruta/a/clean.sh

⚠️ Asegúrate de que el archivo termine con un salto de línea después de la última entrada — si no, esa última línea no se ejecutará.

Cada herramienta vive en tools/<Categoria>/<nombre>/ y sigue este contrato mínimo:

menu.sh (obligatorio): pide los datos necesarios (minutos, cache, imagen, o algún dato específico como host/archivo/patrón) y llama a /engine/run-tool.sh con esos valores.
run.sh (obligatorio): el docker run real que ejecuta la herramienta contra /work.
clean.sh (opcional): solo si la herramienta tiene cache/DB propia que limpiar.

### Cómo crear un grupo de auditoría nuevo

Crea una carpeta `ui/audit/grupos/<nombre-del-grupo>/` con 2 archivos:

- `info.txt`: primera línea = título que se muestra en el menú, segunda
  línea = descripción.
- `tools.txt`: una línea por herramienta, mismo formato de arriba.

El menú de Auditoría lo detecta solo, sin tocar ningún otro archivo.

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

#### Leer las notas en las herraminetas que contengan para obtener mas informacióon

## Notas de mantenimiento

- **Siempre reconstruye** (`docker build -t docker-toolbox .`) después de
  agregar o mover archivos `.sh` — el `Dockerfile` aplica permisos de
  ejecución automáticamente a cualquier script nuevo bajo `tools/`, `ui/` o
  `engine/`.
- **Si mueves una carpeta de herramienta**, revisa y actualiza a mano la
  ruta `TOOL_SCRIPT` (y `CLEAN_SCRIPT` si aplica) dentro de su propio
  `menu.sh` — mover la carpeta no actualiza esa ruta automáticamente.
- Las imágenes Docker de terceros usadas (`aquasec/trivy`, `hadolint/hadolint`,
  etc.) se mantienen bajo sus propias licencias — este proyecto solo las
  orquesta, no las redistribuye.
- Por buenas prácticas de seguridad de cadena de suministro, considera fijar
  versiones específicas (ej. `aquasec/trivy:0.69.7`) en vez de `:latest`
  para las herramientas más críticas, una vez que congeles la arquitectura.

- Falsos positivos en al analizar:

  - Varios resultados "raros" tienen la misma explicación real: carpetas (con las bases de datos de Trivy, Grype, ClamAV) vive dentro de la misma carpeta analizada, como /work, cuando se analiza algún proyecto. Eso hace que las herramientas terminen otros datos como si fueran código.

⚠️ Las herramientas y utilidades mencionadas en este repositorio son propiedad intelectual de sus respectivos desarrolladores y se obtienen a través de Docker Hub. La disponibilidad, el mantenimiento y las futuras actualizaciones de estas herramientas dependen exclusivamente de sus creadores originales.