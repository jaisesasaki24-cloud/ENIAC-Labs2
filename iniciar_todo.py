#!/usr/bin/env python3
"""
==============================================================================
ENIAC LABS - INICIADOR AUTOMATICO DEL ECOSISTEMA DISTRIBUIDO
==============================================================================
Este script:
 1. Verifica si Docker Engine esta activo (y lo inicia si no lo esta).
 2. Levanta todos los contenedores con Docker Compose (bases de datos,
    servidores Spring Cloud, microservicios y observabilidad).
 3. Verifica la salud de los servicios y aplica autorreparacion si pc-eureka
    o los microservicios necesitan sincronizacion tras arrancar el Config Server.
 4. Inicia el servidor local de documentacion MkDocs en segundo plano.
 5. Abre automaticamente cada una de las paginas web y dashboards en el
    navegador predeterminado.
 6. Proporciona un menu interactivo en consola para monitorear, reabrir o apagar.

Uso:
    python iniciar_todo.py               # Inicia todo y abre las paginas
    python iniciar_todo.py --no-browser  # Inicia todo sin abrir el navegador
    python iniciar_todo.py --open-only   # Solo abre las paginas
    python iniciar_todo.py --status      # Solo verifica el estado actual
    python iniciar_todo.py --down        # Detiene todo el ecosistema
==============================================================================
"""

import sys
import os
import time
import subprocess
import webbrowser
import urllib.request
import urllib.error
import argparse
from typing import List, Dict, Any, Optional

# Configuracion de la consola en Windows para colores ANSI y codificacion UTF-8
if sys.platform == "win32":
    os.system("")
    try:
        if hasattr(sys.stdout, "reconfigure"):
            sys.stdout.reconfigure(encoding="utf-8")
            sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

# Codigos ANSI de estilo
C_RESET = "\033[0m"
C_BOLD = "\033[1m"
C_CYAN = "\033[96m"
C_GREEN = "\033[92m"
C_YELLOW = "\033[93m"
C_RED = "\033[91m"
C_MAGENTA = "\033[95m"
C_BLUE = "\033[94m"
C_GRAY = "\033[90m"

WORKSPACE_DIR = os.path.dirname(os.path.abspath(__file__))
PID_FILE = os.path.join(WORKSPACE_DIR, ".mkdocs.pid")

# Definicion de los servicios y sus URLs
SERVICES: List[Dict[str, Any]] = [
    {
        "id": "mkdocs",
        "name": "MkDocs - Portal Documentacion",
        "category": "Documentacion",
        "url": "http://localhost:8000",
        "check_url": "http://127.0.0.1:8000",
        "desc": "Manual de arquitectura, sesiones S01-S06 y evaluacion",
        "browser": True,
    },
    {
        "id": "eureka",
        "name": "Eureka Service Registry",
        "category": "Infraestructura",
        "url": "http://localhost:18761",
        "check_url": "http://127.0.0.1:18761",
        "desc": "Dashboard de registro y descubrimiento Spring Cloud",
        "browser": True,
    },
    {
        "id": "gateway",
        "name": "API Gateway Actuator",
        "category": "Infraestructura",
        "url": "http://localhost:18080/actuator/health",
        "check_url": "http://127.0.0.1:18080/actuator/health",
        "desc": "Spring Cloud Gateway WebMVC - Punto unico perimetral",
        "browser": True,
    },
    {
        "id": "gateway_prod",
        "name": "API Gateway (Productos API)",
        "category": "Ruta Gateway",
        "url": "http://localhost:18080/api/v1/productos",
        "check_url": "http://127.0.0.1:18080/api/v1/productos",
        "desc": "Hardware Gamer expuesto a traves del Gateway WebMVC",
        "browser": True,
    },
    {
        "id": "config",
        "name": "Spring Cloud Config",
        "category": "Infraestructura",
        "url": "http://localhost:18888/actuator/health",
        "check_url": "http://127.0.0.1:18888/actuator/health",
        "desc": "Servidor centralizado de propiedades (perfiles dev/prod)",
        "browser": False,
    },
    {
        "id": "catalogo",
        "name": "pc-catalogo-ms (Swagger UI)",
        "category": "Microservicio",
        "url": "http://localhost:8081/swagger-ui/index.html",
        "check_url": "http://127.0.0.1:8081/swagger-ui/index.html",
        "desc": "Catalogo Gamer & Control de Stock (Eliceo Parillo)",
        "browser": True,
    },
    {
        "id": "orden",
        "name": "pc-orden-ms (Swagger UI)",
        "category": "Microservicio",
        "url": "http://localhost:8083/swagger-ui/index.html",
        "check_url": "http://127.0.0.1:8083/swagger-ui/index.html",
        "desc": "Gestion de Ordenes e IGV 18% - UNICO TRANSACCIONAL (Eliceo Parillo)",
        "browser": True,
    },
    {
        "id": "cotizacion",
        "name": "pc-cotizacion-ms (Swagger UI)",
        "category": "Microservicio",
        "url": "http://localhost:8089/swagger-ui/index.html",
        "check_url": "http://127.0.0.1:8089/swagger-ui/index.html",
        "desc": "PC Gamer Builder, Proformas & Ventas (Laura Vargas)",
        "browser": True,
    },
    {
        "id": "pago",
        "name": "pc-pago-ms (Swagger UI)",
        "category": "Microservicio",
        "url": "http://localhost:8085/swagger-ui/index.html",
        "check_url": "http://127.0.0.1:8085/swagger-ui/index.html",
        "desc": "Mercado Pago Sandbox & Webhooks (Laura Vargas)",
        "browser": True,
    },
    {
        "id": "grafana",
        "name": "Grafana Server",
        "category": "Observabilidad",
        "url": "http://localhost:3000",
        "check_url": "http://127.0.0.1:3000",
        "desc": "Dashboards de metricas JVM, throughput y logs (admin/admin)",
        "browser": True,
    },
    {
        "id": "prometheus",
        "name": "Prometheus Targets",
        "category": "Observabilidad",
        "url": "http://localhost:9090/targets",
        "check_url": "http://127.0.0.1:9090/targets",
        "desc": "Monitor de raspado de metricas y estado de endpoints",
        "browser": True,
    },
]


def print_banner():
    banner = f"""
{C_CYAN}{C_BOLD}==============================================================================
    ENIAC LABS - ORQUESTADOR DEL ECOSISTEMA DISTRIBUIDO DE MICROSERVICIOS
=============================================================================={C_RESET}
    {C_MAGENTA}Arquitectura:{C_RESET} Spring Cloud Gateway + Eureka + Config Server + PostgreSQL
    {C_MAGENTA}Monitoreo:{C_RESET}    Prometheus + Grafana + Loki + Promtail + Node Exporter
    {C_MAGENTA}Integrantes:{C_RESET}  Eliceo Parillo Mostajo & Laura Vargas Cristhian Paul
{C_CYAN}=============================================================================={C_RESET}
"""
    print(banner)


def check_url(url: str, timeout: float = 2.5) -> bool:
    """Verifica si una URL responde con codigo 2xx o 3xx."""
    try:
        req = urllib.request.Request(
            url,
            headers={"User-Agent": "ENIAC-Labs-HealthChecker/1.0"}
        )
        with urllib.request.urlopen(req, timeout=timeout) as response:
            return response.status in [200, 201, 204, 301, 302, 307, 308]
    except urllib.error.HTTPError as e:
        return e.code in [200, 201, 204, 301, 302, 307, 308]
    except Exception:
        return False


def is_docker_running() -> bool:
    """Comprueba si el daemon de Docker esta respondiendo."""
    try:
        res = subprocess.run(
            ["docker", "info"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=4
        )
        return res.returncode == 0
    except Exception:
        return False


def ensure_docker_daemon():
    """Verifica y asegura que Docker Engine este iniciado."""
    print(f"{C_BOLD}[1/4] Verificando Docker Engine...{C_RESET}")
    if is_docker_running():
        print(f"  {C_GREEN}[OK] Docker Engine esta activo y respondiendo.{C_RESET}")
        return

    print(f"  {C_YELLOW}[!] Docker no esta respondiendo. Intentando iniciar Docker Desktop...{C_RESET}")

    possible_paths = [
        os.path.expandvars(r"%LOCALAPPDATA%\Programs\DockerDesktop\Docker Desktop.exe"),
        r"C:\Program Files\Docker\Docker\Docker Desktop.exe",
        os.path.expandvars(r"%LOCALAPPDATA%\Programs\DockerDesktop\resources\com.docker.backend.exe")
    ]

    started = False
    for path in possible_paths:
        if os.path.exists(path):
            try:
                print(f"  {C_BLUE}[INFO] Ejecutando:{C_RESET} {path}")
                subprocess.Popen([path], shell=False)
                started = True
                break
            except Exception as e:
                print(f"  {C_GRAY}Error al intentar {path}: {e}{C_RESET}")

    if not started:
        print(f"  {C_RED}[ERROR] No se encontro Docker Desktop en las rutas habituales.{C_RESET}")
        print(f"    Por favor, inicia Docker Desktop manualmente y vuelve a ejecutar este script.")
        sys.exit(1)

    print(f"  {C_YELLOW}[...] Esperando a que el daemon de Docker termine de iniciar (hasta 45s)...{C_RESET}")
    max_wait = 60
    start_time = time.time()
    while time.time() - start_time < max_wait:
        if is_docker_running():
            print(f"\n  {C_GREEN}[OK] Docker Engine inicio exitosamente.{C_RESET}")
            return
        print(".", end="", flush=True)
        time.sleep(3)

    print(f"\n  {C_RED}[ERROR] Tiempo de espera agotado esperando a Docker Engine.{C_RESET}")
    print(f"    Verifica la aplicacion Docker Desktop y ejecuta el script nuevamente.")
    sys.exit(1)


def start_docker_compose():
    """Ejecuta docker compose up -d y garantiza el orden de arranque."""
    print(f"\n{C_BOLD}[2/4] Iniciando contenedores Docker Compose...{C_RESET}")
    compose_cmd = ["docker", "compose", "up", "-d"]
    try:
        res = subprocess.run(compose_cmd, cwd=WORKSPACE_DIR, capture_output=True, text=True)
        if res.returncode == 0:
            print(f"  {C_GREEN}[OK] Contenedores iniciados correctamente via Docker Compose.{C_RESET}")
        else:
            print(f"  {C_RED}[ERROR] Error al ejecutar docker compose up:{C_RESET}\n{res.stderr}")
    except Exception as e:
        print(f"  {C_RED}[ERROR] Error al invocar docker compose: {e}{C_RESET}")

    # Chequeo inteligente de Config Server y Eureka
    print(f"  {C_BLUE}[INFO] Esperando estabilizacion del Config Server y Eureka...{C_RESET}")
    config_up = False
    for _ in range(15):
        if check_url("http://127.0.0.1:18888/actuator/health", timeout=1.5):
            config_up = True
            break
        time.sleep(2)

    if config_up:
        print(f"  {C_GREEN}[OK] Config Server esta respondiendo.{C_RESET}")
    else:
        print(f"  {C_YELLOW}[!] Config Server tomo mas tiempo del esperado.{C_RESET}")

    # Verificar si Eureka necesita sincronizacion por inicio en frio
    if not check_url("http://127.0.0.1:18761", timeout=2.0):
        print(f"  {C_YELLOW}[SYNC] Reiniciando pc-eureka para sincronizacion con pc-config...{C_RESET}")
        subprocess.run(["docker", "restart", "eniaclabs-eureka"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        time.sleep(5)

    # Verificar si microservicios responden en sus puertos
    if not check_url("http://127.0.0.1:8081/swagger-ui/index.html", timeout=2.0):
        print(f"  {C_YELLOW}[SYNC] Sincronizando microservicios y Gateway con el ecosistema...{C_RESET}")
        subprocess.run([
            "docker", "restart",
            "eniaclabs-gateway",
            "eniaclabs-catalogo-ms",
            "eniaclabs-orden-ms",
            "eniaclabs-pago-ms",
            "eniaclabs-cotizacion-ms"
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def start_mkdocs():
    """Inicia el servidor de documentacion MkDocs en segundo plano."""
    print(f"\n{C_BOLD}[3/4] Iniciando servidor de documentacion MkDocs...{C_RESET}")

    if check_url("http://127.0.0.1:8000", timeout=1.5):
        print(f"  {C_GREEN}[OK] MkDocs ya se encuentra en ejecucion en http://localhost:8000{C_RESET}")
        return

    flags = 0
    if sys.platform == "win32":
        flags = subprocess.CREATE_NEW_PROCESS_GROUP

    try:
        proc = subprocess.Popen(
            [sys.executable, "-m", "mkdocs", "serve", "-a", "127.0.0.1:8000"],
            cwd=WORKSPACE_DIR,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            creationflags=flags
        )
        # Guardar PID para gestion limpia
        with open(PID_FILE, "w") as f:
            f.write(str(proc.pid))

        # Esperar confirmacion de respuesta
        for _ in range(10):
            if check_url("http://127.0.0.1:8000", timeout=1.0):
                print(f"  {C_GREEN}[OK] MkDocs iniciado exitosamente en http://localhost:8000{C_RESET}")
                return
            time.sleep(1)
        print(f"  {C_YELLOW}[!] MkDocs fue lanzado en segundo plano (PID: {proc.pid}).{C_RESET}")
    except Exception as e:
        print(f"  {C_RED}[ERROR] No se pudo iniciar MkDocs: {e}{C_RESET}")


def stop_mkdocs():
    """Detiene el proceso de MkDocs si esta registrado en .mkdocs.pid."""
    if os.path.exists(PID_FILE):
        try:
            with open(PID_FILE, "r") as f:
                pid = int(f.read().strip())
            if sys.platform == "win32":
                subprocess.run(["taskkill", "/F", "/T", "/PID", str(pid)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            else:
                os.kill(pid, 9)
        except Exception:
            pass
        try:
            os.remove(PID_FILE)
        except Exception:
            pass


def wait_for_services(max_retries: int = 15, delay: float = 2.0):
    """Espera a que los servicios principales alcancen estado activo."""
    print(f"\n{C_BOLD}[4/4] Verificando estado y disponibilidad de los servicios...{C_RESET}")

    key_services = [s for s in SERVICES if s["id"] in ["mkdocs", "eureka", "gateway", "catalogo", "orden", "cotizacion", "pago", "grafana", "prometheus"]]

    for attempt in range(1, max_retries + 1):
        all_up = True
        pending = []
        for s in key_services:
            up = check_url(s["check_url"], timeout=1.5)
            s["is_up"] = up
            if not up:
                all_up = False
                pending.append(s["name"])

        if all_up:
            print(f"  {C_GREEN}[OK] Todos los servicios clave estan respondiendo.{C_RESET}")
            break

        if attempt < max_retries:
            print(f"  {C_GRAY}[Intento {attempt}/{max_retries}] Esperando a: {', '.join(pending[:3])}...{C_RESET}")
            time.sleep(delay)
        else:
            print(f"  {C_YELLOW}[!] Algunos servicios tardaron mas en arrancar, pero el sistema esta en progreso.{C_RESET}")


def display_status_table():
    """Muestra una tabla con el estado detallado de todos los servicios."""
    print("\n" + "=" * 90)
    print(f" {C_BOLD}{'SERVICIO':<32} {'CATEGORIA':<16} {'ESTADO':<11} {'URL':<30}{C_RESET}")
    print("-" * 90)

    for s in SERVICES:
        up = check_url(s["check_url"], timeout=1.5)
        status_text = f"{C_GREEN}[ACTIVO]{C_RESET}" if up else f"{C_RED}[ESPERA]{C_RESET}"
        print(f" {s['name']:<32} {s['category']:<16} {status_text:<20} {C_CYAN}{s['url']}{C_RESET}")

    print("=" * 90)


def open_all_pages():
    """Abre cada pagina web relevante en el navegador predeterminado."""
    pages_to_open = [s for s in SERVICES if s.get("browser", False)]

    print(f"\n{C_BOLD}{C_CYAN}[NAVEGADOR] Abriendo {len(pages_to_open)} paginas en el navegador predeterminado...{C_RESET}")

    for idx, s in enumerate(pages_to_open, 1):
        print(f"  {C_GRAY}[{idx}/{len(pages_to_open)}]{C_RESET} Abriendo: {C_BOLD}{s['name']}{C_RESET} -> {C_BLUE}{s['url']}{C_RESET}")
        try:
            webbrowser.open(s["url"], new=2)
        except Exception as e:
            print(f"    {C_RED}[ERROR] al abrir {s['url']}: {e}{C_RESET}")
        time.sleep(0.7)  # Pausa suave para evitar que el navegador colapse

    print(f"\n{C_GREEN}{C_BOLD}[OK] Todas las paginas han sido enviadas al navegador.{C_RESET}")


def stop_everything():
    """Detiene Docker Compose y MkDocs."""
    print(f"\n{C_YELLOW}{C_BOLD}[DETENER] Deteniendo todos los servicios del ecosistema...{C_RESET}")
    stop_mkdocs()
    try:
        subprocess.run(["docker", "compose", "down"], cwd=WORKSPACE_DIR)
        print(f"{C_GREEN}[OK] Contenedores Docker detenidos y limpiados.{C_RESET}")
    except Exception as e:
        print(f"{C_RED}[ERROR] Error al detener contenedores: {e}{C_RESET}")


def interactive_menu():
    """Bucle de menu interactivo para conveniencia del usuario."""
    menu_text = f"""
{C_BOLD}Acciones rapidas disponibles:{C_RESET}
  {C_CYAN}[1 / o]{C_RESET} Reabrir todas las paginas en el navegador
  {C_CYAN}[2 / s]{C_RESET} Actualizar y verificar estado de salud
  {C_CYAN}[3 / r]{C_RESET} Reiniciar microservicios de negocio
  {C_CYAN}[4 / d]{C_RESET} Detener todo (docker compose down + cerrar mkdocs)
  {C_CYAN}[q / Ctrl+C]{C_RESET} Salir (manteniendo los contenedores encendidos)
"""
    print(menu_text)

    while True:
        try:
            choice = input(f"{C_BOLD}ENIAC-Labs > {C_RESET}").strip().lower()
            if choice in ["1", "o", "open"]:
                open_all_pages()
            elif choice in ["2", "s", "status"]:
                display_status_table()
            elif choice in ["3", "r", "restart"]:
                print(f"{C_YELLOW}Reiniciando microservicios...{C_RESET}")
                subprocess.run([
                    "docker", "restart",
                    "eniaclabs-catalogo-ms",
                    "eniaclabs-orden-ms",
                    "eniaclabs-pago-ms",
                    "eniaclabs-cotizacion-ms"
                ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                time.sleep(5)
                display_status_table()
            elif choice in ["4", "d", "down", "stop"]:
                stop_everything()
                break
            elif choice in ["q", "exit", "quit"]:
                print(f"{C_GREEN}Saliendo del asistente. Los servicios continuaran ejecutandose en segundo plano.{C_RESET}")
                break
            else:
                print(f"{C_GRAY}Opcion no reconocida. Opciones validas: [1=abrir, 2=estado, 3=reiniciar, 4=detener, q=salir]{C_RESET}")
        except (KeyboardInterrupt, EOFError):
            print(f"\n{C_GREEN}Saliendo del asistente. Los servicios continuaran ejecutandose en segundo plano.{C_RESET}")
            break


def main():
    parser = argparse.ArgumentParser(description="Orquestador automatico para el ecosistema ENIAC Labs")
    parser.add_argument("--no-browser", action="store_true", help="Inicia los servicios sin abrir el navegador")
    parser.add_argument("--open-only", action="store_true", help="Solo abre las paginas web en el navegador")
    parser.add_argument("--status", action="store_true", help="Solo verifica y muestra el estado actual de los servicios")
    parser.add_argument("--down", action="store_true", help="Detiene todos los contenedores y el servidor de documentacion")
    args = parser.parse_args()

    print_banner()

    if args.down:
        stop_everything()
        return

    if args.status:
        display_status_table()
        return

    if args.open_only:
        display_status_table()
        open_all_pages()
        return

    # Flujo completo de inicio
    ensure_docker_daemon()
    start_docker_compose()
    start_mkdocs()
    wait_for_services()
    display_status_table()

    if not args.no_browser:
        open_all_pages()

    interactive_menu()


if __name__ == "__main__":
    main()
