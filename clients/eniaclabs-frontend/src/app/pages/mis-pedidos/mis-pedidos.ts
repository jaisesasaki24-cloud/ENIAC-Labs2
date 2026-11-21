import { Component, OnInit, OnDestroy, inject, signal, PLATFORM_ID } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { RouterLink } from '@angular/router';
import { OrderService, OrdenResponse } from '../../services/order.service';
import { AuthService } from '../../services/auth.service';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-mis-pedidos',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-screen bg-gray-50 py-10 px-4 sm:px-6 lg:px-8">
      <div class="max-w-5xl mx-auto space-y-6">
        
        <!-- Header de la página -->
        <div class="bg-white rounded-3xl p-6 sm:p-8 shadow-xs border border-gray-100 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
          <div>
            <div class="inline-flex items-center gap-2 px-3 py-1 bg-black text-white rounded-full text-xs font-bold uppercase tracking-wider mb-2">
              <span>Módulo transaccional</span>
              <span class="opacity-50">|</span>
              <span>pc-orden-ms</span>
              <span class="opacity-50">•</span>
              <span class="text-amber-300">1 Pedido Activo</span>
            </div>
            
            <h1 class="text-2xl sm:text-3xl font-black text-black">
              Seguimiento de Pedidos Gamer
            </h1>

            <p class="text-xs sm:text-sm text-gray-500 mt-1">
              Consulta tu orden, su estado de pago y el desglose de componentes en tiempo real.
            </p>
          </div>

          <a routerLink="/componentes" class="px-5 py-2.5 bg-black hover:bg-[#256fff] text-white text-xs font-bold rounded-full transition-colors flex items-center gap-1.5 shadow-sm shrink-0">
            <span>Explorar Hardware</span>
            <span>&rarr;</span>
          </a>
        </div>

        @if (cargando()) {
          <div class="text-center py-16 bg-white rounded-3xl border border-gray-100">
            <div class="animate-spin w-8 h-8 border-4 border-black border-t-transparent rounded-full mx-auto mb-3"></div>
            <p class="text-xs text-gray-500 font-medium">Consultando microservicio de órdenes...</p>
          </div>
        } @else if (pedidos().length === 0) {
          <div class="text-center py-16 bg-white rounded-3xl border border-gray-100 p-8 space-y-4">
            <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto text-2xl">📦</div>
            <h3 class="text-lg font-bold text-gray-900">Aún no tienes órdenes registradas</h3>
            <p class="text-xs text-gray-500 max-w-sm mx-auto">Agrega tus componentes favoritos al carrito y confirma tu pedido con reserva de inventario en tiempo real.</p>
            <a routerLink="/componentes" class="inline-block px-6 py-2.5 bg-black hover:bg-[#256fff] text-white text-xs font-bold rounded-full transition-colors">
              Ir a la Tienda
            </a>
          </div>
        } @else {
          <div class="space-y-4">
            <!-- Renderiza 1 pedido seleccionado -->
            @for (orden of pedidos(); track orden.id) {
              <div class="bg-white rounded-3xl p-5 sm:p-7 shadow-xs border border-gray-100 transition-all hover:border-gray-300">
                
                <!-- Cabecera de la orden -->
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 pb-4 border-b border-gray-100">
                  <div class="flex items-center gap-3">
                    <span class="w-9 h-9 rounded-2xl bg-black text-white font-bold flex items-center justify-center text-xs">
                      #{{ orden.id }}
                    </span>

                    <div>
                      <div class="font-bold text-sm text-black flex items-center gap-2">
                        <span>Orden {{ orden.codigoOrden || ('ENIAC-' + orden.id) }}</span>
                        <span class="text-[10px] px-2 py-0.5 rounded-full font-mono bg-gray-100 text-gray-600">ACID</span>
                      </div>
                      <div class="text-[11px] text-gray-400 flex items-center gap-2">
                        <span>{{ orden.fechaCreacion }}</span>
                        @if (esMercadoPago(orden)) {
                          <span class="text-[10px] px-2 py-0.5 rounded-full font-bold bg-blue-50 text-[#007ebb] border border-blue-200">
                            ⚡ Mercado Pago
                          </span>
                        }
                      </div>
                    </div>
                  </div>

                  <div class="flex items-center gap-4">
                    @if (orden.estado === 'PENDIENTE' || orden.estado === 'PENDIENTE_PAGO') {
                      <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-amber-50 text-amber-600 border border-amber-200">
                        <span class="w-2 h-2 rounded-full bg-amber-500 animate-pulse"></span>
                        <span>Pendiente de Pago</span>
                      </span>
                    } @else if (orden.estado === 'PAGADA' || orden.estado === 'CONFIRMADA') {
                      <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-50 text-emerald-600 border border-emerald-200">
                        <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                        <span>Pagada (Kafka OK)</span>
                      </span>
                    } @else {
                      <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-red-50 text-red-600 border border-red-200">
                        <span>{{ orden.estado }}</span>
                      </span>
                    }

                    <div class="text-right">
                      <div class="text-[11px] text-gray-400">Total</div>
                      <div class="text-base font-black text-black">
                        S/ {{ orden.total }}
                      </div>
                    </div>

                    <!-- Botón de Despliegue de Componentes -->
                    <button 
                      type="button"
                      (click)="alternarDetalle(orden.id)"
                      class="px-3.5 py-1.5 bg-gray-100 hover:bg-black hover:text-white text-gray-700 text-xs font-semibold rounded-xl transition-colors cursor-pointer"
                    >
                      {{ estaExpandida(orden.id) ? '▲ Ocultar' : '▼ Ver Componentes (' + (orden.detalles.length || 1) + ')' }}
                    </button>
                  </div>
                </div>

                <!-- Detalle expandible (Muchos a Muchos: Orden -> Componentes) -->
                @if (estaExpandida(orden.id)) {
                  <div class="mt-4 pt-3 space-y-3 animate-fadeIn">
                    <div class="flex items-center justify-between">
                      <span class="text-xs font-bold text-gray-800">
                        📦 Componentes Adquiridos (Relación Muchos a Muchos):
                      </span>
                      <span class="text-[11px] text-gray-400 font-normal">Cálculo de IGV (18% Perú)</span>
                    </div>

                    <div class="overflow-x-auto">
                      <table class="w-full text-left text-xs">
                        <thead>
                          <tr class="text-gray-400 border-b border-gray-100 pb-2">
                            <th class="py-2">SKU</th>
                            <th class="py-2">Componente Gamer</th>
                            <th class="py-2 text-center">Cant.</th>
                            <th class="py-2 text-right">Precio Unit.</th>
                            <th class="py-2 text-right">Subtotal</th>
                          </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-50 text-gray-700">
                          @for (det of orden.detalles; track det.id || det.productoId) {
                            <tr>
                              <td class="py-2.5 font-mono text-gray-400">
                                {{ det.sku || 'SKU-' + det.productoId }}
                              </td>
                              <td class="py-2.5 font-medium text-black">
                                {{ det.productoNombre || 'Componente de Hardware' }}
                              </td>
                              <td class="py-2.5 text-center">{{ det.cantidad }}</td>
                              <td class="py-2.5 text-right">S/ {{ det.precioUnitario }}</td>
                              <td class="py-2.5 text-right font-bold text-black">S/ {{ det.subtotalLinea || (det.cantidad * det.precioUnitario) }}</td>
                            </tr>
                          }
                        </tbody>
                        <tfoot>
                          <tr class="border-t border-gray-100 text-gray-500 font-semibold">
                            <td colspan="4" class="py-2 text-right">
                              Subtotal:
                            </td>
                            <td class="py-2 text-right text-black">S/ {{ orden.subtotal }}</td>
                          </tr>
                          <tr class="text-gray-500 font-semibold">
                            <td colspan="4" class="py-1 text-right">
                              IGV (18% Perú):
                            </td>
                            <td class="py-1 text-right text-black">S/ {{ orden.igv }}</td>
                          </tr>
                          <tr class="border-t border-gray-200 text-black font-black text-sm">
                            <td colspan="4" class="py-2 text-right">
                              Total de la Orden:
                            </td>
                            <td class="py-2 text-right text-[#256fff]">S/ {{ orden.total }}</td>
                          </tr>
                        </tfoot>
                      </table>
                    </div>
                  </div>
                }

              </div>
            }
          </div>
        }

      </div>
    </div>
  `
})
export class MisPedidosPage implements OnInit, OnDestroy {
  private orderService = inject(OrderService);
  protected auth = inject(AuthService);
  private toast = inject(ToastService);
  private platformId = inject(PLATFORM_ID);

  pedidos = signal<OrdenResponse[]>([]);
  cargando = signal<boolean>(true);
  ordenesExpandidas = signal<Set<number>>(new Set());
  private timer?: ReturnType<typeof setInterval>;

  ngOnInit() {
    if (isPlatformBrowser(this.platformId)) {
      this.cargar();
      this.timer = setInterval(() => this.cargar(false), 5000);
    } else {
      this.cargando.set(false);
    }
  }

  ngOnDestroy() {
    if (this.timer) clearInterval(this.timer);
  }

  cargar(showSpinner = true) {
    if (showSpinner) this.cargando.set(true);
    this.orderService.listarOrdenes().subscribe({
      next: (data) => {
        // Muestra únicamente 1 pedido como fue solicitado
        if (data && data.length > 0) {
          const unicaOrden = data[data.length - 1];
          this.pedidos.set([unicaOrden]);
          this.ordenesExpandidas.set(new Set([unicaOrden.id]));
        } else {
          this.pedidos.set([]);
        }
        this.cargando.set(false);
      },
      error: () => this.cargando.set(false)
    });
  }

  alternarDetalle(id: number) {
    this.ordenesExpandidas.update(set => {
      const nuevo = new Set(set);
      if (nuevo.has(id)) nuevo.delete(id);
      else nuevo.add(id);
      return nuevo;
    });
  }

  estaExpandida(id: number): boolean {
    return this.ordenesExpandidas().has(id);
  }

  esMercadoPago(orden: any): boolean {
    return !!(orden && orden.metodoPago && String(orden.metodoPago).includes('MERCADO_PAGO'));
  }
}
