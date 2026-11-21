import { ChangeDetectionStrategy, Component, computed, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ToastService } from '../../services/toast.service';

interface PartOption {
  id: string;
  name: string;
  price: number;
  tdp: number;
  score: number;
}

@Component({
  selector: 'app-explorar-page',
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
            <span class="text-black font-semibold">Explorar & Configurador</span>
          </nav>
        </div>
      </div>

      <!-- Hero Header Section -->
      <section class="relative overflow-hidden bg-gradient-to-r from-[#16120e] via-[#241c14] to-[#120e0a] text-white py-14 lg:py-20 border-b border-white/10">
        <div class="max-w-[1400px] mx-auto px-4 sm:px-6 relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
          
          <div class="lg:col-span-7 space-y-4">
            <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-amber-500/10 backdrop-blur-md text-xs font-semibold text-amber-300 border border-amber-500/20">
              <span class="w-2 h-2 rounded-full bg-amber-400 animate-pulse"></span>
              Simulador Inteligente de Compatibilidad 2026
            </div>

            <h1 class="text-3xl sm:text-5xl lg:text-6xl font-black tracking-tight leading-[1.1]">
              Configurador PC <br />
              <span class="text-transparent bg-clip-text bg-gradient-to-r from-amber-400 via-orange-300 to-yellow-300">Cero Cuello de Botella</span>
            </h1>

            <p class="text-base sm:text-lg text-neutral-300 max-w-xl leading-relaxed">
              Elige tus piezas favoritas y observa en tiempo real los FPS estimados en juegos competitivos, consumo de energía recomendado y precio total al instante.
            </p>

            <div class="pt-2 flex flex-wrap items-center gap-3">
              <a 
                href="#simulador" 
                class="px-7 py-3 rounded-full bg-amber-500 text-neutral-950 font-bold text-sm hover:bg-amber-400 transition-all shadow-md active:scale-95 inline-flex items-center gap-2"
              >
                🛠 Comenzar a Armar
              </a>

              <button 
                type="button"
                (click)="loadRecommendedPreset()"
                class="px-7 py-3 rounded-full bg-white/10 hover:bg-white/20 text-white text-sm font-semibold border border-white/15 transition-all"
              >
                Cargar Setup Recomendado
              </button>
            </div>
          </div>

          <!-- Hero Graphic: Live Total Floating Display -->
          <div class="lg:col-span-5 flex items-center justify-center relative">
            <div class="relative w-full max-w-[380px] rounded-3xl bg-neutral-900 border border-amber-500/30 p-6 flex flex-col justify-between shadow-2xl space-y-4">
              <div class="flex items-center justify-between text-xs font-mono">
                <span class="text-amber-400 font-bold">PRESUPUESTO EN VIVO</span>
                <span class="bg-emerald-500/20 text-emerald-300 px-2 py-0.5 rounded-full text-[10px]">100% Compatible</span>
              </div>

              <!-- Price Display -->
              <div class="py-4 border-y border-white/10 text-center">
                <div class="text-4xl sm:text-5xl font-black text-white font-mono">
                  S/ {{ totalPrice() | number:'1.0-0' }}
                </div>
                <div class="text-xs text-neutral-400 mt-1 font-mono">
                  Consumo Estimado: <span class="text-amber-400 font-bold">{{ totalWatts() }} Watts</span>
                </div>
              </div>

              <!-- Performance metrics preview -->
              <div class="grid grid-cols-2 gap-3 text-xs font-mono text-neutral-300">
                <div class="bg-white/5 p-3 rounded-xl">
                  <span class="text-neutral-500 block text-[10px]">Cyberpunk 1440p</span>
                  <span class="font-bold text-white text-sm">{{ estimatedFpsCyberpunk() }} FPS</span>
                </div>
                <div class="bg-white/5 p-3 rounded-xl">
                  <span class="text-neutral-500 block text-[10px]">Valorant 1080p</span>
                  <span class="font-bold text-white text-sm">{{ estimatedFpsValorant() }} FPS</span>
                </div>
              </div>
            </div>
          </div>

        </div>
      </section>

      <!-- Main Interactive Builder Section -->
      <main id="simulador" class="max-w-[1400px] mx-auto px-4 sm:px-6 py-12">
        
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          
          <!-- Left Column: Component Pickers (8 cols) -->
          <div class="lg:col-span-8 space-y-6">
            
            <div class="flex items-center justify-between">
              <div>
                <h2 class="text-2xl font-black text-neutral-950 tracking-tight">
                  Selección de Componentes
                </h2>
                <p class="text-xs text-neutral-500 mt-0.5">
                  Haz clic en cada componente para cambiar de modelo
                </p>
              </div>

              <button 
                type="button" 
                (click)="resetConfig()"
                class="text-xs font-bold text-neutral-500 hover:text-black transition-colors"
              >
                ↻ Reiniciar
              </button>
            </div>

            <!-- 1. CPU Selector -->
            <div class="bg-white rounded-3xl p-6 border border-black/5 shadow-2xs space-y-3">
              <div class="flex items-center justify-between">
                <span class="text-xs font-bold uppercase tracking-wider text-neutral-400 font-mono">1. Procesador (CPU)</span>
                <span class="text-xs font-bold text-[#256fff]">AM5 / LGA1700</span>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                @for (cpu of cpuOptions; track cpu.id) {
                  <button 
                    type="button"
                    (click)="selectedCpu.set(cpu)"
                    [class.border-black]="selectedCpu().id === cpu.id"
                    [class.bg-neutral-50]="selectedCpu().id === cpu.id"
                    [class.ring-2]="selectedCpu().id === cpu.id"
                    [class.ring-black]="selectedCpu().id === cpu.id"
                    class="p-3.5 rounded-2xl border border-black/10 text-left transition-all hover:border-black cursor-pointer flex flex-col justify-between"
                  >
                    <div class="font-bold text-neutral-900 text-xs">{{ cpu.name }}</div>
                    <div class="flex items-center justify-between mt-2 pt-2 border-t border-black/5 text-[11px] font-mono">
                      <span class="text-neutral-500">{{ cpu.tdp }}W TDP</span>
                      <span class="font-black text-neutral-950">S/ {{ cpu.price }}</span>
                    </div>
                  </button>
                }
              </div>
            </div>

            <!-- 2. GPU Selector -->
            <div class="bg-white rounded-3xl p-6 border border-black/5 shadow-2xs space-y-3">
              <div class="flex items-center justify-between">
                <span class="text-xs font-bold uppercase tracking-wider text-neutral-400 font-mono">2. Tarjeta Gráfica (GPU)</span>
                <span class="text-xs font-bold text-emerald-600">Ray Tracing & DLSS 3.5</span>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                @for (gpu of gpuOptions; track gpu.id) {
                  <button 
                    type="button"
                    (click)="selectedGpu.set(gpu)"
                    [class.border-black]="selectedGpu().id === gpu.id"
                    [class.bg-neutral-50]="selectedGpu().id === gpu.id"
                    [class.ring-2]="selectedGpu().id === gpu.id"
                    [class.ring-black]="selectedGpu().id === gpu.id"
                    class="p-3.5 rounded-2xl border border-black/10 text-left transition-all hover:border-black cursor-pointer flex flex-col justify-between"
                  >
                    <div class="font-bold text-neutral-900 text-xs">{{ gpu.name }}</div>
                    <div class="flex items-center justify-between mt-2 pt-2 border-t border-black/5 text-[11px] font-mono">
                      <span class="text-neutral-500">{{ gpu.tdp }}W Consumo</span>
                      <span class="font-black text-neutral-950">S/ {{ gpu.price }}</span>
                    </div>
                  </button>
                }
              </div>
            </div>

            <!-- 3. RAM Selector -->
            <div class="bg-white rounded-3xl p-6 border border-black/5 shadow-2xs space-y-3">
              <div class="flex items-center justify-between">
                <span class="text-xs font-bold uppercase tracking-wider text-neutral-400 font-mono">3. Memoria RAM DDR5</span>
                <span class="text-xs font-bold text-purple-600">Dual Channel 6000MHz</span>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                @for (ram of ramOptions; track ram.id) {
                  <button 
                    type="button"
                    (click)="selectedRam.set(ram)"
                    [class.border-black]="selectedRam().id === ram.id"
                    [class.bg-neutral-50]="selectedRam().id === ram.id"
                    [class.ring-2]="selectedRam().id === ram.id"
                    [class.ring-black]="selectedRam().id === ram.id"
                    class="p-3.5 rounded-2xl border border-black/10 text-left transition-all hover:border-black cursor-pointer flex flex-col justify-between"
                  >
                    <div class="font-bold text-neutral-900 text-xs">{{ ram.name }}</div>
                    <div class="flex items-center justify-between mt-2 pt-2 border-t border-black/5 text-[11px] font-mono">
                      <span class="text-neutral-500">CL30 Latencia</span>
                      <span class="font-black text-neutral-950">S/ {{ ram.price }}</span>
                    </div>
                  </button>
                }
              </div>
            </div>

            <!-- 4. SSD Selector -->
            <div class="bg-white rounded-3xl p-6 border border-black/5 shadow-2xs space-y-3">
              <div class="flex items-center justify-between">
                <span class="text-xs font-bold uppercase tracking-wider text-neutral-400 font-mono">4. Almacenamiento SSD NVMe</span>
                <span class="text-xs font-bold text-cyan-600">PCIe 4.0 7000+ MB/s</span>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                @for (ssd of ssdOptions; track ssd.id) {
                  <button 
                    type="button"
                    (click)="selectedSsd.set(ssd)"
                    [class.border-black]="selectedSsd().id === ssd.id"
                    [class.bg-neutral-50]="selectedSsd().id === ssd.id"
                    [class.ring-2]="selectedSsd().id === ssd.id"
                    [class.ring-black]="selectedSsd().id === ssd.id"
                    class="p-3.5 rounded-2xl border border-black/10 text-left transition-all hover:border-black cursor-pointer flex flex-col justify-between"
                  >
                    <div class="font-bold text-neutral-900 text-xs">{{ ssd.name }}</div>
                    <div class="flex items-center justify-between mt-2 pt-2 border-t border-black/5 text-[11px] font-mono">
                      <span class="text-neutral-500">NVMe M.2 2280</span>
                      <span class="font-black text-neutral-950">S/ {{ ssd.price }}</span>
                    </div>
                  </button>
                }
              </div>
            </div>

          </div>

          <!-- Right Column: Sticky Summary & Benchmarks (4 cols) -->
          <div class="lg:col-span-4 sticky top-24 space-y-6">
            
            <div class="bg-white rounded-3xl p-6 border border-black/5 shadow-lg space-y-5">
              <h3 class="text-lg font-black text-neutral-950 border-b border-black/5 pb-3">
                Resumen de tu Ensamble
              </h3>

              <div class="space-y-3 text-xs">
                <div class="flex items-center justify-between">
                  <span class="text-neutral-500">Procesador</span>
                  <span class="font-bold text-neutral-900 text-right">{{ selectedCpu().name }}</span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-neutral-500">Gráfica</span>
                  <span class="font-bold text-neutral-900 text-right">{{ selectedGpu().name }}</span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-neutral-500">Memoria</span>
                  <span class="font-bold text-neutral-900 text-right">{{ selectedRam().name }}</span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-neutral-500">Disco</span>
                  <span class="font-bold text-neutral-900 text-right">{{ selectedSsd().name }}</span>
                </div>
              </div>

              <!-- Power & PSU Recommendation -->
              <div class="bg-amber-50 border border-amber-200/60 rounded-2xl p-4 text-xs space-y-1">
                <div class="font-bold text-amber-900 flex items-center justify-between">
                  <span>Fuente de Poder Recomendada:</span>
                  <span class="font-mono text-sm">{{ recommendedPsu() }}W</span>
                </div>
                <p class="text-amber-700 text-[11px]">
                  Consumo estimado del sistema: {{ totalWatts() }}W. Margen del 35% para picos transitorios.
                </p>
              </div>

              <!-- Total price & Actions -->
              <div class="pt-2 border-t border-black/5">
                <div class="flex items-baseline justify-between mb-4">
                  <span class="text-xs text-neutral-500">Total en Soles:</span>
                  <span class="text-3xl font-black text-neutral-950 font-mono">
                    S/ {{ totalPrice() | number:'1.0-0' }}
                  </span>
                </div>

                <div class="space-y-2">
                  <button 
                    type="button"
                    (click)="checkoutConfig()"
                    class="w-full py-3.5 rounded-full bg-black text-white text-xs font-bold hover:bg-[#256fff] transition-colors shadow-md active:scale-95 cursor-pointer"
                  >
                    Cotizar Ensamble Completo
                  </button>

                  <button 
                    type="button"
                    (click)="copyBuildSummary()"
                    class="w-full py-2.5 rounded-full bg-neutral-100 text-neutral-800 text-xs font-bold hover:bg-neutral-200 transition-colors cursor-pointer"
                  >
                    Copiar Lista de Piezas
                  </button>
                </div>
              </div>
            </div>

            <!-- Bottleneck & FPS card -->
            <div class="bg-gradient-to-br from-neutral-900 to-black text-white rounded-3xl p-6 shadow-sm space-y-3">
              <div class="flex items-center justify-between text-xs font-mono">
                <span class="text-emerald-400 font-bold">CUELLO DE BOTELLA: &lt; 2%</span>
                <span class="text-neutral-400">Excelente</span>
              </div>
              <p class="text-xs text-neutral-300 leading-relaxed">
                Esta combinación de CPU y GPU entrega un balance perfecto en resoluciones 1440p y 4K con cero caídas de frames.
              </p>
            </div>

          </div>

        </div>

      </main>
    </div>
  `
})
export class ExplorarPage {
  private toast = inject(ToastService);

  readonly cpuOptions: PartOption[] = [
    { id: 'cpu-7800x3d', name: 'AMD Ryzen 7 7800X3D (8C/16T)', price: 1899, tdp: 120, score: 99 },
    { id: 'cpu-14900k', name: 'Intel Core i9 14900K (24C/32T)', price: 2499, tdp: 253, score: 98 },
    { id: 'cpu-14600kf', name: 'Intel Core i5 14600KF (14C/20T)', price: 1299, tdp: 181, score: 88 },
    { id: 'cpu-7600x', name: 'AMD Ryzen 5 7600X (6C/12T)', price: 1049, tdp: 105, score: 85 }
  ];

  readonly gpuOptions: PartOption[] = [
    { id: 'gpu-4080s', name: 'GeForce RTX 4080 Super OC 16GB', price: 3399, tdp: 320, score: 95 },
    { id: 'gpu-4070tis', name: 'GeForce RTX 4070 Ti Super 16GB', price: 2299, tdp: 285, score: 88 },
    { id: 'gpu-7800xt', name: 'AMD Radeon RX 7800 XT 16GB', price: 1899, tdp: 263, score: 82 },
    { id: 'gpu-4060ti', name: 'GeForce RTX 4060 Ti 8GB', price: 1399, tdp: 160, score: 68 }
  ];

  readonly ramOptions: PartOption[] = [
    { id: 'ram-32', name: 'Corsair Vengeance RGB 32GB (2x16GB) 6000MHz', price: 529, tdp: 15, score: 90 },
    { id: 'ram-64', name: 'Kingston Fury Beast 64GB (2x32GB) 5600MHz', price: 849, tdp: 25, score: 95 }
  ];

  readonly ssdOptions: PartOption[] = [
    { id: 'ssd-2tb-990', name: 'Samsung 990 PRO 2TB NVMe M.2 7450 MB/s', price: 799, tdp: 10, score: 98 },
    { id: 'ssd-1tb-sn850', name: 'WD Black SN850X 1TB NVMe M.2 7300 MB/s', price: 449, tdp: 8, score: 92 }
  ];

  selectedCpu = signal<PartOption>(this.cpuOptions[0]);
  selectedGpu = signal<PartOption>(this.gpuOptions[1]);
  selectedRam = signal<PartOption>(this.ramOptions[0]);
  selectedSsd = signal<PartOption>(this.ssdOptions[0]);

  totalPrice = computed(() => {
    return this.selectedCpu().price + this.selectedGpu().price + this.selectedRam().price + this.selectedSsd().price;
  });

  totalWatts = computed(() => {
    return this.selectedCpu().tdp + this.selectedGpu().tdp + this.selectedRam().tdp + this.selectedSsd().tdp + 50; // 50w for mobo and fans
  });

  recommendedPsu = computed(() => {
    const w = this.totalWatts();
    if (w < 450) return 650;
    if (w < 600) return 750;
    if (w < 750) return 850;
    return 1000;
  });

  estimatedFpsCyberpunk = computed(() => {
    const gpuScore = this.selectedGpu().score;
    const cpuScore = this.selectedCpu().score;
    return Math.round((gpuScore * 0.75 + cpuScore * 0.25) * 1.1);
  });

  estimatedFpsValorant = computed(() => {
    const cpuScore = this.selectedCpu().score;
    return Math.round(cpuScore * 4.2);
  });

  loadRecommendedPreset() {
    this.selectedCpu.set(this.cpuOptions[0]); // 7800X3D
    this.selectedGpu.set(this.gpuOptions[0]); // 4080 Super
    this.selectedRam.set(this.ramOptions[0]); // 32GB
    this.selectedSsd.set(this.ssdOptions[0]); // 2TB Samsung 990
    this.toast.show('¡Preset "Predator 4K" cargado con éxito!');
  }

  resetConfig() {
    this.selectedCpu.set(this.cpuOptions[2]);
    this.selectedGpu.set(this.gpuOptions[3]);
    this.selectedRam.set(this.ramOptions[0]);
    this.selectedSsd.set(this.ssdOptions[1]);
    this.toast.show('Configuración reiniciada');
  }

  checkoutConfig() {
    this.toast.show(`Ensamble personalizado cotizado por S/ ${this.totalPrice()}. Un asesor te contactará.`);
  }

  copyBuildSummary() {
    const text = `Ensamble ENIAC Labs:\n- CPU: ${this.selectedCpu().name}\n- GPU: ${this.selectedGpu().name}\n- RAM: ${this.selectedRam().name}\n- SSD: ${this.selectedSsd().name}\nTotal: S/ ${this.totalPrice()}`;
    this.toast.copyToClipboard(text, '¡Lista de piezas copiada al portapapeles!');
  }
}
