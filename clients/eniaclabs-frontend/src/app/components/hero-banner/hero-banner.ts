import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-hero-banner',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, RouterLink],
  template: `
    <!-- Top Hero Banner: ENIAC Labs PC Gamer & Hardware Specialist -->
    <section class="relative w-full overflow-hidden bg-gradient-to-r from-[#0d1117] via-[#161b22] to-[#0a0d12] text-white min-h-[500px] lg:min-h-[620px] flex items-center border-b border-white/10">
      
      <!-- Subtle Glowing Cyber Accents -->
      <div class="absolute -top-32 -left-32 w-96 h-96 bg-[#256fff]/20 rounded-full blur-3xl pointer-events-none"></div>
      <div class="absolute -bottom-32 -right-32 w-96 h-96 bg-purple-600/20 rounded-full blur-3xl pointer-events-none"></div>

      <div class="max-w-[1440px] mx-auto px-6 sm:px-10 lg:px-16 w-full py-12 lg:py-16 grid grid-cols-1 lg:grid-cols-12 gap-10 items-center relative z-10">
        
        <!-- Left: Headline & Call to Action -->
        <div class="lg:col-span-6 text-left space-y-5">
          
          <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/10 border border-white/15 text-xs font-semibold backdrop-blur-sm">
            <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
            <span class="text-gray-300">ENIAC Labs</span>
            <span class="opacity-40">|</span>
            <span class="text-[#256fff] font-bold">Hardware Gamer & Workstations de IA</span>
          </div>

          <h1 class="text-4xl sm:text-5xl lg:text-[56px] font-black text-white leading-[1.08] tracking-tight">
            Tu PC Gamer, con<br />
            <span class="bg-gradient-to-r from-[#256fff] via-cyan-400 to-emerald-400 bg-clip-text text-transparent">MÁXIMO PODER</span>
          </h1>

          <p class="text-base sm:text-lg text-gray-300 font-normal leading-relaxed max-w-xl">
            Ensamblaje profesional con gestión de cables, piezas de hardware de última generación 100% originales con garantía oficial y cotizador inteligente con IA.
          </p>

          <div class="flex flex-wrap items-center gap-4 pt-2">
            <a 
              routerLink="/componentes"
              class="inline-flex items-center justify-center px-8 py-3.5 bg-[#256fff] hover:bg-blue-600 text-white font-bold rounded-full text-xs sm:text-sm transition-all shadow-lg shadow-blue-500/20 active:scale-95 cursor-pointer"
            >
              🔥 Comprar Componentes
            </a>

            <a 
              routerLink="/explorar"
              class="inline-flex items-center justify-center px-8 py-3.5 bg-white/10 hover:bg-white/20 text-white font-bold rounded-full text-xs sm:text-sm transition-all border border-white/20 active:scale-95 cursor-pointer backdrop-blur-sm"
            >
              ⚡ Armar mi PC Gamer
            </a>
          </div>

          <!-- Micro specs tag -->
          <div class="flex items-center gap-4 text-xs text-gray-400 pt-3">
            <span class="flex items-center gap-1.5">✓ Stock Real en Lima</span>
            <span>•</span>
            <span class="flex items-center gap-1.5">✓ Hasta 12 cuotas sin interés</span>
            <span>•</span>
            <span class="flex items-center gap-1.5">✓ Garantía 3 Años</span>
          </div>
        </div>

        <!-- Right: Official ENIAC High-End Gaming PC Setup Showcase -->
        <div class="lg:col-span-6 relative flex items-center justify-center">
          
          <div class="relative w-full max-w-[560px] rounded-3xl overflow-hidden border border-white/10 shadow-2xl group">
            <img 
              src="/images/hero-pc-rig.jpg" 
              alt="Custom Gaming PC Build ENIAC Labs" 
              class="w-full h-auto object-cover transform group-hover:scale-105 transition-transform duration-700 drop-shadow-2xl"
            />

            <!-- Floating Hardware Badge 1: GPU -->
            <div class="absolute top-4 left-4 bg-black/80 backdrop-blur-md px-3.5 py-1.5 rounded-2xl border border-white/15 text-xs text-white flex items-center gap-2 shadow-lg">
              <span class="text-base">⚡</span>
              <div>
                <div class="font-bold text-[11px] text-white">GeForce RTX 4080 Super</div>
                <div class="text-[9px] text-emerald-400 font-mono">16GB GDDR6X • DLSS 3.5</div>
              </div>
            </div>

            <!-- Floating Hardware Badge 2: CPU -->
            <div class="absolute bottom-4 right-4 bg-black/80 backdrop-blur-md px-3.5 py-1.5 rounded-2xl border border-white/15 text-xs text-white flex items-center gap-2 shadow-lg">
              <span class="text-base">🏆</span>
              <div>
                <div class="font-bold text-[11px] text-white">AMD Ryzen 7 7800X3D</div>
                <div class="text-[9px] text-amber-400 font-mono">3D V-Cache • 8 Cores 5.0GHz</div>
              </div>
            </div>
          </div>

        </div>

      </div>
    </section>

    <!-- Value Propositions & Benefits Strip (Clean, modern HTML cards with real ENIAC guarantees) -->
    <div id="gwqy-box" class="relative z-10 -mt-6 sm:-mt-8 max-w-[1400px] mx-auto px-4 sm:px-6">
      <section class="w-full rounded-2xl sm:rounded-3xl shadow-xl bg-white border border-gray-200 p-6 sm:p-8">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-6 text-center sm:text-left divide-y sm:divide-y-0 sm:divide-x divide-gray-100">
          
          <!-- Benefit 1 -->
          <div class="flex flex-col sm:flex-row items-center sm:items-start gap-3.5 sm:px-4 pt-4 sm:pt-0">
            <div class="w-12 h-12 rounded-2xl bg-blue-50 text-[#256fff] flex items-center justify-center text-2xl shrink-0">
              🚚
            </div>
            <div>
              <div class="font-black text-xs sm:text-sm text-gray-900 uppercase tracking-tight">ENVÍO A TODO EL PERÚ</div>
              <p class="text-[11px] text-gray-500 mt-1 leading-snug">Gratis en Lima y provincias para pedidos mayores a S/ 50 Soles.</p>
            </div>
          </div>

          <!-- Benefit 2 -->
          <div class="flex flex-col sm:flex-row items-center sm:items-start gap-3.5 sm:px-4 pt-4 sm:pt-0">
            <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-2xl shrink-0">
              💳
            </div>
            <div>
              <div class="font-black text-xs sm:text-sm text-gray-900 uppercase tracking-tight">HASTA 12 CUOTAS SIN INTERÉS</div>
              <p class="text-[11px] text-gray-500 mt-1 leading-snug">Tarjetas BCP, BBVA, Interbank, Diners y transferencias directas.</p>
            </div>
          </div>

          <!-- Benefit 3 -->
          <div class="flex flex-col sm:flex-row items-center sm:items-start gap-3.5 sm:px-4 pt-4 sm:pt-0">
            <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center text-2xl shrink-0">
              🛡️
            </div>
            <div>
              <div class="font-black text-xs sm:text-sm text-gray-900 uppercase tracking-tight">GARANTÍA OFICIAL 3 AÑOS</div>
              <p class="text-[11px] text-gray-500 mt-1 leading-snug">Hardware 100% original con respaldo directo de fábrica y boleta/factura.</p>
            </div>
          </div>

          <!-- Benefit 4 -->
          <div class="flex flex-col sm:flex-row items-center sm:items-start gap-3.5 sm:px-4 pt-4 sm:pt-0">
            <div class="w-12 h-12 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center text-2xl shrink-0">
              🛠️
            </div>
            <div>
              <div class="font-black text-xs sm:text-sm text-gray-900 uppercase tracking-tight">ENSAMBLAJE & TESTEO GRATIS</div>
              <p class="text-[11px] text-gray-500 mt-1 leading-snug">Montaje profesional, gestión de cables y prueba de estrés térmica.</p>
            </div>
          </div>

        </div>
      </section>
    </div>
  `
})
export class HeroBannerComponent {
  scrollToSection(id: string, event: Event) {
    event.preventDefault();
    const el = document.getElementById(id);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }
}
