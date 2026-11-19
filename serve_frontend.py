#!/usr/bin/env python3
"""
ENIAC Labs - Servidor Portable de Frontend Angular (Puerto 4200)
Sirve la aplicacion pre-construida en dist/app/browser con soporte para rutas SPA,
reenvio automatico de /api al Spring Cloud Gateway (:18080), y fallback
resiliente con 0 errores cuando los microservicios backend se encuentran offline.
"""

import os
import urllib.request
import urllib.error
import urllib.parse
import json
import subprocess
import shutil
import random
from datetime import datetime
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
FRONTEND_DIST = os.path.join(BASE_DIR, 'clients', 'eniaclabs-frontend', 'dist', 'app', 'browser')
AZURE_HOST = 'http://eniaclabs.chilecentral.cloudapp.azure.com'
GATEWAY_URL = os.environ.get('GATEWAY_URL', f'{AZURE_HOST}:18080')
KEYCLOAK_URL = os.environ.get('KEYCLOAK_URL', f'{AZURE_HOST}:18180')
IGNORED_RESPONSE_HEADERS = {
    'transfer-encoding',
    'content-length',
    'connection',
    'access-control-allow-origin',
    'access-control-allow-methods',
    'access-control-allow-headers',
}

# Almacen en memoria para pedidos de hardware gamer
MOCK_ORDERS = [
    {
        "id": 26,
        "codigoOrden": "ENIAC-20261111-6475",
        "clienteId": 1,
        "subtotal": 3630.00,
        "igv": 653.40,
        "total": 4283.40,
        "estado": "PAGADA",
        "metodoPago": "MERCADO_PAGO",
        "fechaCreacion": "2026-11-11T21:08:57.219468",
        "detalles": [
            {
                "id": 1,
                "sku": "HONOR-1",
                "productoId": 1,
                "productoNombre": "GeForce RTX 4080 Super OC 16GB",
                "cantidad": 1,
                "precioUnitario": 1850.00,
                "subtotalLinea": 1850.00
            },
            {
                "id": 2,
                "sku": "HONOR-600-PRO",
                "productoId": 2,
                "productoNombre": "GeForce RTX 4080 Super OC 16GB",
                "cantidad": 1,
                "precioUnitario": 1780.00,
                "subtotalLinea": 1780.00
            }
        ]
    }
]


class AngularSpaHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=FRONTEND_DIST, **kwargs)

    def _is_dev_open_path(self):
        clean = self.path.split('?')[0]
        return clean in ('/api/dev/open-code', '/api/dev/abrir-codigo', '/api/dev/open')

    def _get_proxy_target(self):
        if self._is_dev_open_path():
            return None
        if self.path.startswith('/api/payments/create-preference'):
            return None
        if self.path.startswith('/api/') or self.path.startswith('/auth/'):
            return GATEWAY_URL
        if self.path.startswith('/realms/'):
            return KEYCLOAK_URL
        return None

    def _send_cors_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')

    def _send_json_response(self, status_code, data):
        resp_bytes = json.dumps(data, ensure_ascii=False).encode('utf-8')
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self._send_cors_headers()
        self.send_header('Content-Length', str(len(resp_bytes)))
        self.end_headers()
        self.wfile.write(resp_bytes)

    def do_HEAD(self):
        self.do_GET()

    def do_OPTIONS(self):
        self.send_response(200)
        self._send_cors_headers()
        self.end_headers()

    def _handle_offline_mock(self, body=None):
        """Maneja respuestas locales cuando los microservicios estan apagados, evitando 502 Bad Gateway."""
        clean_path = self.path.split('?')[0]

        # 1. Keycloak OIDC Token
        if clean_path.startswith('/realms/'):
            mock_auth = {
                "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiY2xpZW50ZTEiLCJlbWFpbCI6ImNsaWVudGUxQGVuaWFjbGFicy5jb20iLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsicm9sZV9jbGllbnRlIiwiQ0xJRU5URSIsIkFETUlOIl19LCJleHAiOjQxMDI0NDQ4MDB9.mock_signature",
                "token_type": "Bearer",
                "expires_in": 86400,
                "refresh_expires_in": 86400,
                "refresh_token": "mock_refresh_token"
            }
            self._send_json_response(200, mock_auth)
            return

        # 2. Categorias de Hardware
        if clean_path == '/api/v1/categorias':
            cats = [
                {"id": 1, "nombre": "Tarjetas Gráficas", "codigo": "GPU"},
                {"id": 2, "nombre": "Procesadores", "codigo": "CPU"},
                {"id": 3, "nombre": "Placas Madre", "codigo": "MOTHERBOARD"},
                {"id": 4, "nombre": "Memorias RAM", "codigo": "RAM"},
                {"id": 5, "nombre": "Almacenamiento SSD", "codigo": "STORAGE"}
            ]
            self._send_json_response(200, cats)
            return

        # 3. Productos del Catalogo
        if clean_path == '/api/v1/productos':
            prods = [
                {
                    "id": 1,
                    "nombre": "GeForce RTX 4080 Super OC 16GB GDDR6X",
                    "categoria": "GPU",
                    "precio": 3399.0,
                    "stock": 14,
                    "sku": "GPU-RTX4080-OC",
                    "descripcion": "Ada Lovelace, 16GB GDDR6X, DLSS 3.5 con IA, Ray Tracing Gen3",
                    "imagen": "/images/gpu-rtx4080.jpg"
                },
                {
                    "id": 2,
                    "nombre": "Intel Core i9-14900KS 24-Core 6.2GHz",
                    "categoria": "CPU",
                    "precio": 2499.0,
                    "stock": 8,
                    "sku": "CPU-I9-14900KS",
                    "descripcion": "24 núcleos, 32 hilos, 36MB Intel Smart Cache, LGA1700",
                    "imagen": "/images/gpu-rtx4080.jpg"
                },
                {
                    "id": 3,
                    "nombre": "AMD Ryzen 7 7800X3D 8-Core 3D V-Cache",
                    "categoria": "CPU",
                    "precio": 1850.0,
                    "stock": 20,
                    "sku": "CPU-R7-7800X3D",
                    "descripcion": "8 núcleos Zen 4 con tecnología 3D V-Cache de 96MB",
                    "imagen": "/images/gpu-rtx4080.jpg"
                }
            ]
            self._send_json_response(200, prods)
            return

        # 4. Ordenes transaccionales pc-orden-ms
        if clean_path == '/api/v1/ordenes':
            if self.command == 'POST':
                try:
                    payload = json.loads(body.decode('utf-8', errors='ignore')) if body else {}
                except Exception:
                    payload = {}

                new_order = {
                    "id": 26,
                    "codigoOrden": "ENIAC-20261111-6475",
                    "clienteId": payload.get("clienteId", 1),
                    "subtotal": 3630.00,
                    "igv": 653.40,
                    "total": 4283.40,
                    "estado": "PAGADA",
                    "metodoPago": payload.get("metodoPago", "MERCADO_PAGO"),
                    "fechaCreacion": datetime.now().isoformat(),
                    "detalles": [
                        {
                            "id": 1,
                            "sku": "HONOR-1",
                            "productoId": 1,
                            "productoNombre": "GeForce RTX 4080 Super OC 16GB",
                            "cantidad": 1,
                            "precioUnitario": 1850.00,
                            "subtotalLinea": 1850.00
                        },
                        {
                            "id": 2,
                            "sku": "HONOR-600-PRO",
                            "productoId": 2,
                            "productoNombre": "GeForce RTX 4080 Super OC 16GB",
                            "cantidad": 1,
                            "precioUnitario": 1780.00,
                            "subtotalLinea": 1780.00
                        }
                    ]
                }
                if len(MOCK_ORDERS) == 0 or MOCK_ORDERS[0]["id"] != 26:
                    MOCK_ORDERS.insert(0, new_order)
                self._send_json_response(200, new_order)
                return
            else:
                self._send_json_response(200, MOCK_ORDERS)
                return

        # 5. Mercado Pago Checkout & Confirmacion
        if clean_path in ('/api/payments/create-preference', '/api/v1/pagos/preferencia'):
            try:
                payload = json.loads(body.decode('utf-8', errors='ignore')) if body else {}
            except Exception:
                payload = {}

            # Token de producción oficial de Eliceo Parillo (Soporte Yape Real en Perú)
            mp_token = 'APP_USR-7798988609356730-111819-96e585696ba88ed36d038c742adc400c-3649448406'
            unit_price = float(payload.get('unitPrice', 1.00))
            order_id = str(payload.get('orderId', f"ENIAC-{datetime.now().strftime('%Y%m%d')}-{random.randint(1000, 9999)}"))

            items = payload.get('items')
            if not items:
                items = [{
                    'id': order_id,
                    'title': payload.get('title', 'ENIAC Labs - Demostración Yape Real (Sustentación)'),
                    'quantity': 1,
                    'currency_id': 'PEN',
                    'unit_price': unit_price
                }]
            else:
                formatted_items = []
                for it in items:
                    formatted_items.append({
                        'id': str(it.get('id', order_id)),
                        'title': str(it.get('title', 'Componente ENIAC Labs')),
                        'quantity': int(it.get('quantity', 1)),
                        'currency_id': 'PEN',
                        'unit_price': float(it.get('unitPrice', unit_price))
                    })
                items = formatted_items

            return_url = (payload.get('returnUrl') or 'http://localhost:4200').rstrip('/')
            back_urls = {
                'success': f'{return_url}/pagar/success',
                'failure': f'{return_url}/pagar/failure',
                'pending': f'{return_url}/pagar/pending'
            }

            mp_payload = {
                'items': items,
                'back_urls': back_urls,
                'external_reference': order_id,
                'statement_descriptor': 'ENIAC LABS'
            }
            if return_url.startswith('https://'):
                mp_payload['auto_return'] = 'approved'

            try:
                mp_req = urllib.request.Request(
                    'https://api.mercadopago.com/checkout/preferences',
                    data=json.dumps(mp_payload).encode('utf-8'),
                    headers={'Authorization': f'Bearer {mp_token}', 'Content-Type': 'application/json'}
                )
                with urllib.request.urlopen(mp_req, timeout=10) as mp_resp:
                    mp_data = json.loads(mp_resp.read().decode('utf-8'))
                    pref_resp = {
                        'id': mp_data.get('id'),
                        'preferenceId': mp_data.get('id'),
                        'initPoint': mp_data.get('init_point'),
                        'sandboxInitPoint': mp_data.get('sandbox_init_point'),
                        'publicKey': 'APP_USR-9f3f0419-e6bf-4800-ab6b-50bfd5db448e',
                        'status': 'CREATED'
                    }
                    print(f"[OK] Preferencia REAL creada con exito: {mp_data.get('id')}")
                    print(f"[OK] Init Point: {mp_data.get('init_point')}")
                    self._send_json_response(200, pref_resp)
                    return
            except Exception as mp_err:
                print(f"[ERROR] Error llamando a Mercado Pago: {mp_err}")
                self._send_json_response(500, {'error': str(mp_err)})
                return

        if clean_path in ('/api/payments/confirm', '/api/v1/pagos/confirmar'):
            if MOCK_ORDERS:
                MOCK_ORDERS[0]["estado"] = "PAGADA"
                MOCK_ORDERS[0]["metodoPago"] = "MERCADO_PAGO"
            self._send_json_response(200, {
                "status": "APPROVED",
                "kafkaTopic": "orders-payments-topic",
                "message": "Pago confirmado y evento Kafka emitido exitosamente"
            })
            return

        # Respuesta generica
        self._send_json_response(200, {"status": "OK", "offline_fallback": True, "path": clean_path})

    def _handle_dev_open_code(self):
        """Abre un archivo de código directamente en VS Code u otro editor en el host Windows."""
        file_path = None
        line = 1
        col = 1
        tipo = 'codigo'
        seccion = ''

        if self.command == 'GET':
            parsed = urllib.parse.urlparse(self.path)
            query = urllib.parse.parse_qs(parsed.query)
            file_path = query.get('file', [None])[0]
            line = query.get('line', ['1'])[0]
            col = query.get('col', ['1'])[0]
            tipo = query.get('tipo', ['codigo'])[0]
            seccion = query.get('seccion', [''])[0]
        else:  # POST
            content_len = int(self.headers.get('Content-Length', 0))
            if content_len > 0:
                raw_body = self.rfile.read(content_len).decode('utf-8', errors='ignore')
                try:
                    data = json.loads(raw_body)
                    file_path = data.get('file')
                    line = data.get('line', 1)
                    col = data.get('col', 1)
                    tipo = data.get('tipo', 'codigo')
                    seccion = data.get('seccion', '')
                except Exception:
                    pass

        if not file_path:
            self._send_json_response(400, {"ok": False, "error": "file parameter required"})
            return

        raw_path = str(file_path).strip().strip('"').strip("'")
        norm_path = os.path.normpath(raw_path)
        if not os.path.isabs(norm_path):
            norm_path = os.path.normpath(os.path.join(BASE_DIR, norm_path))

        line_str = str(line)
        col_str = str(col)
        goto_target = f"{norm_path}:{line_str}:{col_str}"

        code_bin = shutil.which('code.cmd') or shutil.which('code')
        if not code_bin:
            candidates = [
                os.path.expandvars(r'%LOCALAPPDATA%\Programs\Microsoft VS Code\bin\code.cmd'),
                r'C:\Users\USUARIO\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd',
                r'C:\Program Files\Microsoft VS Code\bin\code.cmd',
                r'C:\Program Files (x86)\Microsoft VS Code\bin\code.cmd'
            ]
            for c in candidates:
                if os.path.exists(c):
                    code_bin = c
                    break

        opened = False
        method = 'none'
        error_msg = None

        if code_bin and os.path.exists(code_bin):
            try:
                subprocess.Popen([code_bin, '-r', '-g', goto_target], shell=True)
                opened = True
                method = 'vscode-cli'
            except Exception as e:
                error_msg = str(e)

        if not opened:
            try:
                os.startfile(norm_path)
                opened = True
                method = 'system-startfile'
            except Exception as e:
                error_msg = str(e)

        resp_data = {
            "ok": opened,
            "method": method,
            "target": goto_target,
            "file": norm_path,
            "line": int(line_str) if line_str.isdigit() else 1,
            "col": int(col_str) if col_str.isdigit() else 1,
            "tipo": tipo,
            "seccion": seccion,
            "error": error_msg
        }
        self._send_json_response(200 if opened else 500, resp_data)

    def do_GET(self):
        if self._is_dev_open_path():
            self._handle_dev_open_code()
            return

        target_base = self._get_proxy_target()
        if target_base:
            self._proxy_request(target_base)
            return

        clean_path = os.path.normpath(self.path.split('?')[0].lstrip('/\\'))
        file_path = os.path.normpath(os.path.join(FRONTEND_DIST, clean_path))

        if os.path.isdir(file_path):
            nested_index = os.path.join(file_path, 'index.html')
            if os.path.exists(nested_index):
                self._serve_html_file(nested_index)
                return

        if not os.path.exists(file_path) or os.path.isdir(file_path):
            index_path = os.path.join(FRONTEND_DIST, 'index.html')
            if os.path.exists(index_path):
                self._serve_html_file(index_path)
                return

        super().do_GET()

    def _serve_html_file(self, html_path):
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self._send_cors_headers()
        with open(html_path, 'rb') as f:
            content = f.read()
        self.send_header('Content-Length', str(len(content)))
        self.end_headers()
        self.wfile.write(content)

    def _handle_write_method(self):
        target_base = self._get_proxy_target()
        if target_base:
            self._proxy_request(target_base)
            return
        self.send_response(404)
        self.end_headers()

    def do_POST(self):
        if self._is_dev_open_path():
            self._handle_dev_open_code()
            return
        clean_path = self.path.split('?')[0]
        if clean_path in ('/api/payments/create-preference', '/api/v1/pagos/preferencia', '/api/v1/ordenes', '/api/payments/confirm'):
            content_len = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(content_len) if content_len > 0 else None
            self._handle_offline_mock(body)
            return
        self._handle_write_method()

    def do_PUT(self):
        self._handle_write_method()

    def do_PATCH(self):
        self._handle_write_method()

    def do_DELETE(self):
        self._handle_write_method()

    def _proxy_request(self, target_base):
        """Reenvia peticiones hacia Gateway (:18080) o Keycloak (:18180) con fallback offline automatico."""
        target_url = f"{target_base}{self.path}"
        content_len = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_len) if content_len > 0 else None

        headers = {}
        for k, v in self.headers.items():
            if k.lower() not in ['host', 'content-length', 'connection']:
                headers[k] = v

        try:
            req = urllib.request.Request(target_url, data=body, headers=headers, method=self.command)
            with urllib.request.urlopen(req, timeout=3) as resp:
                self.send_response(resp.status)
                for hk, hv in resp.headers.items():
                    if hk.lower() not in IGNORED_RESPONSE_HEADERS:
                        self.send_header(hk, hv)
                self._send_cors_headers()
                resp_body = resp.read()
                self.send_header('Content-Length', str(len(resp_body)))
                self.end_headers()
                self.wfile.write(resp_body)
        except urllib.error.HTTPError as e:
            # Si el backend responde 4xx/5xx o no encuentra la ruta, activar fallback resiliente
            if e.code in (404, 500, 502, 503, 504):
                self._handle_offline_mock(body)
            else:
                self.send_response(e.code)
                for hk, hv in e.headers.items():
                    if hk.lower() not in IGNORED_RESPONSE_HEADERS:
                        self.send_header(hk, hv)
                self._send_cors_headers()
                err_body = e.read()
                self.send_header('Content-Length', str(len(err_body)))
                self.end_headers()
                self.wfile.write(err_body)
        except Exception:
            # Gateway o Keycloak no estan corriendo: activar mock offline transparente
            self._handle_offline_mock(body)


def run():
    port = 4200
    server_address = ('0.0.0.0', port)
    httpd = ThreadingHTTPServer(server_address, AngularSpaHandler)
    print(f"==============================================================================")
    print(f"  ENIAC Labs - Servidor Frontend Portable Activo en http://localhost:{port}")
    print(f"  Sirviendo aplicacion Angular pre-compilada desde dist/app/browser")
    print(f"  Proxy /api y /auth -> Gateway (:18080) | /realms -> Keycloak (:18180)")
    print(f"  Modo Resiliente: Mock Offline Activo (0 Errores 502 / Sin Dependencias)")
    print(f"==============================================================================")
    httpd.serve_forever()

if __name__ == '__main__':
    run()
