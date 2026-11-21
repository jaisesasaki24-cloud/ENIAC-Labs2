import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CatalogService, Product } from '../../services/catalog.service';

@Component({
  selector: 'app-category-slider',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule],
  template: `
    <div class="shop-main mt-16 max-w-[1400px] mx-auto px-4 sm:px-6">
      
      <!-- Section Title -->
      <div class="mb-8">
        <span class="text-xs font-bold uppercase tracking-wider text-[#256fff] bg-blue-50 px-3 py-1 rounded-full border border-blue-100">
          Hardware & Componentes
        </span>
        <h2 class="text-3xl sm:text-4xl font-black text-gray-950 tracking-tight mt-2">
          Comprar por categoría de Componentes
        </h2>
      </div>

      <!-- ================= 1. PROCESADORES & TARJETAS GRÁFICAS ================= -->
      <section class="section-wrap mb-16" id="category">
        <!-- Mobile Category Banner -->
        <div class="sm:hidden w-full mb-4 rounded-2xl overflow-hidden shadow-sm relative h-36 flex items-end p-4">
          <img src="/images/hero-pc-gamer.jpg" alt="Tarjetas Gráficas y CPUs" class="absolute inset-0 w-full h-full object-cover" />
          <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent"></div>
          <div class="relative z-10 text-white">
            <span class="text-[10px] font-bold text-blue-400 uppercase tracking-wider">ENIAC GAMING</span>
            <h3 class="text-base font-black">Tarjetas Gráficas & Procesadores</h3>
          </div>
        </div>

        <div class="relative group/slider">
          <!-- Slider Track -->
          <div #phoneTrack class="flex gap-5 overflow-x-auto pb-4 scrollbar-none scroll-smooth snap-x snap-mandatory">
            
            <!-- Category Banner Card (Desktop) -->
            <div class="hidden sm:flex flex-shrink-0 w-[312px] h-[480px] rounded-3xl overflow-hidden relative shadow-md flex-col justify-between p-6 group/bcard">
              <img src="/images/hero-pc-gamer.jpg" alt="Tarjetas Gráficas y CPUs" class="absolute inset-0 w-full h-full object-cover select-none -z-10 group-hover/bcard:scale-105 transition-transform duration-500" />
              <div class="absolute inset-0 bg-gradient-to-t from-black/95 via-black/40 to-transparent -z-10"></div>
              
              <div class="bg-black/50 backdrop-blur-sm px-3 py-1.5 rounded-full self-start border border-white/20">
                <span class="text-[11px] font-black uppercase tracking-wider text-blue-400">ENIAC GAMING</span>
              </div>
              
              <div class="text-white">
                <h3 class="text-2xl font-black leading-tight">
                  Tarjetas Gráficas & Procesadores
                </h3>
                <p class="text-xs text-gray-300 mt-2 leading-relaxed">
                  Arquitectura Ada Lovelace y AMD Zen 4 de última hornada para 4K nativo y alta tasa de cuadros.
                </p>
                <div class="mt-4 inline-flex items-center gap-1.5 text-xs font-bold text-white bg-[#256fff] hover:bg-[#1f5ee0] px-4 py-2 rounded-full transition-colors shadow">
                  Explorar Catálogo →
                </div>
              </div>
            </div>

            <!-- Hardware Cards -->
            @for (product of phoneProducts; track product.id) {
              <div class="flex-shrink-0 w-[290px] sm:w-[312px] bg-[#f9f9f9] rounded-3xl p-5 sm:p-6 flex flex-col justify-between relative shadow-xs hover:shadow-2xl hover:shadow-black/10 hover:scale-[1.03] hover:-translate-y-2 transition-all duration-300 ease-out transform-gpu snap-start">
                
                <!-- Badge (top-right) -->
                @if (product.badge) {
                  <div class="absolute top-5 right-5 z-10">
                    <span class="bg-[#256fff] text-white text-[11px] font-semibold px-3 py-1 rounded-full shadow-sm">
                      {{ product.badge }}
                    </span>
                  </div>
                }

                <!-- Product Image Button -->
                <button 
                  type="button"
                  (click)="onQuickBuy(product)"
                  class="h-56 w-full flex items-center justify-center my-2 cursor-pointer bg-transparent border-none p-0"
                  [attr.aria-label]="'Ver detalles de ' + product.name"
                >
                  <img 
                    [src]="getSelectedColorImage(product)" 
                    [alt]="product.name" 
                    class="max-h-52 object-contain hover:scale-105 transition-transform duration-300"
                  />
                </button>

                <!-- Product Info & Variant Swatches -->
                <div>
                  <div class="mb-3">
                    <h3 class="font-bold text-[16px] sm:text-[18px] text-gray-900 line-clamp-2">
                      {{ product.name }}
                    </h3>
                    
                    <!-- Color Swatches -->
                    <div class="flex items-center gap-2.5 mt-3">
                      @for (color of product.colors; track idx; let idx = $index) {
                        <button 
                          type="button"
                          (click)="selectColor(product.id, idx)"
                          [style.backgroundColor]="color.hex"
                          [class.ring-2]="selectedColors()[product.id] === idx || (!selectedColors()[product.id] && idx === 0)"
                          [class.ring-offset-2]="selectedColors()[product.id] === idx || (!selectedColors()[product.id] && idx === 0)"
                          class="w-5 h-5 rounded-full border border-black/20 ring-black transition-all hover:scale-110 cursor-pointer"
                          [title]="color.name"
                          [attr.aria-label]="color.name"
                        ></button>
                      }
                    </div>
                  </div>

                  <!-- Price Section -->
                  <div class="flex items-baseline gap-2.5 mb-4">
                    @if (product.originalPrice) {
                      <span class="text-xs sm:text-sm text-gray-400 line-through">
                        S/ {{ product.originalPrice | number:'1.0-0' }}
                      </span>
                    }
                    <span class="text-lg sm:text-xl font-bold text-black">
                      S/ {{ product.price | number:'1.0-0' }}
                    </span>
                  </div>

                  <!-- CTAs -->
                  <div class="flex items-center gap-3">
                    <button 
                      type="button" 
                      (click)="onQuickBuy(product)" 
                      class="px-5 py-2.5 bg-black text-white text-[13px] font-semibold rounded-full hover:bg-[#256fff] transition-colors cursor-pointer"
                    >
                      Comprar
                    </button>
                    <button 
                      type="button" 
                      (click)="onQuickBuy(product)" 
                      class="text-[13px] font-semibold text-black hover:text-[#256fff] flex items-center gap-1 transition-colors cursor-pointer"
                    >
                      Especificaciones →
                    </button>
                  </div>
                </div>

              </div>
            }

          </div>

          <!-- Slider Arrow Controls -->
          <button 
            type="button"
            (click)="scrollSlider(phoneTrack, -340)" 
            class="hidden sm:flex absolute left-[-20px] top-1/2 -translate-y-1/2 w-11 h-11 bg-black/60 hover:bg-black text-white rounded-full items-center justify-center shadow-lg z-20 transition-all opacity-80 hover:opacity-100 cursor-pointer"
            aria-label="Anterior"
          >
            ‹
          </button>
          <button 
            type="button"
            (click)="scrollSlider(phoneTrack, 340)" 
            class="hidden sm:flex absolute right-[-20px] top-1/2 -translate-y-1/2 w-11 h-11 bg-black/60 hover:bg-black text-white rounded-full items-center justify-center shadow-lg z-20 transition-all opacity-80 hover:opacity-100 cursor-pointer"
            aria-label="Siguiente"
          >
            ›
          </button>
        </div>
      </section>

      <!-- ================= 2. PLACAS MADRE & MEMORIAS RAM ================= -->
      <section class="section-wrap mb-16" id="tablets">
        <!-- Mobile Category Banner -->
        <div class="sm:hidden w-full mb-4 rounded-2xl overflow-hidden shadow-sm relative h-36 flex items-end p-4">
          <img src="/images/mobo-rog.jpg" alt="Placas Madre y RAM" class="absolute inset-0 w-full h-full object-cover" />
          <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent"></div>
          <div class="relative z-10 text-white">
            <span class="text-[10px] font-bold text-blue-400 uppercase tracking-wider">OVERCLOCKING</span>
            <h3 class="text-base font-black">Placas Madre & Memorias RAM</h3>
          </div>
        </div>

        <div class="relative group/slider">
          <div #tabletTrack class="flex gap-5 overflow-x-auto pb-4 scrollbar-none scroll-smooth snap-x snap-mandatory">
            
            <!-- Category Banner Card (Desktop) -->
            <div class="hidden sm:flex flex-shrink-0 w-[312px] h-[480px] rounded-3xl overflow-hidden relative shadow-md flex-col justify-between p-6 group/bcard">
              <img src="/images/mobo-rog.jpg" alt="Placas Madre y RAM" class="absolute inset-0 w-full h-full object-cover select-none -z-10 group-hover/bcard:scale-105 transition-transform duration-500" />
              <div class="absolute inset-0 bg-gradient-to-t from-black/95 via-black/40 to-transparent -z-10"></div>
              
              <div class="bg-black/50 backdrop-blur-sm px-3 py-1.5 rounded-full self-start border border-white/20">
                <span class="text-[11px] font-black uppercase tracking-wider text-blue-400">OVERCLOCKING</span>
              </div>
              
              <div class="text-white">
                <h3 class="text-2xl font-black leading-tight">
                  Placas Madre & Memorias DDR5
                </h3>
                <p class="text-xs text-gray-300 mt-2 leading-relaxed">
                  Zócalos Intel LGA1700 y AMD AM5 con soporte PCIe 5.0 y perfiles XMP/EXPO de hasta 8000+ MHz.
                </p>
                <div class="mt-4 inline-flex items-center gap-1.5 text-xs font-bold text-white bg-[#256fff] hover:bg-[#1f5ee0] px-4 py-2 rounded-full transition-colors shadow">
                  Explorar Placas →
                </div>
              </div>
            </div>

            <!-- Hardware Cards -->
            @for (product of tabletProducts; track product.id) {
              <div class="flex-shrink-0 w-[290px] sm:w-[312px] bg-[#f9f9f9] rounded-3xl p-5 sm:p-6 flex flex-col justify-between relative shadow-xs hover:shadow-2xl hover:shadow-black/10 hover:scale-[1.03] hover:-translate-y-2 transition-all duration-300 ease-out transform-gpu snap-start">
                
                @if (product.badge) {
                  <div class="absolute top-5 right-5 z-10">
                    <span class="bg-[#256fff] text-white text-[11px] font-semibold px-3 py-1 rounded-full shadow-sm">
                      {{ product.badge }}
                    </span>
                  </div>
                }

                <button 
                  type="button"
                  (click)="onQuickBuy(product)"
                  class="h-56 w-full flex items-center justify-center my-2 cursor-pointer bg-transparent border-none p-0"
                  [attr.aria-label]="'Ver detalles de ' + product.name"
                >
                  <img [src]="getSelectedColorImage(product)" [alt]="product.name" class="max-h-52 object-contain hover:scale-105 transition-transform duration-300" />
                </button>

                <div>
                  <div class="mb-3">
                    <h3 class="font-bold text-[16px] sm:text-[18px] text-gray-900 line-clamp-2">
                      {{ product.name }}
                    </h3>
                    
                    <div class="flex items-center gap-2.5 mt-3">
                      @for (color of product.colors; track idx; let idx = $index) {
                        <button 
                          type="button"
                          (click)="selectColor(product.id, idx)"
                          [style.backgroundColor]="color.hex"
                          [class.ring-2]="selectedColors()[product.id] === idx || (!selectedColors()[product.id] && idx === 0)"
                          [class.ring-offset-2]="selectedColors()[product.id] === idx || (!selectedColors()[product.id] && idx === 0)"
                          class="w-5 h-5 rounded-full border border-black/20 ring-black transition-all cursor-pointer"
                          [title]="color.name"
                          [attr.aria-label]="color.name"
                        ></button>
                      }
                    </div>
                  </div>

                  <div class="flex items-baseline gap-2.5 mb-4">
                    @if (product.originalPrice) {
                      <span class="text-xs sm:text-sm text-gray-400 line-through">
                        S/ {{ product.originalPrice | number:'1.0-0' }}
                      </span>
                    }
                    <span class="text-lg sm:text-xl font-bold text-black">
                      S/ {{ product.price | number:'1.0-0' }}
                    </span>
                  </div>

                  <div class="flex items-center gap-3">
                    <button type="button" (click)="onQuickBuy(product)" class="px-5 py-2.5 bg-black text-white text-[13px] font-semibold rounded-full hover:bg-[#256fff] transition-colors cursor-pointer">
                      Comprar
                    </button>
                    <button type="button" (click)="onQuickBuy(product)" class="text-[13px] font-semibold text-black hover:text-[#256fff] flex items-center gap-1 transition-colors cursor-pointer">
                      Especificaciones →
                    </button>
                  </div>
                </div>

              </div>
            }

          </div>

          <button type="button" (click)="scrollSlider(tabletTrack, -340)" class="hidden sm:flex absolute left-[-20px] top-1/2 -translate-y-1/2 w-11 h-11 bg-black/60 hover:bg-black text-white rounded-full items-center justify-center shadow-lg z-20 transition-all opacity-80 hover:opacity-100 cursor-pointer" aria-label="Anterior">‹</button>
          <button type="button" (click)="scrollSlider(tabletTrack, 340)" class="hidden sm:flex absolute right-[-20px] top-1/2 -translate-y-1/2 w-11 h-11 bg-black/60 hover:bg-black text-white rounded-full items-center justify-center shadow-lg z-20 transition-all opacity-80 hover:opacity-100 cursor-pointer" aria-label="Siguiente">›</button>
        </div>
      </section>

      <!-- ================= 3. ALMACENAMIENTO & REFRIGERACIÓN ================= -->
      <section class="section-wrap mb-16" id="others">
        <!-- Mobile Category Banner -->
        <div class="sm:hidden w-full mb-4 rounded-2xl overflow-hidden shadow-sm relative h-36 flex items-end p-4">
          <img src="/images/ssd-nvme.jpg" alt="Almacenamiento y Refrigeración" class="absolute inset-0 w-full h-full object-cover" />
          <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent"></div>
          <div class="relative z-10 text-white">
            <span class="text-[10px] font-bold text-blue-400 uppercase tracking-wider">MÁXIMA VELOCIDAD</span>
            <h3 class="text-base font-black">SSD NVMe & Refrigeración Líquida</h3>
          </div>
        </div>

        <div class="relative group/slider">
          <div #wearTrack class="flex gap-5 overflow-x-auto pb-4 scrollbar-none scroll-smooth snap-x snap-mandatory">
            
            <!-- Category Banner Card (Desktop) -->
            <div class="hidden sm:flex flex-shrink-0 w-[312px] h-[480px] rounded-3xl overflow-hidden relative shadow-md flex-col justify-between p-6 group/bcard">
              <img src="/images/ssd-nvme.jpg" alt="Almacenamiento y Refrigeración" class="absolute inset-0 w-full h-full object-cover select-none -z-10 group-hover/bcard:scale-105 transition-transform duration-500" />
              <div class="absolute inset-0 bg-gradient-to-t from-black/95 via-black/40 to-transparent -z-10"></div>
              
              <div class="bg-black/50 backdrop-blur-sm px-3 py-1.5 rounded-full self-start border border-white/20">
                <span class="text-[11px] font-black uppercase tracking-wider text-blue-400">MÁXIMA VELOCIDAD</span>
              </div>
              
              <div class="text-white">
                <h3 class="text-2xl font-black leading-tight">
                  Almacenamiento SSD & Refrigeración
                </h3>
                <p class="text-xs text-gray-300 mt-2 leading-relaxed">
                  Lecturas secuenciales hasta 7450 MB/s con Samsung 990 PRO y refrigeración líquida triple fan silenciosa.
                </p>
                <div class="mt-4 inline-flex items-center gap-1.5 text-xs font-bold text-white bg-[#256fff] hover:bg-[#1f5ee0] px-4 py-2 rounded-full transition-colors shadow">
                  Explorar Almacenamiento →
                </div>
              </div>
            </div>

            @for (product of wearableProducts; track product.id) {
              <div class="flex-shrink-0 w-[290px] sm:w-[312px] bg-[#f9f9f9] rounded-3xl p-5 sm:p-6 flex flex-col justify-between relative shadow-xs hover:shadow-2xl hover:shadow-black/10 hover:scale-[1.03] hover:-translate-y-2 transition-all duration-300 ease-out transform-gpu snap-start">
                
                @if (product.badge) {
                  <div class="absolute top-5 right-5 z-10">
                    <span class="bg-[#256fff] text-white text-[11px] font-semibold px-3 py-1 rounded-full shadow-sm">
                      {{ product.badge }}
                    </span>
                  </div>
                }

                <button 
                  type="button"
                  (click)="onQuickBuy(product)"
                  class="h-56 w-full flex items-center justify-center my-2 cursor-pointer bg-transparent border-none p-0"
                  [attr.aria-label]="'Ver detalles de ' + product.name"
                >
                  <img [src]="getSelectedColorImage(product)" [alt]="product.name" class="max-h-52 object-contain hover:scale-105 transition-transform duration-300" />
                </button>

                <div>
                  <div class="mb-3">
                    <h3 class="font-bold text-[16px] sm:text-[18px] text-gray-900 line-clamp-2">
                      {{ product.name }}
                    </h3>
                    
                    <div class="flex items-center gap-2.5 mt-3 min-h-[20px]">
                      @for (color of product.colors; track idx; let idx = $index) {
                        <button 
                          type="button"
                          (click)="selectColor(product.id, idx)"
                          [style.backgroundColor]="color.hex"
                          [class.ring-2]="selectedColors()[product.id] === idx || (!selectedColors()[product.id] && idx === 0)"
                          [class.ring-offset-2]="selectedColors()[product.id] === idx || (!selectedColors()[product.id] && idx === 0)"
                          class="w-5 h-5 rounded-full border border-black/20 ring-black transition-all cursor-pointer"
                          [title]="color.name"
                          [attr.aria-label]="color.name"
                        ></button>
                      }
                    </div>
                  </div>

                  <div class="flex items-baseline gap-2.5 mb-4">
                    @if (product.originalPrice) {
                      <span class="text-xs sm:text-sm text-gray-400 line-through">
                        S/ {{ product.originalPrice | number:'1.0-0' }}
                      </span>
                    }
                    <span class="text-lg sm:text-xl font-bold text-black">
                      S/ {{ product.price | number:'1.0-0' }}
                    </span>
                  </div>

                  <div class="flex items-center gap-3">
                    <button type="button" (click)="onQuickBuy(product)" class="px-5 py-2.5 bg-black text-white text-[13px] font-semibold rounded-full hover:bg-[#256fff] transition-colors cursor-pointer">
                      Comprar
                    </button>
                    <button type="button" (click)="onQuickBuy(product)" class="text-[13px] font-semibold text-black hover:text-[#256fff] flex items-center gap-1 transition-colors cursor-pointer">
                      Especificaciones →
                    </button>
                  </div>
                </div>

              </div>
            }

          </div>

          <button type="button" (click)="scrollSlider(wearTrack, -340)" class="hidden sm:flex absolute left-[-20px] top-1/2 -translate-y-1/2 w-11 h-11 bg-black/60 hover:bg-black text-white rounded-full items-center justify-center shadow-lg z-20 transition-all opacity-80 hover:opacity-100 cursor-pointer" aria-label="Anterior">‹</button>
          <button type="button" (click)="scrollSlider(wearTrack, 340)" class="hidden sm:flex absolute right-[-20px] top-1/2 -translate-y-1/2 w-11 h-11 bg-black/60 hover:bg-black text-white rounded-full items-center justify-center shadow-lg z-20 transition-all opacity-80 hover:opacity-100 cursor-pointer" aria-label="Siguiente">›</button>
        </div>
      </section>

      <!-- ================= 4. FUENTES DE PODER & GABINETES ================= -->
      <section class="section-wrap mb-16" id="HONOR_CHOICE">
        <!-- Mobile Category Banner -->
        <div class="sm:hidden w-full mb-4 rounded-2xl overflow-hidden shadow-sm relative h-36 flex items-end p-4">
          <img src="/images/hero-pc-rig.jpg" alt="Fuentes y Gabinetes" class="absolute inset-0 w-full h-full object-cover" />
          <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent"></div>
          <div class="relative z-10 text-white">
            <span class="text-[10px] font-bold text-blue-400 uppercase tracking-wider">CHASIS & PODER</span>
            <h3 class="text-base font-black">Fuentes 80+ & Gabinetes Gamer</h3>
          </div>
        </div>

        <div class="relative group/slider">
          <div #choiceTrack class="flex gap-5 overflow-x-auto pb-4 scrollbar-none scroll-smooth snap-x snap-mandatory">
            
            <!-- Category Banner Card (Desktop) -->
            <div class="hidden sm:flex flex-shrink-0 w-[312px] h-[480px] rounded-3xl overflow-hidden relative shadow-md flex-col justify-between p-6 group/bcard">
              <img src="/images/hero-pc-rig.jpg" alt="Fuentes y Gabinetes" class="absolute inset-0 w-full h-full object-cover select-none -z-10 group-hover/bcard:scale-105 transition-transform duration-500" />
              <div class="absolute inset-0 bg-gradient-to-t from-black/95 via-black/40 to-transparent -z-10"></div>
              
              <div class="bg-black/50 backdrop-blur-sm px-3 py-1.5 rounded-full self-start border border-white/20">
                <span class="text-[11px] font-black uppercase tracking-wider text-blue-400">CHASIS & PODER</span>
              </div>
              
              <div class="text-white">
                <h3 class="text-2xl font-black leading-tight">
                  Fuentes Modulares & Gabinetes
                </h3>
                <p class="text-xs text-gray-300 mt-2 leading-relaxed">
                  Eficiencia 80 PLUS Gold con condensadores 100% japoneses y chasis con cristal templado panorámico.
                </p>
                <div class="mt-4 inline-flex items-center gap-1.5 text-xs font-bold text-white bg-[#256fff] hover:bg-[#1f5ee0] px-4 py-2 rounded-full transition-colors shadow">
                  Explorar Gabinetes →
                </div>
              </div>
            </div>

            @for (product of choiceProducts; track product.id) {
              <div class="flex-shrink-0 w-[290px] sm:w-[312px] bg-[#f9f9f9] rounded-3xl p-5 sm:p-6 flex flex-col justify-between relative shadow-xs hover:shadow-2xl hover:shadow-black/10 hover:scale-[1.03] hover:-translate-y-2 transition-all duration-300 ease-out transform-gpu snap-start">
                
                @if (product.badge) {
                  <div class="absolute top-5 right-5 z-10">
                    <span class="bg-[#256fff] text-white text-[11px] font-semibold px-3 py-1 rounded-full shadow-sm">
                      {{ product.badge }}
                    </span>
                  </div>
                }

                <button 
                  type="button"
                  (click)="onQuickBuy(product)"
                  class="h-56 w-full flex items-center justify-center my-2 cursor-pointer bg-transparent border-none p-0"
                  [attr.aria-label]="'Ver detalles de ' + product.name"
                >
                  <img [src]="getSelectedColorImage(product)" [alt]="product.name" class="max-h-52 object-contain hover:scale-105 transition-transform duration-300" />
                </button>

                <div>
                  <div class="mb-3">
                    <h3 class="font-bold text-[16px] sm:text-[18px] text-gray-900 line-clamp-2">
                      {{ product.name }}
                    </h3>
                    
                    <div class="flex items-center gap-2.5 mt-3 min-h-[20px]">
                      @for (color of product.colors; track idx; let idx = $index) {
                        <button 
                          type="button"
                          (click)="selectColor(product.id, idx)"
                          [style.backgroundColor]="color.hex"
                          [class.ring-2]="selectedColors()[product.id] === idx || (!selectedColors()[product.id] && idx === 0)"
                          [class.ring-offset-2]="selectedColors()[product.id] === idx || (!selectedColors()[product.id] && idx === 0)"
                          class="w-5 h-5 rounded-full border border-black/20 ring-black transition-all cursor-pointer"
                          [title]="color.name"
                          [attr.aria-label]="color.name"
                        ></button>
                      }
                    </div>
                  </div>

                  <div class="flex items-baseline gap-2.5 mb-4">
                    @if (product.originalPrice) {
                      <span class="text-xs sm:text-sm text-gray-400 line-through">
                        S/ {{ product.originalPrice | number:'1.0-0' }}
                      </span>
                    }
                    <span class="text-lg sm:text-xl font-bold text-black">
                      S/ {{ product.price | number:'1.0-0' }}
                    </span>
                  </div>

                  <div class="flex items-center gap-3">
                    <button type="button" (click)="onQuickBuy(product)" class="px-5 py-2.5 bg-black text-white text-[13px] font-semibold rounded-full hover:bg-[#256fff] transition-colors cursor-pointer">
                      Comprar
                    </button>
                    <button type="button" (click)="onQuickBuy(product)" class="text-[13px] font-semibold text-black hover:text-[#256fff] flex items-center gap-1 transition-colors cursor-pointer">
                      Especificaciones →
                    </button>
                  </div>
                </div>

              </div>
            }

          </div>

          <button type="button" (click)="scrollSlider(choiceTrack, -340)" class="hidden sm:flex absolute left-[-20px] top-1/2 -translate-y-1/2 w-11 h-11 bg-black/60 hover:bg-black text-white rounded-full items-center justify-center shadow-lg z-20 transition-all opacity-80 hover:opacity-100 cursor-pointer" aria-label="Anterior">‹</button>
          <button type="button" (click)="scrollSlider(choiceTrack, 340)" class="hidden sm:flex absolute right-[-20px] top-1/2 -translate-y-1/2 w-11 h-11 bg-black/60 hover:bg-black text-white rounded-full items-center justify-center shadow-lg z-20 transition-all opacity-80 hover:opacity-100 cursor-pointer" aria-label="Siguiente">›</button>
        </div>
      </section>

    </div>
  `,
  styles: [`
    .scrollbar-none::-webkit-scrollbar {
      display: none;
    }
    .scrollbar-none {
      -ms-overflow-style: none;
      scrollbar-width: none;
    }
  `]
})
export class CategorySliderComponent {
  catalog = inject(CatalogService);

  selectedColors = signal<Record<string, number>>({});

  phoneProducts = this.catalog.products.filter(p => p.category === 'phones');
  tabletProducts = this.catalog.products.filter(p => p.category === 'tablets');
  wearableProducts = this.catalog.products.filter(p => p.category === 'wearables');
  choiceProducts = this.catalog.products.filter(p => p.category === 'choice');

  selectColor(productId: string, index: number) {
    this.selectedColors.update(prev => ({
      ...prev,
      [productId]: index
    }));
  }

  getSelectedColorImage(product: Product): string {
    const idx = this.selectedColors()[product.id] ?? 0;
    return product.colors[idx]?.image || product.colors[0].image;
  }

  onQuickBuy(product: Product) {
    this.catalog.openQuickBuy(product);
  }

  scrollSlider(element: HTMLElement, delta: number) {
    element.scrollBy({ left: delta, behavior: 'smooth' });
  }
}
