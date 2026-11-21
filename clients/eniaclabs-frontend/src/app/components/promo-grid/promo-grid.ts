import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { CatalogService } from '../../services/catalog.service';
import { ToastService } from '../../services/toast.service';

interface HardwarePromoCard {
  id: string;
  name: string;
  categoryName: string;
  badge: string;
  price: number;
  originalPrice?: number;
  specs: string[];
  image: string;
}

@Component({
  selector: 'app-promo-grid',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, RouterLink],
  template: `
    <!-- Sección Promocional 1: Banners de Hardware y Beneficios ENIAC Labs (peshop1) -->
    <div class="shop-page mt-12 sm:mt-16 max-w-[1400px] mx-auto px-4 sm:px-6" id="peshop1">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        <!-- Tarjeta 1: Destacado GeForce RTX 4080 Super -->
        <div class="relative bg-gradient-to-br from-[#121620] to-[#0c0e14] rounded-2xl sm:rounded-3xl p-6 sm:p-7 border border-white/10 text-white overflow-hidden shadow-lg group hover:border-[#256fff]/40 transition-all flex flex-col justify-between">
          <div class="relative z-10">
            <span class="inline-block bg-[#256fff]/20 text-[#256fff] border border-[#256fff]/40 text-[11px] font-bold uppercase tracking-wider px-3 py-1 rounded-full mb-3">
              Oferta Flagship
            </span>
            <h3 class="text-xl sm:text-2xl font-black text-white leading-tight">
              GeForce RTX 4080 Super OC
            </h3>
            <p class="text-xs text-gray-300 mt-2 leading-relaxed">
              16GB GDDR6X, arquitectura Ada Lovelace y DLSS 3.5 con aceleración de IA para 4K nativo.
            </p>
            <div class="mt-4 flex items-baseline gap-2">
              <span class="text-2xl font-extrabold text-[#256fff]">S/ 3,399</span>
              <span class="text-xs text-gray-400 line-through">S/ 3,499</span>
            </div>
          </div>

          <div class="relative my-4 flex justify-center items-center py-2">
            <img 
              src="/images/gpu-rtx4080.jpg" 
              alt="GeForce RTX 4080 Super" 
              class="w-full max-h-44 object-contain group-hover:scale-105 transition-transform duration-300 drop-shadow-2xl"
            />
          </div>

          <div class="relative z-10 pt-2 flex gap-2">
            <a 
              [routerLink]="['/producto', 'honor-600-pro']"
              class="flex-1 bg-white hover:bg-gray-100 text-black text-xs font-bold py-2.5 px-4 rounded-xl text-center transition-all shadow hover:shadow-md cursor-pointer"
            >
              Ver Ficha Técnica
            </a>
            <button 
              (click)="openProduct('honor-600-pro')"
              class="bg-[#256fff] hover:bg-[#1a55d6] text-white text-xs font-bold py-2.5 px-4 rounded-xl transition-all shadow-md cursor-pointer"
              title="Compra Rápida"
            >
              Comprar
            </button>
          </div>
        </div>

        <!-- Tarjeta 2: Cupón Gamer Exclusivo -->
        <div class="relative bg-gradient-to-br from-[#0c1a30] via-[#0f2444] to-[#121c2d] rounded-2xl sm:rounded-3xl p-6 sm:p-7 border border-[#256fff]/30 text-white overflow-hidden shadow-lg flex flex-col justify-between">
          <div class="relative z-10">
            <div class="flex items-center justify-between mb-3">
              <span class="inline-block bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 text-[11px] font-bold uppercase tracking-wider px-3 py-1 rounded-full">
                Beneficio Exclusivo
              </span>
              <span class="text-xs text-gray-300 font-semibold">Válido hasta fin de mes</span>
            </div>
            <h3 class="text-xl sm:text-2xl font-black text-white leading-tight">
              Cupón Gamer: 8% OFF
            </h3>
            <p class="text-xs text-gray-300 mt-2 leading-relaxed">
              Aplica en procesadores AMD Ryzen 7000/9000, placas madre AM5 y kits de memoria DDR5.
            </p>
          </div>

          <!-- Cupón Interactivo -->
          <div class="my-5 p-4 rounded-2xl bg-white/5 border-2 border-dashed border-[#256fff]/50 text-center relative group">
            <div class="text-[11px] text-gray-300 font-medium mb-1">CÓDIGO DE DESCUENTO:</div>
            <div class="text-2xl font-mono font-black text-white tracking-widest selection:bg-[#256fff]">
              APEALL35
            </div>
            <p class="text-[10px] text-gray-400 mt-1">Copia y pega en la pantalla de pago</p>
          </div>

          <div class="relative z-10 flex flex-col gap-2">
            <button 
              (click)="copyCoupon('APEALL35')"
              class="w-full bg-[#256fff] hover:bg-[#1f5ee0] text-white text-xs font-bold py-2.5 px-4 rounded-xl transition-all shadow-md flex items-center justify-center gap-2 cursor-pointer"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/></svg>
              Copiar Cupón
            </button>
            <a 
              href="#category" 
              (click)="scrollToSection('category', $event)"
              class="text-center text-xs text-gray-300 hover:text-white py-1 transition-colors cursor-pointer"
            >
              Explorar componentes aplicables →
            </a>
          </div>
        </div>

        <!-- Tarjeta 3: ENIAC PC Builder Inteligente -->
        <div class="relative bg-gradient-to-br from-[#1b1528] to-[#110e1a] rounded-2xl sm:rounded-3xl p-6 sm:p-7 border border-white/10 text-white overflow-hidden shadow-lg group hover:border-purple-500/40 transition-all flex flex-col justify-between">
          <div class="relative z-10">
            <span class="inline-block bg-purple-500/20 text-purple-400 border border-purple-500/30 text-[11px] font-bold uppercase tracking-wider px-3 py-1 rounded-full mb-3">
              Herramienta Exclusiva
            </span>
            <h3 class="text-xl sm:text-2xl font-black text-white leading-tight">
              ENIAC PC Builder Inteligente
            </h3>
            <p class="text-xs text-gray-300 mt-2 leading-relaxed">
              Configura tu rig a medida con cálculo automático de vatios, compatibilidad de sockets y cotización en tiempo real.
            </p>
          </div>

          <div class="relative my-4 flex justify-center items-center overflow-hidden rounded-xl border border-white/10">
            <img 
              src="/images/pc-builder-banner.jpg" 
              alt="ENIAC PC Builder" 
              class="w-full max-h-40 object-cover group-hover:scale-105 transition-transform duration-300 drop-shadow-lg"
            />
          </div>

          <div class="relative z-10 pt-2 flex flex-col gap-2">
            <a 
              routerLink="/explorar"
              class="w-full bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500 text-white text-xs font-bold py-2.5 px-4 rounded-xl text-center transition-all shadow-md cursor-pointer"
            >
              Iniciar Configurador de PC
            </a>
            <span class="text-[11px] text-center text-gray-400">
              Ensamblaje & Testeo de estrés GRATIS
            </span>
          </div>
        </div>

      </div>
    </div>

    <!-- Sección Promocional 2: Nuevos Ingresos de Hardware (peshop2) -->
    <div id="peshop2" class="mt-16 sm:mt-24 py-16 sm:py-24 bg-[#f8f9fc] transition-colors">
      <section class="relative max-w-[1400px] mx-auto px-4 sm:px-6">
        
        <!-- Section Header Title -->
        <div class="text-center mb-10 sm:mb-14">
          <span class="inline-block bg-[#256fff]/10 text-[#256fff] text-xs font-bold uppercase tracking-widest px-3 py-1 rounded-full mb-2">
            Catálogo Oficial ENIAC Labs
          </span>
          <h2 class="text-3xl sm:text-4xl lg:text-[40px] font-black text-gray-950 tracking-tight">
            Nuevos componentes en stock
          </h2>
          <p class="text-sm sm:text-base text-gray-600 mt-2 font-medium max-w-2xl mx-auto">
            Hardware de última generación para gaming y creación de contenido profesional, con 3 años de garantía oficial del fabricante.
          </p>
        </div>

        <!-- Grid de 6 Productos de Hardware Destacados -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          @for (item of newStockItems; track item.id) {
            <div class="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm hover:shadow-xl hover:border-[#256fff]/30 transition-all flex flex-col justify-between group">
              <div>
                <!-- Header con Badge y Categoría -->
                <div class="flex items-center justify-between mb-3">
                  <span class="text-[11px] font-bold text-gray-400 uppercase tracking-wider">
                    {{ item.categoryName }}
                  </span>
                  <span class="bg-blue-50 text-[#256fff] text-[10px] font-bold px-2.5 py-0.5 rounded-full border border-blue-100">
                    {{ item.badge }}
                  </span>
                </div>

                <!-- Imagen del Producto -->
                <div class="h-48 flex items-center justify-center p-2 mb-4 overflow-hidden rounded-xl bg-gray-50/50">
                  <img 
                    [src]="item.image" 
                    [alt]="item.name" 
                    class="max-h-40 max-w-full object-contain group-hover:scale-105 transition-transform duration-300 drop-shadow-md"
                  />
                </div>

                <!-- Título del Producto -->
                <h3 class="text-base font-bold text-gray-900 group-hover:text-[#256fff] transition-colors line-clamp-1">
                  {{ item.name }}
                </h3>

                <!-- Especificaciones Rápidas -->
                <div class="flex flex-wrap gap-1.5 mt-2.5 mb-4">
                  @for (spec of item.specs; track spec) {
                    <span class="text-[10px] bg-gray-100 text-gray-700 px-2 py-0.5 rounded-md font-medium">
                      {{ spec }}
                    </span>
                  }
                </div>
              </div>

              <!-- Precio y Botones de Acción -->
              <div class="pt-4 border-t border-gray-100 flex items-center justify-between gap-3">
                <div>
                  <div class="text-lg font-black text-gray-950">
                    S/ {{ item.price | number:'1.0-0' }}
                  </div>
                  @if (item.originalPrice) {
                    <div class="text-[11px] text-gray-400 line-through">
                      S/ {{ item.originalPrice | number:'1.0-0' }}
                    </div>
                  }
                </div>

                <div class="flex items-center gap-2">
                  <a 
                    [routerLink]="['/producto', item.id]" 
                    class="text-xs font-bold text-gray-700 hover:text-black bg-gray-100 hover:bg-gray-200 px-3 py-2 rounded-xl transition-all cursor-pointer"
                  >
                    Detalles
                  </a>
                  <button 
                    (click)="openProduct(item.id)"
                    class="text-xs font-bold text-white bg-[#256fff] hover:bg-[#1a55d6] px-4 py-2 rounded-xl transition-all shadow hover:shadow-md cursor-pointer flex items-center gap-1.5"
                  >
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
                    Comprar
                  </button>
                </div>
              </div>
            </div>
          }
        </div>

        <!-- Callout Banner: Microservicios & Integración -->
        <div class="mt-12 bg-gradient-to-r from-slate-900 via-indigo-950 to-slate-900 rounded-2xl p-6 sm:p-8 text-white border border-white/10 shadow-lg flex flex-col sm:flex-row items-center justify-between gap-6">
          <div class="space-y-1 text-center sm:text-left">
            <div class="flex items-center gap-2 justify-center sm:justify-start">
              <span class="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-pulse"></span>
              <span class="text-xs font-bold uppercase tracking-wider text-emerald-400">Arquitectura de Microservicios Activa</span>
            </div>
            <h4 class="text-lg sm:text-xl font-black">
              ENIAC Labs Cloud: Catálogo, Cotizaciones & Órdenes en Tiempo Real
            </h4>
            <p class="text-xs text-gray-300">
              Conectado a Spring Cloud Gateway (:18080) y autenticación OIDC Keycloak (:18180) con resiliencia garantizada.
            </p>
          </div>

          <a 
            routerLink="/admin/login" 
            class="bg-white/10 hover:bg-white/20 text-white border border-white/20 px-5 py-2.5 rounded-xl text-xs font-bold tracking-wide transition-all whitespace-nowrap cursor-pointer"
          >
            Panel Administrativo →
          </a>
        </div>

      </section>
    </div>
  `
})
export class PromoGridComponent {
  catalog = inject(CatalogService);
  toast = inject(ToastService);

  readonly newStockItems: HardwarePromoCard[] = [
    {
      id: 'honor-600-pro',
      name: 'ASUS TUF GeForce RTX 4080 Super OC',
      categoryName: 'Tarjeta Gráfica',
      badge: 'Ada Lovelace',
      price: 3399,
      originalPrice: 3499,
      specs: ['16GB GDDR6X', 'DLSS 3.5 con IA', 'Triple Ventilador'],
      image: '/images/gpu-rtx4080.jpg'
    },
    {
      id: 'honor-600-smart',
      name: 'AMD Ryzen 7 7800X3D Gaming CPU',
      categoryName: 'Procesador AM5',
      badge: '3D V-Cache',
      price: 1299,
      originalPrice: 1399,
      specs: ['8C / 16T', 'Hasta 5.0 GHz', '104MB Cache Total'],
      image: '/images/cpu-ryzen7.jpg'
    },
    {
      id: 'honor-pad-10',
      name: 'ASUS ROG Strix B650E-F Gaming WiFi',
      categoryName: 'Placa Madre',
      badge: 'PCIe 5.0 Ready',
      price: 1799,
      originalPrice: 1999,
      specs: ['Socket AM5 DDR5', 'Wi-Fi 6E + 2.5G LAN', '12+2 Fases VRM'],
      image: '/images/mobo-rog.jpg'
    },
    {
      id: 'honor-pad-x9a-lte',
      name: 'Corsair Vengeance RGB 64GB DDR5 6000MHz',
      categoryName: 'Memoria RAM',
      badge: 'Alta Frecuencia',
      price: 1199,
      originalPrice: 1299,
      specs: ['2x32GB Kit', '6000 MT/s CL30', 'iCUE RGB Dynamic'],
      image: '/images/ram-ddr5.jpg'
    },
    {
      id: 'honor-watch-6',
      name: 'Samsung 990 PRO 2TB NVMe PCIe 4.0 M.2',
      categoryName: 'Almacenamiento SSD',
      badge: 'Ultra Rápido',
      price: 799,
      specs: ['7,450 MB/s Lectura', 'Disipador Térmico Heatsink', 'TLC V-NAND'],
      image: '/images/ssd-nvme.jpg'
    },
    {
      id: 'honor-earbuds-a-pro',
      name: 'Enfriamiento Líquido ARGB 360mm Triple Fan',
      categoryName: 'Refrigeración Líquida',
      badge: 'Zero Ruido',
      price: 549,
      originalPrice: 629,
      specs: ['Radiador 360mm', 'Bomba Infinity Mirror', 'Soporta AM5 & LGA1700'],
      image: '/images/aio-cooler.jpg'
    }
  ];

  openProduct(id: string) {
    const product = this.catalog.products.find(p => p.id === id);
    if (product) {
      this.catalog.openQuickBuy(product);
    }
  }

  copyCoupon(code: string) {
    if (navigator.clipboard) {
      navigator.clipboard.writeText(code).then(() => {
        this.toast.show(`¡Cupón ${code} copiado al portapapeles! Disfruta 8% de descuento.`);
      }).catch(() => {
        this.toast.show(`Cupón: ${code}`);
      });
    } else {
      this.toast.show(`Cupón: ${code}`);
    }
  }

  scrollToSection(id: string, event: Event) {
    event.preventDefault();
    const el = document.getElementById(id);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }
}
