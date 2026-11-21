import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { CatalogService, Product } from '../../services/catalog.service';
import { CartService } from '../../services/cart.service';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-quick-buy-modal',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, RouterLink],
  template: `
    @if (catalog.isQuickBuyOpen() && catalog.selectedProductForBuy(); as product) {
      <button 
        type="button"
        (click)="catalog.closeQuickBuy()" 
        class="fixed inset-0 w-full h-full bg-black/60 backdrop-blur-sm z-50 transition-opacity animate-fadeIn border-none p-0 m-0 cursor-default"
        aria-label="Cerrar vista rápida"
      ></button>

      <div class="fixed inset-0 z-50 flex items-center justify-center p-4 pointer-events-none">
        <div class="bg-white rounded-3xl max-w-2xl w-full max-h-[90vh] overflow-y-auto p-6 sm:p-8 pointer-events-auto relative shadow-2xl border border-gray-100 animate-scaleUp">
          
          <!-- Close button -->
          <button 
            type="button"
            (click)="catalog.closeQuickBuy()" 
            class="absolute top-5 right-5 w-8 h-8 rounded-full bg-gray-100 hover:bg-black hover:text-white flex items-center justify-center text-sm font-bold transition-colors"
            aria-label="Cerrar ventana"
          >
            ✕
          </button>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-8 items-center">
            
            <!-- Left: Product Image & Badges -->
            <div class="relative flex flex-col items-center justify-center bg-gray-50 rounded-2xl p-6 h-72 sm:h-80">
              @if (product.badge) {
                <span class="absolute top-4 left-4 bg-[#256fff] text-white text-[11px] font-bold px-3 py-1 rounded-full shadow-sm">
                  {{ product.badge }}
                </span>
              }

              <img 
                [src]="product.colors[selectedColorIndex()].image" 
                [alt]="product.name" 
                class="max-h-60 object-contain hover:scale-105 transition-transform duration-300"
              />

              <div class="text-[11px] text-gray-400 mt-2">
                Color seleccionado: <strong>{{ product.colors[selectedColorIndex()].name }}</strong>
              </div>
            </div>

            <!-- Right: Product Information & Purchase options -->
            <div class="space-y-4 text-xs sm:text-sm">
              <div>
                <span class="text-[10px] uppercase font-bold tracking-wider text-[#256fff]">Componente Oficial de PC</span>
                <h3 class="text-xl sm:text-2xl font-bold text-gray-900 mt-1">{{ product.name }}</h3>
                <p class="text-xs text-gray-500 mt-1">{{ product.description }}</p>
              </div>

              <!-- Price Box -->
              <div class="p-3 bg-gray-50 rounded-xl">
                <div class="flex items-baseline gap-2">
                  <span class="text-2xl font-bold text-black">
                    S/ {{ product.price | number:'1.0-0' }}
                  </span>
                  @if (product.originalPrice) {
                    <span class="text-xs text-gray-400 line-through">
                      S/ {{ product.originalPrice | number:'1.0-0' }}
                    </span>
                  }
                </div>
                <div class="text-[11px] text-[#256fff] font-medium mt-1">
                  Hasta 12 cuotas sin intereses de S/ {{ (product.price / 12).toFixed(2) }}
                </div>
              </div>

              <!-- Color Selector -->
              <div>
                <span class="block font-bold text-gray-800 text-xs mb-2">Selecciona Color:</span>
                <div class="flex items-center gap-2">
                  @for (col of product.colors; track col.name; let idx = $index) {
                    <button 
                      type="button"
                      (click)="selectedColorIndex.set(idx)"
                      [style.backgroundColor]="col.hex"
                      [class.ring-2]="selectedColorIndex() === idx"
                      [class.ring-offset-2]="selectedColorIndex() === idx"
                      class="w-7 h-7 rounded-full border border-black/20 ring-black transition-all hover:scale-110"
                      [title]="col.name"
                      [attr.aria-label]="col.name"
                    ></button>
                  }
                </div>
              </div>

              <!-- Free Benefits / Incluye gratis badge -->
              <div class="p-3 bg-[#f0f9eb] border border-[#e1f3d8] rounded-xl space-y-1 text-xs text-[#38774a]">
                <div class="font-bold flex items-center gap-1.5">
                  <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
                  Beneficios incluidos gratis:
                </div>
                <ul class="list-disc list-inside text-[11px] space-y-0.5 text-gray-600 pl-1">
                  <li>Envío oficial gratuito a nivel nacional</li>
                  <li>Garantía oficial de fabricante por 12 a 36 meses</li>
                  <li>Soporte técnico y postventa especializado</li>
                </ul>
              </div>

              <!-- Quantity Selector & Action Buttons -->
              <div class="flex items-center gap-3 pt-2">
                <div class="flex items-center border border-gray-200 rounded-full bg-gray-50">
                  <button 
                    type="button"
                    (click)="decrementQty()" 
                    class="w-8 h-8 flex items-center justify-center text-gray-600 font-bold hover:text-black"
                    aria-label="Disminuir cantidad"
                  >
                    -
                  </button>
                  <span class="w-8 text-center font-bold text-xs">{{ quantity() }}</span>
                  <button 
                    type="button"
                    (click)="incrementQty()" 
                    class="w-8 h-8 flex items-center justify-center text-gray-600 font-bold hover:text-black"
                    aria-label="Aumentar cantidad"
                  >
                    +
                  </button>
                </div>

                <button 
                  type="button"
                  (click)="addToCart(product)"
                  class="flex-1 py-3 bg-black hover:bg-[#256fff] text-white font-bold text-xs sm:text-sm rounded-full transition-colors shadow-md flex items-center justify-center gap-2"
                >
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
                  Agregar al Carrito
                </button>
              </div>

              <div class="pt-2 text-center">
                <a 
                  [routerLink]="['/producto', product.id]" 
                  (click)="catalog.closeQuickBuy()" 
                  class="text-xs text-[#256fff] font-bold hover:underline cursor-pointer inline-flex items-center gap-1"
                >
                  <span>Ver página completa y ficha técnica</span>
                  <span>&rarr;</span>
                </a>
              </div>

            </div>

          </div>

        </div>
      </div>
    }
  `,
  styles: [`
    @keyframes scaleUp {
      from { opacity: 0; transform: scale(0.95); }
      to { opacity: 1; transform: scale(1); }
    }
    .animate-scaleUp {
      animation: scaleUp 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
  `]
})
export class QuickBuyModalComponent {
  catalog = inject(CatalogService);
  cart = inject(CartService);
  toast = inject(ToastService);

  selectedColorIndex = signal<number>(0);
  quantity = signal<number>(1);

  incrementQty() {
    this.quantity.update(q => q + 1);
  }

  decrementQty() {
    this.quantity.update(q => Math.max(1, q - 1));
  }

  addToCart(product: Product) {
    const selectedColor = product.colors[this.selectedColorIndex()];
    this.cart.addToCart({
      id: product.id,
      name: product.name,
      color: selectedColor.name,
      storage: product.specs ? product.specs[0] : undefined,
      price: product.price,
      originalPrice: product.originalPrice,
      image: selectedColor.image
    }, this.quantity());

    this.toast.show(`¡${product.name} agregado al carrito!`);
    this.catalog.closeQuickBuy();
    this.quantity.set(1);
    this.selectedColorIndex.set(0);
  }
}
