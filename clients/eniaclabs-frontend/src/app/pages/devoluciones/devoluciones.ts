import { Component, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-devoluciones',
  standalone: true,
  imports: [CommonModule, RouterLink],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-4xl mx-auto space-y-8">

        <!-- Encabezado -->
        <div class="bg-white rounded-3xl p-8 border border-gray-100 shadow-xs">
          <div class="flex flex-wrap items-center justify-between gap-3 mb-4">
            <span class="inline-flex items-center gap-2 px-3 py-1 bg-emerald-600 text-white rounded-full text-xs font-bold uppercase tracking-wider">
              Satisfacción & Garantía
            </span>
            <span class="text-xs text-gray-500 font-medium">Vigencia: Noviembre 2026</span>
          </div>

          <h1 class="text-2xl sm:text-3xl font-black text-gray-900 tracking-tight">
            Políticas de Cambio, Devolución y Garantía Oficial
          </h1>
          <p class="text-sm text-gray-600 mt-2 leading-relaxed">
            En <strong>ENIAC Labs</strong> (RUC 20608945123), nuestro compromiso es brindarte componentes de hardware gamer de la más alta calidad y un respaldo total en caso de requerir un cambio, devolución o soporte de garantía de fábrica.
          </p>
        </div>

        <!-- Contenido de Políticas -->
        <div class="bg-white rounded-3xl p-8 sm:p-10 border border-gray-100 shadow-xs space-y-8 text-sm text-gray-700 leading-relaxed">

          <!-- 1. Plazo para Cambios y Devoluciones -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2 flex items-center gap-2">
              <span class="w-6 h-6 rounded-full bg-blue-100 text-[#256fff] inline-flex items-center justify-center text-xs font-bold">1</span>
              Plazo para Solicitar Cambio o Devolución
            </h2>
            <p>
              El cliente tiene derecho a solicitar el cambio de producto o la devolución de su dinero dentro de un plazo máximo de <strong>hasta siete (7) días calendario</strong> contados a partir de la fecha de entrega del pedido físico.
            </p>
          </section>

          <!-- 2. Requisitos y Condiciones del Producto -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2 flex items-center gap-2">
              <span class="w-6 h-6 rounded-full bg-blue-100 text-[#256fff] inline-flex items-center justify-center text-xs font-bold">2</span>
              Condiciones del Producto para Devolución
            </h2>
            <p>Para admitir la devolución o cambio comercial, el producto debe cumplir obligatoriamente con los siguientes requisitos:</p>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
              <div class="bg-gray-50 p-3.5 rounded-xl border border-gray-200">
                <strong class="text-gray-900 block mb-1">✓ Empaque y Sellos Originales</strong>
                Debe conservar sus cajas, plásticos protectores electrostáticos, manuales, stickers y accesorios completos sin signos de manipulación.
              </div>
              <div class="bg-gray-50 p-3.5 rounded-xl border border-gray-200">
                <strong class="text-gray-900 block mb-1">✓ Comprobante de Pago</strong>
                Presentar la Boleta de Venta o Factura Electrónica emitida por ENIAC Labs al momento de la compra.
              </div>
              <div class="bg-gray-50 p-3.5 rounded-xl border border-gray-200">
                <strong class="text-gray-900 block mb-1">✓ Número de Serie Intacto</strong>
                El número de serie (Serial Number / S/N) debe coincidir con el registro interno de despacho y no mostrar alteraciones.
              </div>
              <div class="bg-gray-50 p-3.5 rounded-xl border border-gray-200">
                <strong class="text-gray-900 block mb-1">✓ Sin Daño Físico Inducido</strong>
                No se aceptan devoluciones de productos con pines doblados, pistas quemadas por mal ensamble, golpes o derrame de líquidos.
              </div>
            </div>
          </section>

          <!-- 3. Procedimiento para Solicitar el Cambio o Devolución -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2 flex items-center gap-2">
              <span class="w-6 h-6 rounded-full bg-blue-100 text-[#256fff] inline-flex items-center justify-center text-xs font-bold">3</span>
              Procedimiento Paso a Paso
            </h2>
            <ol class="list-decimal pl-5 space-y-2 text-gray-600">
              <li><strong>Envío de Solicitud:</strong> Escríbenos a <a href="mailto:soporte@eniaclabs.pe" class="text-[#256fff] underline font-bold">soporte&#64;eniaclabs.pe</a> o vía WhatsApp oficial al <strong>+51 984 512 870</strong> con el asunto: <em>"Solicitud de Devolución - N° de Orden"</em>.</li>
              <li><strong>Adjuntar Evidencia:</strong> Incluye fotografías nítidas del producto por todos sus lados, el número de serie y la boleta/factura electrónica.</li>
              <li><strong>Revisión Técnica:</strong> Nuestro equipo de laboratorio revisará el hardware en un plazo no mayor a 48 horas hábiles para certificar su estado óptimo.</li>
              <li><strong>Resolución:</strong> Se procederá con la entrega del nuevo producto solicitado o el reembolso del importe correspondiente.</li>
            </ol>
          </section>

          <!-- 4. Reembolsos y Tiempos de Extorno Bancario -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2 flex items-center gap-2">
              <span class="w-6 h-6 rounded-full bg-blue-100 text-[#256fff] inline-flex items-center justify-center text-xs font-bold">4</span>
              Tiempos y Métodos de Reembolso
            </h2>
            <p>
              Una vez aprobada la devolución técnica:
            </p>
            <ul class="list-disc pl-5 space-y-1.5 text-gray-600">
              <li><strong>Pagos con Tarjeta vía Culqi:</strong> El extorno se solicita inmediatamente a la pasarela Culqi. El reflejo del saldo en el estado de cuenta depende del banco emisor del cliente (usualmente entre 5 a 15 días hábiles).</li>
              <li><strong>Pagos con Yape:</strong> La devolución se realiza de forma directa al mismo número de celular emisor en un plazo máximo de 24 a 48 horas hábiles.</li>
              <li><strong>Transferencias Directas:</strong> Se transfieren a la cuenta de origen del titular de la compra.</li>
            </ul>
          </section>

          <!-- 5. Garantía de Fábrica (RMA) -->
          <section class="space-y-3">
            <h2 class="text-base sm:text-lg font-black text-gray-900 border-b border-gray-100 pb-2 flex items-center gap-2">
              <span class="w-6 h-6 rounded-full bg-blue-100 text-[#256fff] inline-flex items-center justify-center text-xs font-bold">5</span>
              Garantía por Falla Técnica de Fábrica (RMA)
            </h2>
            <p>
              Si el producto presenta un defecto de fabricación posterior a los 7 días calendario iniciales, entra en vigencia la <strong>Póliza de Garantía Oficial de Fábrica</strong> (12 a 36 meses según fabricante: ASUS, MSI, Gigabyte, AMD, Intel, Corsair, Kingston, etc.).
            </p>
            <p class="text-xs text-gray-500 bg-amber-50 p-3 rounded-xl border border-amber-200">
              La garantía cubre reparación gratuita o reemplazo por una unidad nueva idéntica o de rendimiento superior en caso de agotamiento de stock, conforme al Código de Protección y Defensa del Consumidor de INDECOPI (Ley N° 29571).
            </p>
          </section>

        </div>

        <!-- Botones de navegación inferior -->
        <div class="flex items-center justify-between text-xs font-semibold">
          <a routerLink="/" class="text-[#256fff] hover:underline flex items-center gap-1">
            ← Volver a la Tienda
          </a>
          <div class="flex items-center gap-4">
            <a routerLink="/terminos" class="text-gray-600 hover:text-black">
              Términos y Condiciones →
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
export class DevolucionesPage {}
