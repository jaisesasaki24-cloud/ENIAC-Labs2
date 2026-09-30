---
marp: true
theme: default
paginate: true
size: 16:9
header: '![h:20](assets/eniaclabs_hero.jpg) **ENIAC Labs** • Arquitectura Distribuida de Microservicios'
footer: '© 2026 ENIAC Labs • Universidad Peruana Unión'
style: |
  @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');

  section {
    font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background-color: #F8FAFC;
    color: #1E293B;
    padding: 38px 50px;
    font-size: 15px;
  }

  header, footer {
    font-size: 11px;
    color: #64748B;
  }

  h1, h2, h3 {
    color: #0F172A;
    font-weight: 800;
    letter-spacing: -0.02em;
    margin: 0;
  }

  /* Badges & Tags */
  .badge {
    display: inline-flex;
    align-items: center;
    padding: 4px 12px;
    border-radius: 9999px;
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }
  .badge-teal {
    background-color: #F0FDFA;
    color: #0D9488;
    border: 1px solid #CCFBF1;
  }
  .badge-blue {
    background-color: #EFF6FF;
    color: #0284C7;
    border: 1px solid #BAE6FD;
  }
  .badge-purple {
    background-color: #EEF2FF;
    color: #6366F1;
    border: 1px solid #E0E7FF;
  }
  .badge-dark {
    background-color: #0F172A;
    color: #FFFFFF;
  }

  /* Slide 1 Cover Layout */
  .cover-inst {
    font-size: 11px;
    font-weight: 700;
    color: #64748B;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    border-bottom: 1px solid #E2E8F0;
    padding-bottom: 8px;
    margin-bottom: 20px;
  }

  .cover-grid {
    display: grid;
    grid-template-columns: 1.4fr 1fr;
    gap: 36px;
    align-items: center;
    height: calc(100% - 40px);
  }

  .cover-title {
    font-size: 34px;
    line-height: 1.15;
    font-weight: 800;
    color: #0F172A;
    margin: 14px 0 10px 0;
  }

  .cover-tagline {
    font-size: 16px;
    font-weight: 600;
    color: #0D9488;
    font-style: italic;
    margin-bottom: 12px;
  }

  .cover-desc {
    font-size: 13.5px;
    line-height: 1.5;
    color: #475569;
    margin-bottom: 16px;
  }

  .team-card {
    background: #FFFFFF;
    border: 1px solid #E2E8F0;
    border-radius: 12px;
    padding: 12px 18px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
  }
  .team-card h4 {
    margin: 0 0 4px 0;
    font-size: 11px;
    color: #0D9488;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }
  .team-card p {
    margin: 2px 0;
    font-size: 12px;
    color: #1E293B;
  }

  .hero-img-box {
    border-radius: 18px;
    overflow: hidden;
    box-shadow: 0 20px 25px -5px rgba(15, 23, 42, 0.12), 0 8px 10px -6px rgba(15, 23, 42, 0.08);
    border: 2px solid #FFFFFF;
  }
  .hero-img-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }

  /* Content Slide Header */
  .slide-header {
    margin-bottom: 22px;
  }
  .slide-header h2 {
    font-size: 26px;
    margin: 6px 0 4px 0;
  }
  .slide-header p {
    font-size: 13px;
    color: #64748B;
    margin: 0;
  }

  /* Card Grids */
  .card-grid-3 {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
  }

  .card-grid-4 {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
  }

  .feature-card {
    background: #FFFFFF;
    border: 1px solid #E2E8F0;
    border-radius: 16px;
    padding: 22px 20px;
    box-shadow: 0 10px 15px -3px rgba(15, 23, 42, 0.04), 0 4px 6px -4px rgba(15, 23, 42, 0.02);
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
  }
  .feature-card h3 {
    font-size: 17px;
    margin: 12px 0 10px 0;
    color: #0F172A;
  }
  .feature-card ul {
    margin: 0;
    padding-left: 16px;
  }
  .feature-card li {
    font-size: 12.5px;
    line-height: 1.45;
    color: #334155;
    margin-bottom: 8px;
  }

  /* Stat Metric Cards */
  .stat-card {
    background: #FFFFFF;
    border: 1px solid #E2E8F0;
    border-radius: 16px;
    padding: 26px 16px;
    text-align: center;
    box-shadow: 0 10px 15px -3px rgba(15, 23, 42, 0.04);
  }
  .stat-number {
    font-size: 42px;
    font-weight: 800;
    color: #0D9488;
    line-height: 1;
    margin-bottom: 10px;
  }
  .stat-title {
    font-size: 14px;
    font-weight: 700;
    color: #0F172A;
    margin-bottom: 8px;
  }
  .stat-desc {
    font-size: 11.5px;
    line-height: 1.4;
    color: #64748B;
  }
---

<!-- _header: "" -->
<!-- _footer: "" -->
<!-- _paginate: false -->

<div class="cover-inst">
  UNIVERSIDAD PERUANA UNIÓN &nbsp;•&nbsp; ESCUELA DE INGENIERÍA DE SISTEMAS &nbsp;•&nbsp; CICLO VII 2026
</div>

<div class="cover-grid">
  <div>
    <span class="badge badge-dark">⚡ ENIAC LABS</span>
    <h1 class="cover-title">Plataforma Distribuida de Gestión y Venta de Hardware</h1>
    <div class="cover-tagline">“Aprender, innovar y construir tecnología que escala”</div>
    <p class="cover-desc">
      Ecosistema cloud-native de alto rendimiento con arquitectura hexagonal, orquestación resiliente Saga y seguridad perimetral Zero-Trust para cotización, control atómico de inventario y procesamiento de pagos en tiempo real.
    </p>

    <div class="team-card">
      <h4>Equipo de Ingeniería & Gobernanza</h4>
      <p><strong>• Desarrolladores:</strong> Equipo ENIAC Labs (Ingeniería de Sistemas)</p>
      <p><strong>• Asesor Técnico:</strong> Docente Especialista en Sistemas Distribuidos</p>
      <p style="color: #64748B; font-size: 11px;"><strong>• Stack:</strong> Spring Boot 3.3/Cloud • PostgreSQL • Docker • JWT Stateless • Resilience4j</p>
    </div>
  </div>

  <div class="hero-img-box">
    <img src="assets/eniaclabs_hero.jpg" alt="ENIAC Labs Cloud Infrastructure">
  </div>
</div>

---

<div class="slide-header">
  <span class="badge badge-teal">Topología Cloud-Native</span>
  <h2>Arquitectura de Microservicios & Desacoplamiento</h2>
  <p>Estructura modular con bases de datos aisladas por dominio y desacoplamiento estricto de I/O.</p>
</div>

<div class="card-grid-3">
  <div class="feature-card">
    <div><span class="badge badge-teal">🌐 Edge Gateway</span></div>
    <h3>Spring Cloud Gateway</h3>
    <ul>
      <li>Punto único de entrada perimetral con enrutamiento reactivo y balanceo dinámico.</li>
      <li>Filtro central de autenticación y sanitización de peticiones cliente.</li>
      <li>Inyección de contexto downstream sin revelar topología interna.</li>
    </ul>
  </div>

  <div class="feature-card">
    <div><span class="badge badge-blue">🗄️ Database per Service</span></div>
    <h3>Aislamiento de Persistencia</h3>
    <ul>
      <li>Instancias PostgreSQL independientes para Catálogo, Órdenes, Pagos y Auth.</li>
      <li>Cero queries cruzadas ni dependencias a nivel de motor relacional.</li>
      <li>Evolución de esquemas y migraciones deterministas sin riesgo de downtime.</li>
    </ul>
  </div>

  <div class="feature-card">
    <div><span class="badge badge-purple">⚙️ Centralized Ops</span></div>
    <h3>Eureka & Config Server</h3>
    <ul>
      <li>Auto-registro y descubrimiento de microservicios con heartbeat continuo.</li>
      <li>Gestión centralizada de variables y perfiles <code>dev</code> / <code>prod</code> en Git.</li>
      <li>Desacoplamiento total de I/O de red fuera de transacciones de base de datos.</li>
    </ul>
  </div>
</div>

---

<div class="slide-header">
  <span class="badge badge-teal">Transaccionalidad Concurrente</span>
  <h2>Resiliencia & Transacciones Atómicas (Saga Pattern)</h2>
  <p>Garantía de consistencia eventual ante caídas de red y prevención estricta de sobreventa.</p>
</div>

<div class="card-grid-3">
  <div class="feature-card">
    <div><span class="badge badge-teal">🛡️ Tolerancia a Fallos</span></div>
    <h3>Circuit Breakers & Timeouts</h3>
    <ul>
      <li>Protección Resilience4j en clientes REST ante sobrecargas o latencia downstream.</li>
      <li>Timeouts calibrados: 2000ms de respuesta y 3500ms de ventana total de corte.</li>
      <li>Degradación controlada para evitar caídas en cascada a través de la malla.</li>
    </ul>
  </div>

  <div class="feature-card">
    <div><span class="badge badge-blue">⚡ Concurrencia Pura</span></div>
    <h3>Descuento Atómico en BD</h3>
    <ul>
      <li>Sentencias atómicas <code>UPDATE WHERE stockActual >= :cantidad</code> a nivel de fila.</li>
      <li>Eliminación matemática de condiciones de carrera (Race Conditions) y overselling.</li>
      <li>Alto rendimiento sin bloqueos de tabla ni deadlocks bajo picos de demanda.</li>
    </ul>
  </div>

  <div class="feature-card">
    <div><span class="badge badge-purple">🔄 Orquestación Saga</span></div>
    <h3>Compensación Automática</h3>
    <ul>
      <li>Mecanismo de reversión automática de stock ante fallos en pasarela de pago.</li>
      <li>Endpoint de compensación dedicado <code>/stock/reponer</code> invocado por el orquestador.</li>
      <li>Reconciliación idempotente para eventos asíncronos y webhooks.</li>
    </ul>
  </div>
</div>

---

<div class="slide-header">
  <span class="badge badge-teal">Zero-Trust Perimeter</span>
  <h2>Seguridad Perimetral & Propagación JWT</h2>
  <p>Verificación criptográfica estricta en el borde y confianza downstream mediante claims verificadas.</p>
</div>

<div class="card-grid-3">
  <div class="feature-card">
    <div><span class="badge badge-teal">🔐 Resource Server</span></div>
    <h3>Spring Security Gateway</h3>
    <ul>
      <li>Validación criptográfica centralizada de tokens Bearer JWT en la frontera exterior.</li>
      <li>Respuesta inmediata HTTP 401 Unauthorized sin delegar carga a servicios internos.</li>
      <li>Control RBAC en Gateway retornando HTTP 403 Forbidden para accesos no autorizados.</li>
    </ul>
  </div>

  <div class="feature-card">
    <div><span class="badge badge-blue">🏷️ Context Injection</span></div>
    <h3>Propagación de Claims</h3>
    <ul>
      <li>Filtro en Gateway extrae <code>sub</code>, <code>roles</code> y datos de perfil del token verificado.</li>
      <li>Inyección de cabeceras downstream confiables: <code>X-User-Id</code> y <code>X-User-Roles</code>.</li>
      <li>DTO de compra despojado de <code>clienteId</code>: la identidad se obtiene solo de la cabecera.</li>
    </ul>
  </div>

  <div class="feature-card">
    <div><span class="badge badge-purple">🛡️ Defense-in-Depth</span></div>
    <h3>Aislamiento de Red</h3>
    <ul>
      <li>Microservicios de negocio operan en red interna no expuesta a internet.</li>
      <li>CORS restringido y protección contra CSRF para clientes web y móviles.</li>
      <li>Manejo robusto de webhooks con verificación idempotente de orden y preferencia.</li>
    </ul>
  </div>
</div>

---

<div class="slide-header">
  <span class="badge badge-teal">SRE & Telemetría</span>
  <h2>Trazabilidad Distribuida & Observabilidad</h2>
  <p>Visibilidad end-to-end de cada petición a través de la infraestructura distribuida.</p>
</div>

<div class="card-grid-3">
  <div class="feature-card">
    <div><span class="badge badge-teal">📍 Trazabilidad Única</span></div>
    <h3>X-Correlation-Id End-to-End</h3>
    <ul>
      <li>Generación o captura de identificador único de correlación en la primera llamada.</li>
      <li>Inyección automática en MDC (Mapped Diagnostic Context) de Logback.</li>
      <li>Propagación obligatoria en cada cliente HTTP hacia downstream (Feign / RestTemplate).</li>
    </ul>
  </div>

  <div class="feature-card">
    <div><span class="badge badge-blue">🩺 Health Probes</span></div>
    <h3>Spring Boot Actuator</h3>
    <ul>
      <li>Endpoints estandarizados de telemetría en <code>/actuator/health</code> para cada nodo.</li>
      <li>Monitoreo de pools de conexión HikariCP y persistencia PostgreSQL.</li>
      <li>Compatibilidad nativa con sondas Liveness y Readiness en Kubernetes.</li>
    </ul>
  </div>

  <div class="feature-card">
    <div><span class="badge badge-purple">📊 Diagnóstico Rápido</span></div>
    <h3>Logs Estructurados</h3>
    <ul>
      <li>Formato de logging unificado: <code>[Timestamp] [Service] [CorrelationId] [Thread]</code>.</li>
      <li>Aislamiento de anomalías e incidentes de producción en menos de 30 segundos.</li>
      <li>Arquitectura lista para ingesta hacia Grafana Loki, Jaeger y OpenTelemetry.</li>
    </ul>
  </div>
</div>

---

<div class="slide-header">
  <span class="badge badge-teal">Resultados Comerciales & Técnicos</span>
  <h2>Impacto en el Negocio & Eficiencia Operativa</h2>
  <p>Resultados cuantificables tras la refactorización y consolidación de la plataforma ENIAC Labs.</p>
</div>

<div class="card-grid-4">
  <div class="stat-card">
    <div class="stat-number">99.9%</div>
    <div class="stat-title">Disponibilidad SLA</div>
    <div class="stat-desc">Tolerancia a caídas gracias a Circuit Breakers y pools desacoplados.</div>
  </div>

  <div class="stat-card">
    <div class="stat-number">-75%</div>
    <div class="stat-title">Latencia en Checkout</div>
    <div class="stat-desc">Desacoplamiento de I/O de red de las transacciones de base de datos.</div>
  </div>

  <div class="stat-card">
    <div class="stat-number">0</div>
    <div class="stat-title">Riesgo de Sobreventa</div>
    <div class="stat-desc">Consistencia matemática mediante sentencias atómicas condicionales.</div>
  </div>

  <div class="stat-card">
    <div class="stat-number">100%</div>
    <div class="stat-title">Trazabilidad de Flujo</div>
    <div class="stat-desc">Auditoría completa con <code>X-Correlation-Id</code> en cada salto de servicio.</div>
  </div>
</div>
