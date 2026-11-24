import { Component, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-terminos',
  standalone: true,
  imports: [CommonModule, RouterLink],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-4xl mx-auto space-y-8">

        <!-- Encabezado -->
        <div class="bg-white rounded-3xl p-8 border border-gray-100 shadow-xs">
          <div class="flex flex-wrap items-center justify-between gap-3 mb-4">
            <span class="inline-flex items-center gap-2 px-3 py-1 bg-black text-white rounded-full text-xs font-bold uppercase tracking-wider">
              Marco Legal y Regulatorio
            </span>
            <span class="text-xs text-gray-500 font-medium">Última actualización: Noviembre 2026</span>
          </div>

          <h1 class="text-2xl sm:text-3xl font-black text-gray-900 tracking-tight">
            Términos y Condiciones Generales de Uso y Contratación
          </h1>
          <p class="text-sm text-gray-600 mt-2 leading-relaxed">
            Bienvenido a <strong>ENIAC Labs</strong>. Este documento describe los términos y condiciones aplicables al acceso, navegación y transacciones comerciales electrónicas realizadas a través del sitio web oficial.
          </p>
        </div>

        <!-- Cuerpo del documento -->
        <div class="bg-white rounded-3xl p-8 sm:p-10 border border-gray-100 shadow-xs space-y-8 text-sm text-gray-700 leading-relaxed">

          <!-- 1. Identificación de la Empresa -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2">
              1. Identificación del Titular del Comercio
            </h2>
            <p>
              El presente sitio de comercio electrónico es operado bajo la titularidad de:
            </p>
            <div class="bg-gray-50 rounded-2xl p-4 border border-gray-200/70 grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
              <div><strong class="text-gray-900">Razón Social:</strong> ENIAC LABS E.I.R.L.</div>
              <div><strong class="text-gray-900">RUC:</strong> 20608945123</div>
              <div><strong class="text-gray-900">Domicilio Legal:</strong> Av. José Larco 743, Of. 502, Miraflores, Lima - Perú</div>
              <div><strong class="text-gray-900">Correo Electrónico:</strong> ventas&#64;eniaclabs.pe / soporte&#64;eniaclabs.pe</div>
              <div><strong class="text-gray-900">Teléfono Central:</strong> (01) 480-9200 / +51 984 512 870</div>
              <div><strong class="text-gray-900">Actividad Principal:</strong> Venta y comercialización de componentes de hardware informático, periféricos y ensamble de estaciones de trabajo.</div>
            </div>
          </section>

          <!-- 2. Aceptación de los Términos -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2">
              2. Aceptación de los Términos y Capacidad Legal
            </h2>
            <p>
              Al navegar en este portal o completar una orden de compra, el usuario declara haber leído, comprendido y aceptado en su totalidad los presentes Términos y Condiciones, así como nuestras Políticas de Privacidad y Devoluciones. 
            </p>
            <p>
              Los servicios y productos sólo están disponibles para personas que tengan capacidad legal para contratar según las leyes de la República del Perú.
            </p>
          </section>

          <!-- 3. Precios, Moneda y Facturación -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2">
              3. Precios, Moneda y Comprobantes de Pago
            </h2>
            <ul class="list-disc pl-5 space-y-1.5 text-gray-600">
              <li>Todos los precios mostrados en el catálogo web están expresados en <strong>Soles Peruanos (PEN / S/)</strong> e incluyen el Impuesto General a las Ventas (<strong>IGV 18%</strong>) conforme a la legislación tributaria peruana vigente (SUNAT).</li>
              <li>ENIAC Labs emite <strong>Boleta de Venta Electrónica</strong> o <strong>Factura Electrónica</strong> según lo solicite el cliente durante el checkout, requiriendo para ello DNI o RUC válido.</li>
              <li>Los precios y ofertas son válidos exclusivamente para compras concretadas a través de la plataforma web en tiempo real.</li>
            </ul>
          </section>

          <!-- 4. Pasarela de Pago y Seguridad -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2">
              4. Medios de Pago y Seguridad en Transacciones
            </h2>
            <p>
              Para garantizar transacciones 100% seguras y cifradas bajo el estándar internacional PCI-DSS Nivel 1, los pagos se procesan a través de las pasarelas oficiales autorizadas:
            </p>
            <ul class="list-disc pl-5 space-y-1.5 text-gray-600">
              <li><strong>Culqi Checkout v4:</strong> Pagos con tarjetas de débito/crédito (Visa, Mastercard, American Express, Diners Club) y código de aprobación Yape.</li>
              <li><strong>Mercado Pago:</strong> Checkout Pro para procesamiento seguro y transferencias bancarias.</li>
            </ul>
            <p class="text-xs text-gray-500 bg-blue-50 p-3 rounded-xl border border-blue-100">
              ENIAC Labs no almacena números de tarjeta de crédito, CVV ni contraseñas bancarias en sus servidores; toda la autenticación financiera es procesada de extremo a extremo por las pasarelas certificadas.
            </p>
          </section>

          <!-- 5. Envíos y Plazos de Entrega -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2">
              5. Despacho, Envíos y Plazos de Entrega
            </h2>
            <p>
              Realizamos envíos a nivel nacional con empaque de alta seguridad electrostática y seguro de carga:
            </p>
            <ul class="list-disc pl-5 space-y-1.5 text-gray-600">
              <li><strong>Lima Metropolitana:</strong> Entrega estándar en 24 a 48 horas hábiles tras la confirmación del pago.</li>
              <li><strong>Provincias y Nivel Nacional:</strong> Entrega en 48 a 72 horas hábiles a través de operadores logísticos certificados (Olva Courier / Shalom) con número de seguimiento en tiempo real.</li>
            </ul>
          </section>

          <!-- 6. Garantía de Productos -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2">
              6. Garantía Oficial de Hardware
            </h2>
            <p>
              Todos los componentes comercializados son 100% nuevos, sellados de fábrica y cuentan con garantía oficial de marca de <strong>12 a 36 meses</strong> contra defectos de fabricación.
            </p>
          </section>

          <!-- 7. Ley Aplicable y Jurisdicción -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2">
              7. Ley Aplicable y Solución de Controversias
            </h2>
            <p>
              Estos términos se rigen por las leyes de la República del Perú. Para la resolución de cualquier controversia o reclamo, las partes se someten a la competencia de los jueces y tribunales del Distrito Judicial de Lima, Perú, sin perjuicio de las competencias administrativas que correspondan al <strong>INDECOPI</strong>.
            </p>
          </section>

        </div>

        <!-- Botones de navegación inferior -->
        <div class="flex items-center justify-between text-xs font-semibold">
          <a routerLink="/" class="text-[#256fff] hover:underline flex items-center gap-1">
            ← Volver a la Tienda
          </a>
          <div class="flex items-center gap-4">
            <a routerLink="/devoluciones" class="text-gray-600 hover:text-black">
              Políticas de Devolución →
            </a>
            <a routerLink="/libro-de-reclamaciones" class="text-gray-600 hover:text-black">
              Libro de Reclamaciones →
            </a>
          </div>
        </div>

      </div>
    </div>
  `
})
export class TerminosPage {}
