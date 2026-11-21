import { Component, OnInit, OnDestroy, inject, signal, computed, PLATFORM_ID } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { ActivatedRoute, RouterLink, Router } from '@angular/router';
import { CatalogService, Product } from '../../services/catalog.service';
import { CartService } from '../../services/cart.service';
import { ToastService } from '../../services/toast.service';

interface AddonBundle {
  id: string;
  name: string;
  price: number;
  originalPrice: number;
  image: string;
  selected: boolean;
  category: 'watch6' | 'paquete';
  colorDots?: string[];
}

@Component({
  selector: 'app-producto-detalle',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-screen bg-white text-gray-900 font-sans">
      
      <!-- Top Promotion Ribbon Bar (Exact replica from screenshot) -->
      <div class="bg-gray-50 border-b border-gray-100 text-xs py-2 px-4 sm:px-8 flex flex-col md:flex-row items-center justify-between gap-2">
        <div class="w-full md:w-auto text-center md:text-left text-gray-700 font-medium text-[11px] sm:text-xs">
          <span>Productos 100% originales</span>
          <span class="mx-2 text-gray-300">|</span>
          <span>Envío rápido y gratis</span>
          <span class="mx-2 text-gray-300">|</span>
          <span>Hasta 12 cuotas sin intereses</span>
        </div>

        <div class="flex items-center gap-2.5 text-xs font-semibold self-end md:self-auto">
          <span class="text-[#eb1406] font-bold">
            Ahorra S/ {{ (product().originalPrice ? product().originalPrice! - product().price : 578) | number:'1.2-2' }}
          </span>
          @if (product().originalPrice) {
            <span class="text-gray-400 line-through text-[11px]">
              S/ {{ product().originalPrice | number:'1.2-2' }}
            </span>
          } @else {
            <span class="text-gray-400 line-through text-[11px]">
              S/ {{ (product().price + 578) | number:'1.2-2' }}
            </span>
          }
          <span class="text-black font-black text-sm">
            S/ {{ product().price | number:'1.2-2' }}
          </span>
        </div>
      </div>

      <!-- Main Product Container (2-Column Grid matching reference template) -->
      <div class="max-w-[1360px] mx-auto px-4 sm:px-6 lg:px-8 py-8 lg:py-10">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-start">
          
          <!-- ================= LEFT COLUMN: GALLERY & VALUE PROPOSITIONS ================= -->
          <div class="lg:col-span-5 space-y-6">
            
            <!-- Main Product Display Card -->
            <div class="relative bg-[#fcfcfc] rounded-2xl p-6 border border-gray-100 flex items-center justify-center min-h-[380px] sm:min-h-[460px] group select-none">
              
              <!-- Floating Badge / Offer Sticker (Top Right as in screenshot) -->
              <div class="absolute top-4 right-4 flex flex-col items-end gap-1.5 z-10">
                <div class="w-16 h-16 rounded-xl bg-amber-50/90 border border-amber-200/70 p-1 flex flex-col items-center justify-center text-center shadow-2xs">
                  <span class="text-[12px] font-black text-amber-900 leading-tight">8% OFF</span>
                  <span class="text-[9px] text-amber-700 font-semibold">Al suscribirse</span>
                </div>
              </div>

              <!-- Main Active Image -->
              <img 
                [src]="activeImage()" 
                [alt]="product().name"
                class="max-h-[340px] sm:max-h-[400px] w-auto object-contain transition-all duration-300 transform group-hover:scale-105 drop-shadow-md"
              />

              <!-- Floating Price Badge (Bottom Left as in screenshot) -->
              <div class="absolute bottom-5 left-5 bg-white/95 backdrop-blur-xs px-3.5 py-1.5 rounded-xl shadow-md border border-gray-100 flex items-center gap-2">
                <span class="text-lg sm:text-xl font-black text-black">
                  S/ {{ product().price | number:'1.0-0' }}
                </span>
                <span class="text-[10px] font-bold text-amber-800 bg-amber-100/70 px-2 py-0.5 rounded-md">
                  Oferta por tiempo limitado
                </span>
              </div>
            </div>

            <!-- Thumbnails Carousel / Row with < > buttons -->
            <div class="flex items-center justify-center gap-2 px-1">
              <button 
                type="button" 
                (click)="prevThumbnail()"
                class="w-7 h-7 rounded-full border border-gray-300 hover:border-black flex items-center justify-center text-gray-500 hover:text-black transition-colors cursor-pointer text-sm"
                aria-label="Anterior imagen"
              >
                &lsaquo;
              </button>

              <div class="flex items-center gap-2.5 overflow-x-auto py-1">
                @for (thumb of thumbnails(); track idx; let idx = $index) {
                  <button 
                    type="button"
                    (click)="selectedThumbIndex.set(idx)"
                    [class.border-black]="selectedThumbIndex() === idx"
                    [class.border-gray-200]="selectedThumbIndex() !== idx"
                    class="w-14 h-14 sm:w-16 sm:h-16 rounded-xl bg-gray-50 border-2 p-1 transition-all flex items-center justify-center hover:bg-white shadow-2xs cursor-pointer"
                  >
                    <img [src]="thumb" [alt]="'Vista ' + (idx + 1)" class="max-h-full max-w-full object-contain" />
                  </button>
                }
              </div>

              <button 
                type="button" 
                (click)="nextThumbnail()"
                class="w-7 h-7 rounded-full border border-gray-300 hover:border-black flex items-center justify-center text-gray-500 hover:text-black transition-colors cursor-pointer text-sm"
                aria-label="Siguiente imagen"
              >
                &rsaquo;
              </button>
            </div>

            <!-- 3 Trust Badges (Exact copy from reference screenshot) -->
            <div class="grid grid-cols-3 gap-3 pt-3 border-t border-gray-100 text-center">
              <div class="p-2.5 rounded-xl space-y-1">
                <div class="w-6 h-6 flex items-center justify-center mx-auto text-base">
                  🚚
                </div>
                <div class="text-[10px] font-black text-gray-900 tracking-wider">ENVÍO GRATIS</div>
                <div class="text-[9px] text-gray-500 leading-tight">Pedidos superiores a S/50 Soles</div>
              </div>

              <div class="p-2.5 rounded-xl space-y-1">
                <div class="w-6 h-6 flex items-center justify-center mx-auto text-base">
                  🛡️
                </div>
                <div class="text-[10px] font-black text-gray-900 tracking-wider">DEVOLUCIONES GRATUITAS</div>
                <div class="text-[9px] text-gray-500 leading-tight">EN 7 DÍAS</div>
              </div>

              <div class="p-2.5 rounded-xl space-y-1">
                <div class="w-6 h-6 flex items-center justify-center mx-auto text-base">
                  💳
                </div>
                <div class="text-[10px] font-black text-gray-900 tracking-wider">100% SEGURO</div>
                <div class="text-[9px] text-gray-500 leading-tight">PORTAL DE PAGOS</div>
              </div>
            </div>

          </div>

          <!-- ================= RIGHT COLUMN: PRODUCT CONFIGURATOR & PURCHASE ================= -->
          <div class="lg:col-span-7 space-y-5">
            
            <!-- Header & Rating Title -->
            <div class="space-y-1.5">
              <h1 class="text-xl sm:text-2xl font-black text-gray-900 tracking-tight leading-snug">
                {{ product().name }} {{ memoryOptions()[selectedMemoryIndex()] }} {{ activeColor().name }} Dual Card
              </h1>

              <div class="flex items-center gap-2 text-xs">
                <div class="flex items-center text-amber-500 text-sm tracking-tighter">
                  ★★★★★
                </div>
                <span class="font-bold text-gray-900">4.8</span>
                <span class="text-[#256fff] hover:underline cursor-pointer">30 reseñas en total &rsaquo;</span>
              </div>
            </div>

            <!-- Coupon Tag Banner (Exact match from screenshot) -->
            <div class="inline-flex items-center gap-2 px-3 py-1 bg-amber-50/70 border border-amber-200/80 rounded-md text-xs text-amber-900 font-medium">
              <span>🎟️ Cupón: 5% de descuento</span>
              <button 
                type="button" 
                (click)="aplicarCupon()"
                class="px-2 py-0.5 bg-amber-500 hover:bg-amber-600 text-white text-[10px] font-bold rounded-sm transition-colors cursor-pointer"
              >
                Obtener
              </button>
            </div>

            <!-- Blue Seasonal Promo Banner with Realtime Countdown (Exact layout) -->
            <div class="bg-gradient-to-r from-[#256fff] to-[#1a5ce6] rounded-xl p-4 sm:p-5 text-white shadow-xs space-y-2.5">
              <div>
                <h3 class="font-black text-base">Ofertas de Primavera</h3>
                <p class="text-xs text-blue-100">Aprovecha nuestros descuentos y promociones especiales.</p>
              </div>

              <div class="flex flex-wrap items-center gap-2 text-xs pt-0.5">
                <span class="font-bold text-white">Finaliza en</span>
                <div class="flex items-center gap-1.5 font-mono text-xs font-bold text-black">
                  <span class="px-2 py-0.5 bg-white rounded shadow-2xs">{{ countdown().days }}</span>
                  <span class="text-white text-[11px] font-sans">día(s) :</span>
                  <span class="px-2 py-0.5 bg-white rounded shadow-2xs">{{ countdown().hours }}</span>
                  <span class="text-white text-[11px] font-sans">h :</span>
                  <span class="px-2 py-0.5 bg-white rounded shadow-2xs">{{ countdown().minutes }}</span>
                  <span class="text-white text-[11px] font-sans">min :</span>
                  <span class="px-2 py-0.5 bg-white rounded shadow-2xs">{{ countdown().seconds }}</span>
                  <span class="text-white text-[11px] font-sans">s</span>
                </div>
                <span class="text-white ml-auto text-sm">⏱</span>
              </div>
            </div>

            <!-- Special Offers Bullet List -->
            <div class="space-y-2 text-xs text-gray-700 pt-1">
              <div class="font-bold text-gray-900 mb-1">Ofertas</div>
              
              <div class="flex items-start gap-2">
                <span class="text-sm">🎁</span>
                <span>Llévate gratis HONOR CHOICE Watch 2i + HONOR CHOICE Headphones Pro</span>
              </div>

              <div class="flex items-center gap-2">
                <span class="text-sm">🏷️</span>
                <span>¡Consigue tu cupón sorpresa del 5%! <strong>APEALL35</strong></span>
                <button 
                  type="button" 
                  (click)="copiarCupon()"
                  class="px-2 py-0.5 border border-gray-300 hover:border-black rounded text-[10px] font-bold text-gray-800 transition-colors cursor-pointer bg-white"
                >
                  Copiar
                </button>
              </div>

              <div class="flex items-start gap-2">
                <span class="text-sm">✉️</span>
                <span>Suscríbete y recibe un cupón de 8% de descuento. <a routerLink="/" class="text-[#256fff] font-medium hover:underline">Suscribirse &rsaquo;</a></span>
              </div>

              <div class="flex items-start gap-2">
                <span class="text-sm">💳</span>
                <span class="text-gray-600 leading-relaxed text-[11px]">
                  Hasta 12 cuotas sin interés con tarjetas BCP, BBVA y Diners participantes. La elegibilidad se determinará automáticamente al ingresar la tarjeta en el proceso de pago. Condiciones y tasas aplicables sujetas al banco emisor. Para verificar qué códigos Bin aplican a la promoción sin intereses, consulte los <span class="text-[#256fff] cursor-pointer hover:underline">Consulta términos y condiciones &rsaquo;</span>
                </span>
              </div>
            </div>

            <!-- Variant Option 1: MEMORIA (Pill Button from Screenshot) -->
            <div class="space-y-1.5 pt-2">
              <div class="font-bold text-xs uppercase tracking-wider text-gray-900">MEMORIA</div>
              <div class="flex flex-wrap gap-2.5">
                @for (mem of memoryOptions(); track mem; let idx = $index) {
                  <button 
                    type="button"
                    (click)="selectedMemoryIndex.set(idx)"
                    [class.border-black]="selectedMemoryIndex() === idx"
                    [class.font-bold]="selectedMemoryIndex() === idx"
                    [class.border-gray-300]="selectedMemoryIndex() !== idx"
                    class="min-w-[130px] px-5 py-2.5 rounded-lg border-2 text-xs text-gray-900 transition-all hover:border-black bg-white shadow-2xs cursor-pointer text-center"
                  >
                    {{ mem }}
                  </button>
                }
              </div>
            </div>

            <!-- Variant Option 2: COLOR (Color Swatches with Label and Price) -->
            <div class="space-y-1.5 pt-2">
              <div class="font-bold text-xs uppercase tracking-wider text-gray-900">COLOR</div>
              <div class="flex items-center gap-3">
                @for (col of product().colors; track col.name; let idx = $index) {
                  <button 
                    type="button"
                    (click)="seleccionarColor(idx)"
                    [style.backgroundColor]="col.hex"
                    [class.ring-2]="selectedColorIndex() === idx"
                    [class.ring-offset-2]="selectedColorIndex() === idx"
                    [class.ring-black]="selectedColorIndex() === idx"
                    class="w-7 h-7 rounded-full border border-black/20 ring-black transition-all hover:scale-110 shadow-2xs cursor-pointer"
                    [title]="col.name"
                  ></button>
                }
              </div>
              <div class="space-y-0.5 pt-1">
                <div class="text-xs font-semibold text-gray-900">{{ activeColor().name }}</div>
                <div class="text-xs text-gray-700">S/ {{ product().price | number:'1.2-2' }}</div>
              </div>
            </div>

            <!-- Add-on Section 1: Paquete HONOR Watch 6 (Collapsible accordion) -->
            <div class="space-y-2 pt-2 border-t border-gray-100">
              <button 
                type="button" 
                (click)="toggleAccordion('watch6')"
                class="w-full flex items-center justify-between text-xs font-bold text-gray-900 cursor-pointer py-1"
              >
                <span>Paquete HONOR Watch 6</span>
                <span class="text-xs text-gray-500">{{ isWatch6Open() ? '▲' : '▼' }}</span>
              </button>

              @if (isWatch6Open()) {
                <div class="space-y-2">
                  @for (addon of watch6Addons(); track addon.id) {
                    <div 
                      [class.border-black]="addon.selected"
                      [class.border-gray-200]="!addon.selected"
                      class="flex items-center justify-between p-3 rounded-lg border-2 bg-white hover:border-gray-400 transition-colors cursor-pointer select-none"
                      (click)="toggleAddon(addon.id)"
                    >
                      <div class="flex items-center gap-3">
                        <input 
                          type="checkbox" 
                          [checked]="addon.selected"
                          (click)="$event.stopPropagation()"
                          (change)="toggleAddon(addon.id)"
                          class="w-4 h-4 rounded text-black focus:ring-black border-gray-300 cursor-pointer"
                        />
                        <img [src]="addon.image" [alt]="addon.name" class="w-10 h-10 object-contain rounded p-0.5 bg-gray-50" />
                        <div>
                          <div class="font-bold text-xs text-gray-900">{{ addon.name }}</div>
                          @if (addon.colorDots) {
                            <div class="flex items-center gap-1.5 mt-1">
                              @for (c of addon.colorDots; track $index) {
                                <span class="w-3 h-3 rounded-full border border-black/20" [style.backgroundColor]="c"></span>
                              }
                            </div>
                          }
                        </div>
                      </div>

                      <div class="text-right">
                        <div class="font-bold text-xs text-black">S/ {{ addon.price | number:'1.2-2' }}</div>
                        <div class="text-[10px] text-gray-400 line-through">S/ {{ addon.originalPrice | number:'1.2-2' }}</div>
                      </div>
                    </div>
                  }
                </div>
              }
            </div>

            <!-- Add-on Section 2: Paquete (All 6 accessories from screenshot) -->
            <div class="space-y-2 pt-2 border-t border-gray-100">
              <button 
                type="button" 
                (click)="toggleAccordion('paquete')"
                class="w-full flex items-center justify-between text-xs font-bold text-gray-900 cursor-pointer py-1"
              >
                <span>Paquete</span>
                <span class="text-xs text-gray-500">{{ isPaqueteOpen() ? '▲' : '▼' }}</span>
              </button>

              @if (isPaqueteOpen()) {
                <div class="space-y-2">
                  @for (addon of regularAddons(); track addon.id) {
                    <div 
                      [class.border-black]="addon.selected"
                      [class.border-gray-200]="!addon.selected"
                      class="flex items-center justify-between p-3 rounded-lg border-2 bg-white hover:border-gray-400 transition-colors cursor-pointer select-none"
                      (click)="toggleAddon(addon.id)"
                    >
                      <div class="flex items-center gap-3">
                        <input 
                          type="checkbox" 
                          [checked]="addon.selected"
                          (click)="$event.stopPropagation()"
                          (change)="toggleAddon(addon.id)"
                          class="w-4 h-4 rounded text-black focus:ring-black border-gray-300 cursor-pointer"
                        />
                        <img [src]="addon.image" [alt]="addon.name" class="w-10 h-10 object-contain rounded p-0.5 bg-gray-50" />
                        <div>
                          <div class="font-bold text-xs text-gray-900">{{ addon.name }}</div>
                        </div>
                      </div>

                      <div class="text-right">
                        <div class="font-bold text-xs text-black">S/ {{ addon.price | number:'1.2-2' }}</div>
                        <div class="text-[10px] text-gray-400 line-through">S/ {{ addon.originalPrice | number:'1.2-2' }}</div>
                      </div>
                    </div>
                  }
                </div>
              }
            </div>

            <!-- Total Price Calculation & CTA Buttons -->
            <div class="p-5 bg-gray-50 rounded-2xl border border-gray-200 space-y-4 mt-6">
              <div class="flex items-center justify-between">
                <div>
                  <div class="text-xs text-gray-500 font-medium">Total configurado:</div>
                  <div class="text-2xl sm:text-3xl font-black text-black">
                    S/ {{ totalConfigurado() | number:'1.2-2' }}
                  </div>
                </div>

                <div class="text-right text-xs text-[#256fff] font-bold">
                  Hasta 12 cuotas de S/ {{ (totalConfigurado() / 12) | number:'1.2-2' }}
                </div>
              </div>

              <div class="flex items-center gap-3">
                <button 
                  type="button"
                  (click)="agregarAlCarrito()"
                  class="flex-1 py-3.5 bg-white hover:bg-gray-100 text-black border border-black font-bold text-xs rounded-full transition-all shadow-xs flex items-center justify-center gap-2 cursor-pointer active:scale-98"
                >
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
                  <span>Añadir al Carrito</span>
                </button>

                <button 
                  type="button"
                  (click)="comprarAhora()"
                  class="flex-1 py-3.5 bg-black hover:bg-[#256fff] text-white font-bold text-xs rounded-full transition-all shadow-md flex items-center justify-center gap-2 cursor-pointer active:scale-98"
                >
                  <span>Comprar Ahora</span>
                  <span>&rarr;</span>
                </button>
              </div>
            </div>

          </div>

        </div>
      </div>

    </div>
  `
})
export class ProductoDetallePage implements OnInit, OnDestroy {
  private route = inject(ActivatedRoute);
  private catalog = inject(CatalogService);
  private cart = inject(CartService);
  private toast = inject(ToastService);
  private platformId = inject(PLATFORM_ID);
  private router = inject(Router);

  productIdSignal = signal<string>('honor-600');
  selectedColorIndex = signal<number>(0);
  selectedMemoryIndex = signal<number>(0);
  selectedThumbIndex = signal<number>(0);

  isWatch6Open = signal<boolean>(true);
  isPaqueteOpen = signal<boolean>(true);

  countdown = signal({ days: 6, hours: 4, minutes: 16, seconds: 33 });
  private timer?: ReturnType<typeof setInterval>;

  // Product resolver
  product = computed<Product>(() => {
    return this.catalog.getProductById(this.productIdSignal()) || this.catalog.products[0];
  });

  activeColor = computed(() => {
    const p = this.product();
    const idx = this.selectedColorIndex();
    return p.colors[idx] || p.colors[0] || { name: 'Estándar', hex: '#000000', image: '' };
  });

  memoryOptions = computed(() => {
    const p = this.product();
    if (p.specs && p.specs.length > 0) {
      return [p.specs[0], 'Edición Pro Especial'];
    }
    return ['8GB+512GB', '16GB+512GB', '16GB+1TB'];
  });

  // Generates 5 thumbnails dynamically
  thumbnails = computed(() => {
    const col = this.activeColor();
    const baseImg = col.image;
    const secImg = col.secondaryImage || baseImg;
    return [baseImg, secImg, baseImg, secImg, baseImg];
  });

  activeImage = computed(() => {
    const thumbs = this.thumbnails();
    const idx = this.selectedThumbIndex();
    return thumbs[idx] || this.activeColor().image;
  });

  // Componentes adicionales y bundles gamer ENIAC Labs
  addons = signal<AddonBundle[]>([
    {
      id: 'ssd990',
      name: 'Samsung 990 PRO 2TB NVMe PCIe 4.0 Heatsink',
      price: 799.00,
      originalPrice: 899.00,
      image: '/images/ssd-nvme.jpg',
      selected: false,
      category: 'watch6',
      colorDots: ['#000000', '#dc2626']
    },
    {
      id: 'ram-ddr5-bundle',
      name: 'Corsair Vengeance RGB 32GB (2x16GB) DDR5 6000MHz',
      price: 549.00,
      originalPrice: 620.00,
      image: '/images/ram-ddr5.jpg',
      selected: false,
      category: 'paquete'
    },
    {
      id: 'aio-cooler-bundle',
      name: 'Refrigeración Líquida ARGB 360mm Infinity Mirror',
      price: 549.00,
      originalPrice: 649.00,
      image: '/images/aio-cooler.jpg',
      selected: false,
      category: 'paquete'
    },
    {
      id: 'psu-1000w-bundle',
      name: 'Fuente Corsair RM1000x 1000W 80 Plus Gold Modular',
      price: 799.00,
      originalPrice: 850.00,
      image: '/images/psu-1000w.jpg',
      selected: false,
      category: 'paquete'
    },
    {
      id: 'bracket-gpu',
      name: 'Soporte Vertical Anti-Sag ARGB para Tarjeta Gráfica',
      price: 89.00,
      originalPrice: 129.00,
      image: '/images/gpu-rtx4080.jpg',
      selected: false,
      category: 'paquete'
    },
    {
      id: 'ryzen7-bundle',
      name: 'AMD Ryzen 7 7800X3D Gaming CPU AM5 Box',
      price: 1299.00,
      originalPrice: 1399.00,
      image: '/images/cpu-ryzen7.jpg',
      selected: false,
      category: 'paquete'
    }
  ]);

  watch6Addons = computed(() => this.addons().filter(a => a.category === 'watch6'));
  regularAddons = computed(() => this.addons().filter(a => a.category === 'paquete'));

  totalConfigurado = computed(() => {
    const prodPrice = this.product().price;
    const addonsTotal = this.addons()
      .filter(a => a.selected)
      .reduce((sum, a) => sum + a.price, 0);
    return prodPrice + addonsTotal;
  });

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      const id = params.get('id');
      if (id) {
        this.productIdSignal.set(id);
        this.selectedColorIndex.set(0);
        this.selectedThumbIndex.set(0);
      }
    });

    if (isPlatformBrowser(this.platformId)) {
      window.scrollTo({ top: 0, behavior: 'smooth' });
      // Countdown clock
      this.timer = setInterval(() => {
        this.countdown.update(c => {
          let s = c.seconds - 1;
          let m = c.minutes;
          let h = c.hours;
          let d = c.days;

          if (s < 0) {
            s = 59;
            m--;
            if (m < 0) {
              m = 59;
              h--;
              if (h < 0) {
                h = 23;
                d = Math.max(0, d - 1);
              }
            }
          }
          return { days: d, hours: h, minutes: m, seconds: s };
        });
      }, 1000);
    }
  }

  ngOnDestroy() {
    if (this.timer) clearInterval(this.timer);
  }

  toggleAccordion(type: 'watch6' | 'paquete') {
    if (type === 'watch6') {
      this.isWatch6Open.update(v => !v);
    } else {
      this.isPaqueteOpen.update(v => !v);
    }
  }

  seleccionarColor(idx: number) {
    this.selectedColorIndex.set(idx);
    this.selectedThumbIndex.set(0);
  }

  prevThumbnail() {
    const current = this.selectedThumbIndex();
    const len = this.thumbnails().length;
    this.selectedThumbIndex.set((current - 1 + len) % len);
  }

  nextThumbnail() {
    const current = this.selectedThumbIndex();
    const len = this.thumbnails().length;
    this.selectedThumbIndex.set((current + 1) % len);
  }

  toggleAddon(addonId: string) {
    this.addons.update(list => 
      list.map(a => a.id === addonId ? { ...a, selected: !a.selected } : a)
    );
  }

  copiarCupon() {
    if (typeof navigator !== 'undefined' && navigator.clipboard) {
      navigator.clipboard.writeText('APEALL35');
    }
    this.toast.show('¡Cupón APEALL35 copiado al portapapeles!');
  }

  aplicarCupon() {
    this.toast.show('¡Cupón del 5% aplicado automáticamente!');
  }

  agregarAlCarrito() {
    const p = this.product();
    const col = this.activeColor();
    const mem = this.memoryOptions()[this.selectedMemoryIndex()] || '';

    this.cart.addToCart({
      id: p.id,
      name: `${p.name} (${mem})`,
      color: col.name,
      storage: mem,
      price: p.price,
      originalPrice: p.originalPrice,
      image: col.image
    });

    // Also add selected bundles
    this.addons().filter(a => a.selected).forEach(a => {
      this.cart.addToCart({
        id: a.id,
        name: a.name,
        color: 'Accesorio Oficial',
        price: a.price,
        originalPrice: a.originalPrice,
        image: a.image
      });
    });

    this.toast.show(`¡${p.name} añadido a tu carrito!`);
  }

  comprarAhora() {
    this.agregarAlCarrito();
    this.cart.closeCart();
    this.router.navigate(['/pagar']);
  }
}
