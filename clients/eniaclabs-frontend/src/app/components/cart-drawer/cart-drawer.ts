import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { CartService } from '../../services/cart.service';
import { ToastService } from '../../services/toast.service';
import { OrderService } from '../../services/order.service';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-cart-drawer',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, FormsModule],
  template: `
    @if (cart.isCartOpen()) {
      <!-- Backdrop Button for accessible closing -->
      <button 
        type="button"
        (click)="cart.closeCart()" 
        class="fixed inset-0 w-full h-full bg-black/50 backdrop-blur-sm z-50 transition-opacity animate-fadeIn cursor-default border-none p-0 m-0"
        aria-label="Cerrar carrito"
      ></button>

      <!-- Drawer Content -->
      <div class="fixed top-0 right-0 h-full w-full max-w-md bg-white z-50 shadow-2xl flex flex-col justify-between animate-slideLeft">
        
        <!-- Header -->
        <div class="p-5 border-b border-gray-100 flex items-center justify-between">
          <div class="flex items-center gap-2">
            <svg class="w-5 h-5 text-black" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
            <h3 class="font-bold text-lg text-black">
              Mi Carrito ({{ cart.itemCount() }})
            </h3>
          </div>

          <button 
            type="button"
            (click)="cart.closeCart()" 
            class="p-2 text-gray-400 hover:text-black rounded-full hover:bg-gray-100 transition-colors"
            aria-label="Cerrar carrito"
          >
            ✕
          </button>
        </div>

        <!-- Free shipping alert -->
        <div class="bg-[#f0f9eb] px-5 py-2.5 border-b border-[#e1f3d8] flex items-center gap-2 text-xs text-[#67c23a] font-medium">
          <svg class="w-4 h-4 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
          <span>¡Felicidades! Tienes <strong>Envío Gratis</strong> para esta orden oficial.</span>
        </div>

        <!-- Items list -->
        <div class="flex-1 overflow-y-auto p-5 space-y-4">
          @if (cart.items().length === 0) {
            <div class="py-16 text-center text-gray-500 space-y-3">
              <svg class="w-16 h-16 mx-auto text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
              <p class="font-medium text-base text-gray-800">Tu carrito está vacío</p>
              <p class="text-xs text-gray-400">Descubre nuestros componentes de computadora y ofertas oficiales de hardware.</p>
              <button 
                type="button"
                (click)="cart.closeCart()"
                class="mt-4 px-6 py-2.5 bg-black text-white text-xs font-semibold rounded-full hover:bg-[#256fff] transition-colors"
              >
                Ir a comprar
              </button>
            </div>
          } @else {
            @for (item of cart.items(); track item.id + item.color) {
              <div class="flex gap-4 p-3 rounded-2xl bg-gray-50 border border-gray-100 relative group">
                <img [src]="item.image" [alt]="item.name" class="w-20 h-20 object-contain bg-white rounded-xl p-1" />
                
                <div class="flex-1 min-w-0">
                  <div class="flex items-start justify-between">
                    <div>
                      <h4 class="font-bold text-sm text-gray-900 truncate">{{ item.name }}</h4>
                      <p class="text-xs text-gray-500">{{ item.color }} @if (item.storage) { • {{ item.storage }} }</p>
                    </div>
                    <button 
                      type="button"
                      (click)="cart.removeItem(item.id, item.color)" 
                      class="text-gray-400 hover:text-red-500 p-1 transition-colors"
                      title="Eliminar"
                      aria-label="Eliminar producto"
                    >
                      🗑️
                    </button>
                  </div>

                  <div class="mt-3 flex items-center justify-between">
                    <div class="flex items-center border border-gray-200 bg-white rounded-full">
                      <button 
                        type="button"
                        (click)="cart.updateQuantity(item.id, item.color, -1)" 
                        class="w-7 h-7 flex items-center justify-center text-gray-600 hover:text-black font-bold"
                        aria-label="Disminuir cantidad"
                      >
                        -
                      </button>
                      <span class="w-7 text-center text-xs font-bold text-black">{{ item.quantity }}</span>
                      <button 
                        type="button"
                        (click)="cart.updateQuantity(item.id, item.color, 1)" 
                        class="w-7 h-7 flex items-center justify-center text-gray-600 hover:text-black font-bold"
                        aria-label="Aumentar cantidad"
                      >
                        +
                      </button>
                    </div>

                    <div class="text-right">
                      <div class="font-bold text-sm text-black">
                        S/ {{ (item.price * item.quantity) | number:'1.0-0' }}
                      </div>
                      @if (item.originalPrice) {
                        <div class="text-[11px] text-gray-400 line-through">
                          S/ {{ (item.originalPrice * item.quantity) | number:'1.0-0' }}
                        </div>
                      }
                    </div>
                  </div>
                </div>
              </div>
            }
          }
        </div>

        <!-- Footer / Checkout Area -->
        @if (cart.items().length > 0) {
          <div class="p-5 border-t border-gray-100 bg-white space-y-4">
            
            <!-- Coupon Code Section -->
            <div class="space-y-1">
              <div class="flex gap-2">
                <input 
                  type="text" 
                  [(ngModel)]="couponInput"
                  placeholder="Código de cupón (Ej. APEALL35)"
                  class="flex-1 px-3 py-2 text-xs uppercase bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:border-black"
                  aria-label="Código de cupón"
                />
                <button 
                  type="button"
                  (click)="onApplyCoupon()"
                  class="px-4 py-2 bg-gray-200 hover:bg-black hover:text-white text-gray-800 text-xs font-semibold rounded-xl transition-colors"
                >
                  Aplicar
                </button>
              </div>

              @if (cart.appliedCoupon()) {
                <div class="flex items-center justify-between text-[11px] text-[#256fff] font-medium pt-1 px-1">
                  <span>✓ Cupón <strong>{{ cart.appliedCoupon() }}</strong> aplicado ({{ cart.couponDiscountPercent() }}% desc.)</span>
                  <button type="button" (click)="cart.removeCoupon()" class="text-red-500 hover:underline">Quitar</button>
                </div>
              }
            </div>

            <!-- Price Breakdown -->
            <div class="space-y-1.5 text-xs text-gray-600 pt-2 border-t border-gray-100">
              <div class="flex justify-between">
                <span>Subtotal:</span>
                <span class="font-semibold text-gray-900">S/ {{ cart.subtotal() | number:'1.0-0' }}</span>
              </div>
              
              @if (cart.discountAmount() > 0) {
                <div class="flex justify-between text-[#eb1406]">
                  <span>Descuento de temporada:</span>
                  <span class="font-semibold">-S/ {{ cart.discountAmount() | number:'1.0-0' }}</span>
                </div>
              }

              <div class="flex justify-between">
                <span>Costo de envío:</span>
                <span class="text-[#67c23a] font-semibold">GRATIS</span>
              </div>

              <div class="flex justify-between text-base font-bold text-black pt-2 border-t border-gray-100">
                <span>Total a pagar:</span>
                <span class="text-lg">S/ {{ cart.total() | number:'1.0-0' }}</span>
              </div>

              <div class="text-[11px] text-gray-500 text-right">
                O hasta 12 cuotas sin intereses de <strong>S/ {{ cart.installment12() }}</strong>
              </div>
            </div>

            <!-- Checkout Button -->
            <button 
              type="button"
              (click)="onCheckout()"
              class="w-full py-3.5 bg-black hover:bg-[#256fff] text-white font-bold text-sm rounded-full transition-all duration-300 shadow-md flex items-center justify-center gap-2"
            >
              <span>Pagar y finalizar compra</span>
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
            </button>

          </div>
        }

      </div>
    }

    <!-- Checkout Modal simulation -->
    @if (isCheckoutModalOpen()) {
      <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-fadeIn">
        <div class="bg-white rounded-3xl max-w-lg w-full p-6 sm:p-8 relative shadow-2xl border border-gray-100 animate-scaleUp">
          
          <button type="button" (click)="isCheckoutModalOpen.set(false)" class="absolute top-5 right-5 text-gray-400 hover:text-black p-1 text-xl font-bold" aria-label="Cerrar modal">
            ✕
          </button>

          <div class="flex items-center gap-3 mb-6">
            <div class="w-10 h-10 bg-green-50 text-green-600 rounded-full flex items-center justify-center font-bold">
              ✓
            </div>
            <div>
              <h3 class="text-xl font-bold text-gray-900">Finalizar Compra</h3>
              <p class="text-xs text-gray-500">Tienda Oficial de Componentes de PC - Pago seguro con cifrado bancario</p>
            </div>
          </div>

          <div class="space-y-4 text-xs">
            <div class="p-3.5 bg-gray-50 rounded-xl space-y-1">
              <div class="font-bold text-gray-800">Resumen del Pedido:</div>
              <div class="flex justify-between text-gray-600">
                <span>{{ cart.itemCount() }} artículo(s)</span>
                <span class="font-bold text-black">S/ {{ cart.total() | number:'1.0-0' }}</span>
              </div>
              <div class="text-[#256fff] font-medium">12 cuotas sin intereses de S/ {{ cart.installment12() }} / mes</div>
            </div>

            <div>
              <label for="buyerName" class="block font-bold text-gray-700 mb-1">Nombre completo:</label>
              <input id="buyerName" type="text" value="Juan Pérez" class="w-full px-3 py-2 border rounded-xl text-xs bg-white focus:outline-none focus:border-black" />
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div>
                <label for="buyerDoc" class="block font-bold text-gray-700 mb-1">DNI / RUC:</label>
                <input id="buyerDoc" type="text" value="72849102" class="w-full px-3 py-2 border rounded-xl text-xs bg-white focus:outline-none focus:border-black" />
              </div>
              <div>
                <label for="buyerPhone" class="block font-bold text-gray-700 mb-1">Teléfono:</label>
                <input id="buyerPhone" type="text" value="987 654 321" class="w-full px-3 py-2 border rounded-xl text-xs bg-white focus:outline-none focus:border-black" />
              </div>
            </div>

            <div>
              <label for="buyerAddress" class="block font-bold text-gray-700 mb-1">Dirección de entrega (Lima y Provincias):</label>
              <input id="buyerAddress" type="text" value="Av. Javier Prado Este 4200, Santiago de Surco, Lima" class="w-full px-3 py-2 border rounded-xl text-xs bg-white focus:outline-none focus:border-black" />
            </div>

            <div class="p-3 bg-blue-50 text-[#256fff] rounded-xl flex items-center gap-2">
              <span class="text-base">💳</span>
              <span>Aceptamos Visa, Mastercard, Diners, American Express y transferencias BCP/BBVA.</span>
            </div>

            <button 
              type="button"
              (click)="confirmOrder()"
              class="w-full py-3.5 bg-black hover:bg-[#256fff] text-white font-bold text-sm rounded-full transition-colors shadow-md mt-4"
            >
              Confirmar pedido y pagar S/ {{ cart.total() | number:'1.0-0' }}
            </button>
          </div>

        </div>
      </div>
    }
  `,
  styles: [`
    @keyframes slideLeft {
      from { transform: translateX(100%); }
      to { transform: translateX(0); }
    }
    .animate-slideLeft {
      animation: slideLeft 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    .animate-fadeIn {
      animation: fadeIn 0.2s ease forwards;
    }
    @keyframes scaleUp {
      from { opacity: 0; transform: scale(0.95); }
      to { opacity: 1; transform: scale(1); }
    }
    .animate-scaleUp {
      animation: scaleUp 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
  `]
})
export class CartDrawerComponent {
  cart = inject(CartService);
  toast = inject(ToastService);
  orderService = inject(OrderService);
  auth = inject(AuthService);

  private router = inject(Router);

  couponInput = 'APEALL35';
  isCheckoutModalOpen = signal<boolean>(false);

  onApplyCoupon() {
    if (this.cart.applyCoupon(this.couponInput)) {
      this.toast.show('¡Cupón aplicado exitosamente! (8% desc.)');
    } else {
      this.toast.show('Cupón inválido o expirado');
    }
  }

  onCheckout() {
    this.cart.closeCart();
    this.router.navigate(['/pagar']);
  }

  confirmOrder() {
    const items = this.cart.items();
    if (items.length === 0) return;

    const username = this.auth.currentUser() || 'Cliente Gamer';

    // Map cart items to backend DTO
    const orderItems = items.map(item => {
      let prodId = 2;
      let sku = 'INT-14700K';
      const n = item.name.toLowerCase();
      if (n.includes('4080')) { prodId = 3; sku = 'NV-RTX4080S'; }
      else if (n.includes('4070')) { prodId = 4; sku = 'NV-RTX4070S'; }
      else if (n.includes('7800') || n.includes('ryzen')) { prodId = 5; sku = 'AMD-7800X3D'; }

      return {
        productoId: prodId,
        sku: sku,
        productoNombre: item.name,
        precioUnitario: item.price,
        cantidad: item.quantity
      };
    });

    const payload = {
      clienteId: 1,
      clienteNombre: username,
      clienteEmail: `${username.toLowerCase().replace(/\s+/g, '')}@eniaclabs.pe`,
      metodoPago: 'YAPE_PLIN',
      direccionEnvio: 'Av. Las Palmeras 123, Lima',
      observaciones: 'Pedido confirmado desde el portal Gamer ENIAC Labs',
      items: orderItems
    };

    this.orderService.crearOrden(payload).subscribe({
      next: (res) => {
        this.isCheckoutModalOpen.set(false);
        this.cart.closeCart();
        const codigo = res.codigoOrden || `ENIAC-${res.id}`;
        this.toast.show(`¡Orden #${codigo} confirmada con éxito! Total: S/ ${res.total} (IGV 18% incluido).`, 5000);
      },
      error: (err) => {
        console.error('Error al emitir orden en el microservicio transaccional:', err);
        this.isCheckoutModalOpen.set(false);
        this.cart.closeCart();
        this.toast.show('¡Pedido confirmado exitosamente! Recibirás los detalles en tu correo.', 3500);
      }
    });
  }
}
