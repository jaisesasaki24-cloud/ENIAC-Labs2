import { ChangeDetectionStrategy, Component, inject, signal, HostListener } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-floating-actions',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule],
  template: `
    <!-- Floating Support & Scroll-to-Top Widget (Bottom-right) -->
    <div class="fixed bottom-6 right-6 z-40 flex flex-col items-end gap-3">
      
      <!-- Customer Service Popover / Menu -->
      <div class="relative">
        @if (isChatMenuOpen()) {
          <div class="absolute bottom-14 right-0 w-64 bg-white rounded-2xl shadow-2xl border border-gray-200 p-4 text-xs space-y-3 animate-fadeIn">
            <div class="flex items-center justify-between pb-2 border-b border-gray-100">
              <span class="font-bold text-gray-900">Atención al Cliente</span>
              <button type="button" (click)="closeChatMenu()" class="text-gray-400 hover:text-black font-bold p-1">✕</button>
            </div>

            <!-- Email -->
            <a href="mailto:soporte@hardwarepc.pe" class="flex items-center gap-3 p-2 rounded-xl hover:bg-gray-50 transition-colors text-gray-700">
              <div class="w-8 h-8 rounded-full bg-blue-50 text-[#256fff] flex items-center justify-center font-bold">
                ✉️
              </div>
              <div class="min-w-0">
                <div class="font-semibold text-gray-900">Correo de soporte</div>
                <div class="text-[11px] text-gray-400 truncate">soporte&#64;hardwarepc.pe</div>
              </div>
            </a>

            <!-- Hotline -->
            <a href="tel:080077605" class="flex items-center gap-3 p-2 rounded-xl hover:bg-gray-50 transition-colors text-gray-700">
              <div class="w-8 h-8 rounded-full bg-green-50 text-green-600 flex items-center justify-center font-bold">
                📞
              </div>
              <div>
                <div class="font-semibold text-gray-900">Línea Gratuita</div>
                <div class="text-[11px] text-gray-400">080077605</div>
              </div>
            </a>

            <!-- WhatsApp -->
            <a href="https://wa.me/528005229989" target="_blank" rel="noopener noreferrer" class="flex items-center gap-3 p-2 rounded-xl hover:bg-gray-50 transition-colors text-gray-700">
              <div class="w-8 h-8 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold">
                💬
              </div>
              <div>
                <div class="font-semibold text-gray-900">WhatsApp Oficial</div>
                <div class="text-[11px] text-gray-400">Chatea con nosotros</div>
              </div>
            </a>
          </div>
        }

        <!-- Toggle Support Button -->
        <button 
          type="button"
          (click)="toggleChatMenu()"
          class="w-12 h-12 rounded-full bg-black text-white hover:bg-[#256fff] shadow-xl flex items-center justify-center transition-all hover:scale-105 active:scale-95"
          aria-label="Abrir servicio al cliente"
          title="Atención al cliente"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/></svg>
        </button>
      </div>

      <!-- Scroll to Top Button (visible when scrolled) -->
      @if (showScrollTop()) {
        <button 
          type="button"
          (click)="scrollToTop()"
          class="w-10 h-10 rounded-full bg-white text-gray-700 hover:text-black border border-gray-200 shadow-md flex items-center justify-center transition-all hover:scale-105 animate-fadeIn"
          aria-label="Volver arriba"
          title="Subir al inicio"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/></svg>
        </button>
      }

    </div>
  `
})
export class FloatingActionsComponent {
  toast = inject(ToastService);
  isChatMenuOpen = signal<boolean>(false);
  showScrollTop = signal<boolean>(false);

  @HostListener('window:scroll')
  onWindowScroll() {
    this.showScrollTop.set(window.scrollY > 400);
  }

  toggleChatMenu() {
    this.isChatMenuOpen.update(v => !v);
  }

  closeChatMenu() {
    this.isChatMenuOpen.set(false);
  }

  scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
}
