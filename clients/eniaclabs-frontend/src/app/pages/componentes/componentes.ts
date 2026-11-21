import { ChangeDetectionStrategy, Component, computed, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { CatalogService, Product } from '../../services/catalog.service';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-componentes-page',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-screen bg-[#fafafa]">
      <!-- Breadcrumb Bar -->
      <div class="bg-white border-b border-black/5 py-3">
        <div class="max-w-[1400px] mx-auto px-4 sm:px-6">
          <nav class="text-xs text-neutral-500 flex items-center gap-2" aria-label="Breadcrumb">
            <a routerLink="/" class="hover:text-black transition-colors font-medium">Inicio</a>
            <span class="text-neutral-300">›</span>
            <span class="text-black font-semibold">Componentes</span>
          </nav>
        </div>
      </div>

      <!-- Hero Header Section -->
      <section class="relative overflow-hidden bg-gradient-to-r from-[#edd9c7] via-[#f7ece2] to-[#edd9c7] py-14 lg:py-20 border-b border-black/5">
        <div class="max-w-[1400px] mx-auto px-4 sm:px-6 relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
          
          <div class="lg:col-span-7 space-y-4">
            <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/70 backdrop-blur-xs text-xs font-semibold text-neutral-900 border border-black/5 shadow-2xs">
              <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
              Stock Oficial ENIAC Labs 2026
            </div>
            
            <h1 class="text-3xl sm:text-5xl lg:text-6xl font-black text-neutral-950 tracking-tight leading-[1.1]">
              Componentes de <br class="hidden sm:inline" />
              <span class="text-[#256fff]">Alto Rendimiento</span>
            </h1>

            <p class="text-base sm:text-lg text-neutral-700 max-w-xl leading-relaxed">
              Equipa tu estación con tarjetas de video de última generación, procesadores con núcleos desbloqueados y hardware probado para máximo overclocking.
            </p>

            <div class="pt-2 flex flex-wrap items-center gap-3">
              <a 
                href="#catalogo" 
                class="px-7 py-3 rounded-full bg-black text-white text-sm font-semibold hover:bg-neutral-800 transition-all shadow-md active:scale-95 inline-flex items-center gap-2"
              >
                Explorar Catálogo
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
              </a>

              <a 
                routerLink="/explorar" 
                class="px-7 py-3 rounded-full bg-white/80 hover:bg-white text-neutral-900 text-sm font-semibold border border-black/10 transition-all shadow-2xs inline-flex items-center gap-2"
              >
                Configurador PC
              </a>
            </div>
          </div>

          <!-- Hero Floating Hardware Composition -->
          <div class="lg:col-span-5 relative flex items-center justify-center min-h-[280px]">
            <div class="relative w-full max-w-[420px] aspect-square flex items-center justify-center">
              <!-- Glow background -->
              <div class="absolute inset-0 bg-[#256fff]/10 rounded-full blur-3xl animate-pulse"></div>

              <!-- Main GPU floating card -->
              <div class="relative z-10 w-full max-w-[420px] transform hover:scale-105 transition-transform duration-500 drop-shadow-2xl flex items-center justify-center">
                <img 
                  src="/images/gpu-rtx4080.png" 
                  alt="GeForce RTX 4080 Super" 
                  class="w-full h-auto object-contain filter drop-shadow-[0_25px_35px_rgba(0,0,0,0.22)]"
                />
              </div>

              <!-- Floating spec tag -->
              <div class="absolute -bottom-2 -left-2 bg-white/95 backdrop-blur-md p-3.5 rounded-2xl shadow-xl border border-black/5 z-20 flex items-center gap-3 animate-bounce [animation-duration:3s]">
                <div class="w-10 h-10 rounded-xl bg-black text-white flex items-center justify-center font-bold text-xs">
                  4K
                </div>
                <div class="text-left text-xs">
                  <div class="font-bold text-neutral-900">DLSS 3.5 Ready</div>
                  <div class="text-neutral-500">+180 FPS en Ultra</div>
                </div>
              </div>
            </div>
          </div>

        </div>
      </section>

      <!-- Value Pillars Strip -->
      <div class="bg-white border-b border-black/5 py-5">
        <div class="max-w-[1400px] mx-auto px-4 sm:px-6 grid grid-cols-2 md:grid-cols-4 gap-6 text-xs">
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full bg-blue-50 text-[#256fff] flex items-center justify-center font-bold">✓</span>
            <div>
              <div class="font-bold text-neutral-900">Garantía Directa</div>
              <div class="text-neutral-500">De 12 a 36 meses oficial</div>
            </div>
          </div>
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold">⚡</span>
            <div>
              <div class="font-bold text-neutral-900">Envío Inmediato</div>
              <div class="text-neutral-500">Despacho en 24 horas</div>
            </div>
          </div>
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full bg-amber-50 text-amber-600 flex items-center justify-center font-bold">★</span>
            <div>
              <div class="font-bold text-neutral-900">100% Original</div>
              <div class="text-neutral-500">Cajas selladas de fábrica</div>
            </div>
          </div>
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full bg-purple-50 text-purple-600 flex items-center justify-center font-bold">🛠</span>
            <div>
              <div class="font-bold text-neutral-900">Test & Diagnóstico</div>
              <div class="text-neutral-500">Probado por especialistas</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Catalog Section -->
      <main id="catalogo" class="max-w-[1400px] mx-auto px-4 sm:px-6 py-12">
        
        <!-- Filter Tabs & Stats -->
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
          <div>
            <h2 class="text-2xl sm:text-3xl font-extrabold text-neutral-950 tracking-tight">
              Catálogo de Hardware
            </h2>
            <p class="text-xs sm:text-sm text-neutral-500 mt-1">
              Mostrando {{ filteredProducts().length }} componentes disponibles para entrega inmediata
            </p>
          </div>

          <!-- Category Segmented Control -->
          <div class="flex items-center gap-1.5 p-1 bg-neutral-200/60 rounded-2xl overflow-x-auto scrollbar-none text-xs font-medium">
            @for (tab of tabs; track tab.id) {
              <button 
                type="button"
                (click)="activeCategory.set(tab.id)"
                [class.bg-white]="activeCategory() === tab.id"
                [class.text-black]="activeCategory() === tab.id"
                [class.shadow-2xs]="activeCategory() === tab.id"
                [class.text-neutral-600]="activeCategory() !== tab.id"
                class="px-4 py-2 rounded-xl transition-all cursor-pointer whitespace-nowrap hover:text-black"
              >
                {{ tab.label }}
              </button>
            }
          </div>
        </div>

        <!-- Products Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          @for (product of filteredProducts(); track product.id) {
            <div class="group bg-white rounded-3xl p-6 border border-black/5 shadow-xs hover:shadow-2xl hover:shadow-black/10 hover:scale-[1.03] hover:-translate-y-2 hover:border-black/15 transition-all duration-300 ease-out transform-gpu flex flex-col justify-between relative overflow-hidden">
              
              <!-- Badge -->
              <div class="flex items-center justify-between mb-2">
                @if (product.badge) {
                  <span class="text-[11px] font-bold text-white bg-[#256fff] px-3 py-0.5 rounded-full shadow-2xs">
                    {{ product.badge }}
                  </span>
                } @else {
                  <span></span>
                }
                <span class="text-[11px] font-medium text-emerald-600 flex items-center gap-1">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Stock disponible
                </span>
              </div>

              <!-- Product Image Link -->
              <a [routerLink]="['/producto', product.id]" class="py-6 flex items-center justify-center relative overflow-hidden h-52 cursor-pointer">
                <img 
                  [src]="product.colors[0]?.image || '/images/gpu-rtx4080.png'" 
                  [alt]="product.name" 
                  class="max-h-48 w-auto object-contain group-hover:scale-108 transition-transform duration-500 select-none"
                />
              </a>

              <!-- Product Details -->
              <div class="space-y-3 pt-2">
                <div>
                  <a [routerLink]="['/producto', product.id]" class="block font-bold text-neutral-900 text-base line-clamp-2 group-hover:text-[#256fff] transition-colors cursor-pointer">
                    {{ product.name }}
                  </a>
                  <p class="text-xs text-neutral-500 line-clamp-2 mt-1 leading-relaxed">
                    {{ product.description }}
                  </p>
                </div>

                <!-- Specs Pills -->
                @if (product.specs && product.specs.length > 0) {
                  <div class="flex flex-wrap gap-1.5 pt-1">
                    @for (spec of product.specs.slice(0, 2); track spec) {
                      <span class="text-[10px] bg-neutral-100 text-neutral-700 px-2 py-0.5 rounded-md font-medium">
                        {{ spec }}
                      </span>
                    }
                  </div>
                }

                <!-- Price & Actions -->
                <div class="pt-4 border-t border-black/5 flex items-center justify-between">
                  <div>
                    @if (product.originalPrice) {
                      <div class="text-[11px] text-neutral-400 line-through">
                        S/ {{ product.originalPrice | number:'1.0-0' }}
                      </div>
                    }
                    <div class="text-lg font-black text-neutral-950">
                      S/ {{ product.price | number:'1.0-0' }}
                    </div>
                  </div>

                  <button 
                    type="button"
                    (click)="onBuy(product)"
                    class="px-4 py-2 rounded-full bg-black text-white text-xs font-bold hover:bg-[#256fff] transition-colors shadow-2xs active:scale-95"
                  >
                    Comprar
                  </button>
                </div>
              </div>

            </div>
          }
        </div>

        <!-- Featured Builds Showcase -->
        <section class="mt-20">
          <div class="text-center max-w-2xl mx-auto mb-10">
            <span class="text-xs uppercase tracking-widest font-bold text-[#256fff]">Equipos Recomendados</span>
            <h2 class="text-2xl sm:text-3xl font-black text-neutral-950 tracking-tight mt-1">
              Ensambles Diseñados por Especialistas
            </h2>
            <p class="text-xs sm:text-sm text-neutral-600 mt-2">
              Configuraciones equilibradas sin cuellos de botella probadas en nuestro banco de pruebas.
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <!-- Build 1 -->
            <div class="bg-gradient-to-b from-white to-neutral-50 rounded-3xl p-7 border border-black/5 shadow-sm hover:shadow-lg transition-all space-y-5">
              <div class="flex items-center justify-between">
                <span class="text-xs font-bold px-3 py-1 rounded-full bg-emerald-100 text-emerald-800">1080p Esport</span>
                <span class="text-lg font-black text-neutral-900">S/ 3,499</span>
              </div>
              <h3 class="text-xl font-black text-neutral-900">Tier Esport Challenger</h3>
              <p class="text-xs text-neutral-600 leading-relaxed">
                Excelente para Valorant, CS2 y Fortnite a más de 240 FPS estables.
              </p>
              <ul class="text-xs space-y-2 text-neutral-700">
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> CPU: Intel Core i5 14600KF</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> GPU: RTX 4060 Ti 8GB</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> RAM: 32GB DDR5 6000MHz</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> SSD: 1TB NVMe Gen4</li>
              </ul>
              <button 
                type="button" 
                (click)="toast.show('Configuración Esport agregada para cotización')"
                class="w-full py-2.5 rounded-full bg-neutral-900 text-white text-xs font-bold hover:bg-neutral-800 transition-colors"
              >
                Cotizar este ensamble
              </button>
            </div>

            <!-- Build 2 -->
            <div class="bg-gradient-to-b from-[#f2e6de] to-white rounded-3xl p-7 border-2 border-[#256fff]/30 shadow-md hover:shadow-xl transition-all space-y-5 relative">
              <div class="absolute -top-3 right-6 bg-[#256fff] text-white text-[10px] font-extrabold uppercase tracking-widest px-3 py-0.5 rounded-full shadow-sm">
                Más Vendido
              </div>
              <div class="flex items-center justify-between">
                <span class="text-xs font-bold px-3 py-1 rounded-full bg-blue-100 text-blue-800">1440p / 4K Pro</span>
                <span class="text-lg font-black text-neutral-900">S/ 5,899</span>
              </div>
              <h3 class="text-xl font-black text-neutral-900">Tier Predator 4K</h3>
              <p class="text-xs text-neutral-600 leading-relaxed">
                Potencia pura para Cyberpunk 2077 con Ray Tracing completo y renderizado 3D.
              </p>
              <ul class="text-xs space-y-2 text-neutral-700">
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> CPU: AMD Ryzen 7 7800X3D</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> GPU: GeForce RTX 4070 Ti Super 16GB</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> RAM: 32GB DDR5 RGB 6000MHz</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> SSD: 2TB Samsung 990 Pro</li>
              </ul>
              <button 
                type="button" 
                (click)="toast.show('Configuración Predator 4K agregada para cotización')"
                class="w-full py-2.5 rounded-full bg-[#256fff] text-white text-xs font-bold hover:bg-blue-600 transition-colors shadow-sm"
              >
                Cotizar este ensamble
              </button>
            </div>

            <!-- Build 3 -->
            <div class="bg-gradient-to-b from-white to-neutral-50 rounded-3xl p-7 border border-black/5 shadow-sm hover:shadow-lg transition-all space-y-5">
              <div class="flex items-center justify-between">
                <span class="text-xs font-bold px-3 py-1 rounded-full bg-purple-100 text-purple-800">Extreme Workstation</span>
                <span class="text-lg font-black text-neutral-900">S/ 9,999</span>
              </div>
              <h3 class="text-xl font-black text-neutral-900">Tier Master Creator & IA</h3>
              <p class="text-xs text-neutral-600 leading-relaxed">
                Para entrenamiento de IA local, Unreal Engine 5 y renderizado con múltiples GPUs.
              </p>
              <ul class="text-xs space-y-2 text-neutral-700">
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> CPU: AMD Ryzen 9 7950X / i9 14900K</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> GPU: GeForce RTX 4080 Super 16GB</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> RAM: 64GB DDR5 Dominator</li>
                <li class="flex items-center gap-2"><span class="text-[#256fff] font-bold">•</span> PSU: Corsair RM1000x Gold</li>
              </ul>
              <button 
                type="button" 
                (click)="toast.show('Configuración Workstation agregada para cotización')"
                class="w-full py-2.5 rounded-full bg-neutral-900 text-white text-xs font-bold hover:bg-neutral-800 transition-colors"
              >
                Cotizar este ensamble
              </button>
            </div>
          </div>
        </section>

      </main>
    </div>
  `
})
export class ComponentesPage {
  private catalogService = inject(CatalogService);
  toast = inject(ToastService);

  readonly tabs = [
    { id: 'all', label: 'Todos' },
    { id: 'phones', label: 'Tarjetas Gráficas' },
    { id: 'tablets', label: 'Placas & RAM' },
    { id: 'wearables', label: 'Almacenamiento' },
    { id: 'choice', label: 'Fuentes & Chasis' }
  ];

  activeCategory = signal<string>('all');

  filteredProducts = computed(() => {
    const cat = this.activeCategory();
    if (cat === 'all') {
      return this.catalogService.products;
    }
    return this.catalogService.products.filter(p => p.category === cat);
  });

  onBuy(product: Product) {
    this.catalogService.openQuickBuy(product);
  }
}
