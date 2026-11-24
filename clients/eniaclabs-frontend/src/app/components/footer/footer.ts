import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-footer',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  template: `
    <footer id="footer" class="bg-[#0c0e14] text-white pt-14 pb-8 text-sm border-t border-white/10">
      <div class="max-w-[1400px] mx-auto px-4 sm:px-6">
        
        <!-- Breadcrumb & Back to top strip -->
        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between pb-8 border-b border-white/10 gap-4">
          <nav aria-label="Breadcrumb" class="flex flex-wrap items-center text-xs text-gray-400 gap-2">
            <a href="#" (click)="scrollToTop($event)" class="hover:text-white flex items-center gap-1.5 font-bold text-white tracking-tight">
              <span class="text-sm font-black font-sans">ENIAC <span class="text-[#256fff]">Labs</span></span>
            </a>
            <span>›</span>
            <span class="text-white font-medium">Tienda Oficial de Componentes de PC & Estaciones de Trabajo</span>
            <span>›</span>
            <span class="text-emerald-400 font-semibold flex items-center gap-1">
              <span class="w-2 h-2 rounded-full bg-emerald-400 inline-block animate-ping"></span>
              RUC 20608945123
            </span>
          </nav>

          <button (click)="scrollToTop($event)" class="text-xs text-gray-400 hover:text-white flex items-center gap-1.5 transition-colors cursor-pointer">
            Volver arriba 
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/></svg>
          </button>
        </div>

        <!-- Upper Section: Subscription, Customer Service & Navigation Columns -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 py-12 border-b border-white/10">
          
          <!-- Left Column (4 cols): Business Profile, Newsletter & Direct Contact -->
          <div class="lg:col-span-4 space-y-6">
            <div>
              <div class="flex items-center gap-2 mb-2">
                <span class="text-xl font-black tracking-tight text-white">ENIAC <span class="text-[#256fff]">LABS</span></span>
                <span class="text-[10px] bg-[#256fff]/20 text-[#256fff] border border-[#256fff]/30 font-bold px-2 py-0.5 rounded">E.I.R.L.</span>
              </div>
              <p class="text-xs text-gray-400 leading-relaxed">
                Especialistas en hardware de alto rendimiento, ensamblaje de PC Gamer y Workstations en el Perú. Arquitectura de comercio distribuida segura e integrada.
              </p>
            </div>

            <!-- Mini subscribe input -->
            <div>
              <h4 class="text-xs font-bold text-white uppercase tracking-wider mb-2">Newsletter de Ofertas & Stock</h4>
              <form [formGroup]="newsletterForm" (ngSubmit)="onNewsletterSubmit()" class="flex max-w-sm rounded-full bg-white/5 border border-white/20 p-1 focus-within:border-[#256fff] transition-colors">
                <input 
                  type="email" 
                  formControlName="email"
                  placeholder="tucorreo@ejemplo.com" 
                  class="bg-transparent px-4 py-2 text-xs text-white placeholder-gray-400 focus:outline-none flex-1"
                />
                <button type="submit" class="bg-[#256fff] hover:bg-[#1f5ee0] text-white text-xs font-semibold px-4 py-2 rounded-full transition-colors flex-shrink-0 cursor-pointer">
                  SUSCRIBIRSE
                </button>
              </form>
            </div>

            <!-- Datos de Contacto Directo del Negocio -->
            <div class="pt-4 border-t border-white/10 space-y-3">
              <div class="flex items-start gap-3">
                <svg class="w-4 h-4 text-[#256fff] mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                <div class="text-xs text-gray-300">
                  <div class="font-bold text-white">Sede Central & Showroom:</div>
                  <div>Av. José Larco 743, Of. 502, Miraflores, Lima - Perú</div>
                </div>
              </div>

              <div class="flex items-start gap-3">
                <svg class="w-4 h-4 text-[#256fff] mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/></svg>
                <div class="text-xs text-gray-300">
                  <div class="font-bold text-white">Central Telefónica:</div>
                  <div class="text-sm font-black text-white">(01) 480-9200</div>
                  <div class="text-[11px] text-gray-400">Lun - Sáb: 9:00 AM – 8:00 PM</div>
                </div>
              </div>

              <div class="flex items-start gap-3">
                <svg class="w-4 h-4 text-emerald-400 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 24 24"><path d="M12.031 6.172c-3.181 0-5.767 2.586-5.768 5.766-.001 1.298.38 2.27 1.019 3.287l-.711 2.598 2.664-.698c.97.53 1.838.814 2.795.814 3.182 0 5.768-2.586 5.768-5.766 0-3.18-2.586-5.767-5.768-5.767zm7.424 5.766c0 4.097-3.334 7.429-7.424 7.429-.982 0-1.928-.201-2.799-.58l-3.987 1.045 1.064-3.89c-.482-.937-.738-1.99-.738-3.004 0-4.097 3.334-7.429 7.424-7.429 4.09 0 7.424 3.332 7.424 7.429z"/></svg>
                <div class="text-xs text-gray-300">
                  <div class="font-bold text-emerald-400">WhatsApp Ventas Directas:</div>
                  <a href="https://wa.me/51984512870?text=Hola%20ENIAC%20Labs%2C%20deseo%20cotizar%20componentes%20de%20PC" target="_blank" class="hover:underline font-bold text-white">
                    +51 984 512 870
                  </a>
                </div>
              </div>

              <div class="flex items-start gap-3">
                <svg class="w-4 h-4 text-[#256fff] mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                <div class="text-xs text-gray-300 space-y-0.5">
                  <div><span class="text-gray-400">Ventas:</span> <a href="mailto:ventas@eniaclabs.pe" class="text-white hover:text-[#256fff] underline">ventas&#64;eniaclabs.pe</a></div>
                  <div><span class="text-gray-400">Soporte/RMA:</span> <a href="mailto:soporte@eniaclabs.pe" class="text-white hover:text-[#256fff] underline">soporte&#64;eniaclabs.pe</a></div>
                </div>
              </div>
            </div>

            <!-- Libro de Reclamaciones Compliance Box -->
            <div class="pt-2">
              <a 
                routerLink="/libro-de-reclamaciones" 
                class="bg-white/10 hover:bg-white/20 p-3.5 rounded-xl border border-white/20 hover:border-[#256fff] transition-all flex items-center justify-between gap-3 group cursor-pointer block"
                title="Libro de Reclamaciones Virtual Conforme a Ley N° 29571 INDECOPI"
              >
                <div class="flex items-center gap-3">
                  <div class="w-9 h-9 rounded-lg bg-white flex items-center justify-center font-bold text-black text-sm shadow-xs group-hover:scale-105 transition-transform">
                    📖
                  </div>
                  <div>
                    <span class="text-xs text-white font-bold block group-hover:text-[#256fff] transition-colors">Libro de Reclamaciones</span>
                    <span class="text-[10px] text-gray-300">Conforme a Ley N° 29571 (INDECOPI)</span>
                  </div>
                </div>
                <span class="text-[10px] bg-[#256fff] text-white px-2.5 py-1 rounded-md font-mono font-bold">Virtual ›</span>
              </a>
            </div>

          </div>

          <!-- Right Columns (8 cols): 4 Organized Navigation Sections -->
          <div class="lg:col-span-8 grid grid-cols-2 sm:grid-cols-4 gap-8 text-xs">
            
            <!-- Columna 1: Componentes de PC -->
            <div class="space-y-3">
              <h4 class="font-bold text-white text-sm tracking-wide border-b border-white/10 pb-1 text-[#256fff]">
                Componentes PC
              </h4>
              <ul class="space-y-2 text-gray-300">
                <li><a href="#category" (click)="scrollToSection('category', $event)" class="hover:text-white transition-colors">Tarjetas Gráficas (RTX 40 / RX 7000)</a></li>
                <li><a href="#category" (click)="scrollToSection('category', $event)" class="hover:text-white transition-colors">Procesadores AMD AM5 & Intel Gen 14</a></li>
                <li><a href="#tablets" (click)="scrollToSection('tablets', $event)" class="hover:text-white transition-colors">Placas Madre ASUS ROG / MSI</a></li>
                <li><a href="#tablets" (click)="scrollToSection('tablets', $event)" class="hover:text-white transition-colors">Memorias RAM DDR5 6000MHz</a></li>
                <li><a href="#others" (click)="scrollToSection('others', $event)" class="hover:text-white transition-colors">Almacenamiento NVMe PCIe 4.0/5.0</a></li>
                <li><a href="#HONOR_CHOICE" (click)="scrollToSection('HONOR_CHOICE', $event)" class="hover:text-white transition-colors">Fuentes Modulares 80+ Gold</a></li>
                <li><a href="#HONOR_CHOICE" (click)="scrollToSection('HONOR_CHOICE', $event)" class="hover:text-white transition-colors">Gabinetes Lian Li & NZXT</a></li>
              </ul>
            </div>

            <!-- Columna 2: Servicios & Ensamblaje -->
            <div class="space-y-3">
              <h4 class="font-bold text-white text-sm tracking-wide border-b border-white/10 pb-1 text-[#256fff]">
                Servicios Gamer
              </h4>
              <ul class="space-y-2 text-gray-300">
                <li><a routerLink="/explorar" class="hover:text-white transition-colors">PC Builder Inteligente 3D</a></li>
                <li><a href="#peshop1" (click)="scrollToSection('peshop1', $event)" class="hover:text-white transition-colors">Ensamblaje & Cable Management</a></li>
                <li><a href="#peshop1" (click)="scrollToSection('peshop1', $event)" class="hover:text-white transition-colors">Pruebas de Estrés y Benchmarking</a></li>
                <li><a href="#peshop1" (click)="scrollToSection('peshop1', $event)" class="hover:text-white transition-colors">Actualización de BIOS & Firmware</a></li>
                <li><a href="#peshop1" (click)="scrollToSection('peshop1', $event)" class="hover:text-white transition-colors">Overclocking y Undervolting Seguro</a></li>
                <li><a routerLink="/pagar" class="hover:text-white transition-colors">Cotización Rápida en Línea</a></li>
              </ul>
            </div>

            <!-- Columna 3: Información Legal & Garantías -->
            <div class="space-y-3">
              <h4 class="font-bold text-white text-sm tracking-wide border-b border-white/10 pb-1 text-[#256fff]">
                Políticas & Legal
              </h4>
              <ul class="space-y-2 text-gray-300">
                <li><span class="text-white font-medium">ENIAC LABS E.I.R.L.</span></li>
                <li><span class="text-gray-400">RUC: 20608945123</span></li>
                <li><a routerLink="/terminos" class="hover:text-white transition-colors text-white font-semibold">Términos y Condiciones de Compra</a></li>
                <li><a routerLink="/devoluciones" class="hover:text-white transition-colors text-white font-semibold">Políticas de Cambio y Devoluciones</a></li>
                <li><a routerLink="/libro-de-reclamaciones" class="hover:text-white transition-colors text-white font-semibold flex items-center gap-1.5">
                  <span>📖 Libro de Reclamaciones</span>
                  <span class="text-[9px] bg-white/20 px-1.5 py-0.5 rounded text-emerald-300 font-bold">INDECOPI</span>
                </a></li>
                <li><a routerLink="/devoluciones" class="hover:text-white transition-colors">Póliza de Garantía Oficial (1 a 3 Años)</a></li>
                <li><a routerLink="/terminos" class="hover:text-white transition-colors">Envíos a Nivel Nacional con Seguro</a></li>
                <li><a routerLink="/terminos" class="hover:text-white transition-colors">Protección de Datos Personales (Ley 29733)</a></li>
                <li><span class="text-gray-400">Facturación Electrónica SUNAT</span></li>
              </ul>
            </div>

            <!-- Columna 4: Arquitectura del Sistema Distribuido -->
            <div class="space-y-3">
              <h4 class="font-bold text-white text-sm tracking-wide border-b border-white/10 pb-1 text-emerald-400">
                Arquitectura Cloud
              </h4>
              <ul class="space-y-2 text-gray-300 text-[11px]">
                <li class="flex items-center gap-1.5">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  <span>Spring Cloud Gateway (:18080)</span>
                </li>
                <li class="flex items-center gap-1.5">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  <span>Keycloak OIDC Auth (:18180)</span>
                </li>
                <li class="flex items-center gap-1.5">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  <span>Eureka Service Discovery (:18761)</span>
                </li>
                <li class="flex items-center gap-1.5">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                  <span>Apache Kafka & PostgreSQL</span>
                </li>
                <li class="pt-2 border-t border-white/10 text-gray-400">
                  Arquitectos del Sistema:
                  <div class="text-white font-semibold">Eliceo Parillo Mostajo</div>
                  <div class="text-white font-semibold">Laura Vargas Cristhian Paul</div>
                </li>
                <li class="pt-1">
                  <a routerLink="/admin/login" class="text-[#256fff] hover:underline font-bold flex items-center gap-1">
                    Acceso Portal Admin →
                  </a>
                </li>
              </ul>
            </div>

          </div>

        </div>

        <!-- Social Media, Pay Methods & Country Selector Strip -->
        <div class="flex flex-col sm:flex-row items-center justify-between py-6 border-b border-white/10 gap-4">
          <div class="flex items-center gap-4 text-gray-400">
            <span class="text-xs text-gray-400 font-medium">Canales Oficiales:</span>
            <a href="https://wa.me/51984512870?text=Hola%20ENIAC%20Labs%2C%20deseo%20atencion%20al%20cliente" target="_blank" class="hover:text-emerald-400 p-1.5 rounded-full hover:bg-white/10 transition-colors flex items-center gap-1.5 text-xs text-gray-300" aria-label="WhatsApp Oficial">
              <svg class="w-5 h-5 text-emerald-400" fill="currentColor" viewBox="0 0 24 24"><path d="M12.031 6.172c-3.181 0-5.767 2.586-5.768 5.766-.001 1.298.38 2.27 1.019 3.287l-.711 2.598 2.664-.698c.97.53 1.838.814 2.795.814 3.182 0 5.768-2.586 5.768-5.766 0-3.18-2.586-5.767-5.768-5.767zm7.424 5.766c0 4.097-3.334 7.429-7.424 7.429-.982 0-1.928-.201-2.799-.58l-3.987 1.045 1.064-3.89c-.482-.937-.738-1.99-.738-3.004 0-4.097 3.334-7.429 7.424-7.429 4.09 0 7.424 3.332 7.424 7.429z"/></svg>
              <span>WhatsApp</span>
            </a>
            <a href="https://github.com/jaisesasaki24-cloud/ENIAC-Labs2" target="_blank" class="hover:text-white p-1.5 rounded-full hover:bg-white/10 transition-colors flex items-center gap-1.5 text-xs text-gray-300" aria-label="GitHub Repository">
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path fill-rule="evenodd" clip-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.53 1.032 1.53 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"/></svg>
              <span>GitHub</span>
            </a>
            <a href="mailto:soporte@eniaclabs.pe" class="hover:text-[#256fff] p-1.5 rounded-full hover:bg-white/10 transition-colors flex items-center gap-1.5 text-xs text-gray-300" aria-label="Correo Soporte">
              <svg class="w-5 h-5 text-[#256fff]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
              <span>Soporte</span>
            </a>
          </div>

          <!-- Métodos de Pago Aceptados -->
          <div class="flex items-center gap-2 text-xs text-gray-400">
            <span class="text-[11px] text-gray-400">Pasarelas:</span>
            <span class="bg-orange-500/20 text-orange-400 border border-orange-500/30 font-bold px-2 py-0.5 rounded text-[10px]">Culqi Checkout</span>
            <span class="bg-blue-500/20 text-blue-400 border border-blue-500/30 font-bold px-2 py-0.5 rounded text-[10px]">Mercado Pago</span>
            <span class="bg-purple-500/20 text-purple-400 border border-purple-500/30 font-bold px-2 py-0.5 rounded text-[10px]">Yape</span>
            <span class="bg-white/10 text-white font-bold px-2 py-0.5 rounded text-[10px]">VISA</span>
            <span class="bg-white/10 text-white font-bold px-2 py-0.5 rounded text-[10px]">Mastercard</span>
          </div>

          <div class="flex items-center gap-2 text-xs text-gray-300 font-medium">
            <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            <span>Perú</span>
            <span class="text-gray-500">(Lima Metropolitana & Provincias)</span>
          </div>
        </div>

        <!-- Bottom Copyright & Legal Links -->
        <div class="flex flex-col sm:flex-row items-center justify-between pt-6 text-[11px] text-gray-500 gap-4">
          <div class="flex flex-wrap items-center gap-4">
            <a routerLink="/" class="hover:text-white">Inicio</a>
            <span>•</span>
            <a routerLink="/terminos" class="hover:text-white text-gray-300 font-medium">Términos y Condiciones</a>
            <span>•</span>
            <a routerLink="/devoluciones" class="hover:text-white text-gray-300 font-medium">Políticas de Devolución</a>
            <span>•</span>
            <a routerLink="/libro-de-reclamaciones" class="hover:text-white text-gray-300 font-medium flex items-center gap-1">
              <span>📖 Libro de Reclamaciones</span>
            </a>
            <span>•</span>
            <span class="text-gray-400">Protección al Consumidor INDECOPI</span>
          </div>

          <div class="text-center sm:text-right">
            Copyright © 2026 <strong class="text-gray-300">ENIAC LABS E.I.R.L.</strong> RUC: 20608945123. Todos los derechos reservados.
          </div>
        </div>

      </div>
    </footer>
  `
})
export class FooterComponent {
  private fb = inject(FormBuilder);
  private toast = inject(ToastService);

  newsletterForm = this.fb.group({
    email: ['', [Validators.required, Validators.email]]
  });

  onNewsletterSubmit() {
    if (this.newsletterForm.valid) {
      this.toast.show('¡Gracias por suscribirte al boletín de hardware de ENIAC Labs!');
      this.newsletterForm.reset();
    } else {
      this.toast.show('Por favor ingresa un correo electrónico válido');
    }
  }

  scrollToTop(event: Event) {
    event.preventDefault();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  scrollToSection(id: string, event: Event) {
    event.preventDefault();
    const el = document.getElementById(id);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }
}
