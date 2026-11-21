import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { ToastService } from '../../services/toast.service';
import { CartService } from '../../services/cart.service';

@Component({
  selector: 'app-subscribe',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, ReactiveFormsModule],
  template: `
    <div class="vue-subscribe mt-12 mb-16 max-w-[1400px] mx-auto px-4 sm:px-6" id="sub">
      <div class="relative w-full rounded-[24px] sm:rounded-[30px] overflow-hidden bg-cover bg-center shadow-lg border border-black/5"
           style="background-image: url('https://www-file.honor.com/content/dam/honor/pe/home-page/shop/2026/0827/sub-web.png'); min-height: 480px;">
        
        <!-- Background Overlay / Gradient for better contrast on mobile -->
        <div class="absolute inset-0 bg-white/70 lg:bg-transparent"></div>

        <!-- Form content container positioned at right side like in official store -->
        <div class="relative z-10 w-full lg:w-[48%] lg:ml-auto p-6 sm:p-10 lg:p-12 flex flex-col justify-center min-h-[480px]">
          
          <h2 class="text-2xl sm:text-3xl font-bold text-gray-900 leading-tight">
            ¡Introduce tu correo electrónico para recibir ofertas exclusivas!
          </h2>

          <div class="mt-2 text-xs sm:text-sm text-gray-500 font-medium">
            <span class="font-bold text-black">28,312</span> Usuarios se han inscrito hasta ahora
          </div>

          <p class="mt-2.5 text-xs sm:text-sm text-gray-700">
            Recuerda pegar el código de descuento en el área de “Cupón” al completar tu compra.
          </p>

          <form [formGroup]="subscribeForm" (ngSubmit)="onSubmit()" class="mt-6 space-y-4">
            
            <!-- Terms Checkbox 1 -->
            <label class="flex items-start gap-2.5 cursor-pointer text-xs text-gray-600 select-none">
              <input type="checkbox" formControlName="termsAccepted" class="mt-0.5 w-4 h-4 rounded text-[#256fff] focus:ring-[#256fff] border-gray-300" />
              <span>
                He leído y acepto los <a href="https://www.honor.com/pe/notices/terminos-y-condiciones/" target="_blank" class="text-[#256fff] underline">Términos y condiciones</a>.
              </span>
            </label>

            <!-- Terms Checkbox 2 -->
            <label class="flex items-start gap-2.5 cursor-pointer text-xs text-gray-600 select-none">
              <input type="checkbox" formControlName="privacyAccepted" class="mt-0.5 w-4 h-4 rounded text-[#256fff] focus:ring-[#256fff] border-gray-300" />
              <span>
                Acepto recibir por correo electrónico las últimas ofertas e información de componentes de computadora, hardware y promociones. Puedo cancelar en cualquier momento según la <a href="https://agreement.itsec.honor.com/asm/agrFile/getHtmlFile?agrNo=1101&country=pe&branchId=0&langCode=es-us" target="_blank" class="text-[#256fff] underline">Declaración de Privacidad</a>.
              </span>
            </label>

            <!-- Email Input & Submit Button -->
            <div class="flex flex-col sm:flex-row gap-3 pt-2">
              <div class="flex-1 relative">
                <input 
                  type="email" 
                  formControlName="email"
                  placeholder="Correo electrónico*" 
                  class="w-full px-5 py-3 rounded-full bg-white border border-gray-300 text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-[#256fff] shadow-sm"
                  [class.border-red-500]="isSubmitted() && subscribeForm.get('email')?.invalid"
                />
                @if (isSubmitted() && subscribeForm.get('email')?.invalid) {
                  <span class="text-[11px] text-[#eb1406] mt-1 pl-4 block">
                    Por favor ingrese un correo electrónico válido.
                  </span>
                }
              </div>

              <button 
                type="submit" 
                class="px-8 py-3 bg-black hover:bg-[#256fff] text-white font-semibold text-xs tracking-wider uppercase rounded-full transition-colors shadow-md flex-shrink-0"
              >
                SUSCRIBIRSE
              </button>
            </div>

            @if (isSubmitted() && (!subscribeForm.get('termsAccepted')?.value || !subscribeForm.get('privacyAccepted')?.value)) {
              <div class="text-[11px] text-[#eb1406] pl-2 flex items-center gap-1">
                <span>⚠️ Por favor acepta los términos y la declaración de privacidad para continuar.</span>
              </div>
            }

          </form>

        </div>
      </div>
    </div>

    <!-- Celebration / Coupon Success Modal -->
    @if (showCouponModal()) {
      <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-fadeIn">
        <div class="bg-white rounded-3xl max-w-md w-full p-8 text-center relative shadow-2xl border border-gray-100 animate-scaleUp">
          
          <button (click)="closeModal()" class="absolute top-5 right-5 text-gray-400 hover:text-black p-1 text-xl font-bold" aria-label="Cerrar modal">
            ✕
          </button>

          <div class="w-16 h-16 bg-[#ecf5ff] text-[#256fff] rounded-full flex items-center justify-center mx-auto mb-4">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
          </div>

          <h3 class="text-2xl font-bold text-gray-900">¡Gracias por suscribirte!</h3>
          <p class="text-sm text-gray-600 mt-2">
            Disfruta de un <strong>8% de descuento adicional</strong> en tu compra oficial usando el cupón exclusivo:
          </p>

          <div class="my-6 p-4 rounded-2xl bg-gradient-to-r from-[#fcf7ea] to-[#ffe9c5] border border-[#ffddad] relative">
            <div class="text-xs uppercase tracking-wider font-bold text-gray-600">Cupón de bienvenida</div>
            <div class="text-3xl font-black text-black tracking-widest my-1 font-mono">
              APEALL35
            </div>
            <div class="text-[11px] text-gray-500">Válido en componentes y hardware de computadora seleccionados</div>
          </div>

          <div class="flex gap-3">
            <button 
              (click)="copyCouponCode('APEALL35')"
              class="flex-1 py-3 bg-black hover:bg-[#256fff] text-white font-semibold text-sm rounded-full transition-colors flex items-center justify-center gap-2"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3"/></svg>
              Copiar Código
            </button>
            <button 
              (click)="applyAndShop('APEALL35')"
              class="flex-1 py-3 border border-gray-300 hover:border-black text-gray-900 font-semibold text-sm rounded-full transition-colors"
            >
              Usar en Tienda
            </button>
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
export class SubscribeComponent {
  private fb = inject(FormBuilder);
  private toast = inject(ToastService);
  private cart = inject(CartService);

  isSubmitted = signal<boolean>(false);
  showCouponModal = signal<boolean>(false);

  subscribeForm = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    termsAccepted: [true, [Validators.requiredTrue]],
    privacyAccepted: [true, [Validators.requiredTrue]]
  });

  onSubmit() {
    this.isSubmitted.set(true);
    if (this.subscribeForm.valid) {
      this.cart.applyCoupon('APEALL35');
      this.showCouponModal.set(true);
    }
  }

  copyCouponCode(code: string) {
    this.toast.copyToClipboard(code, '¡Código APEALL35 copiado con éxito!');
  }

  applyAndShop(code: string) {
    this.cart.applyCoupon(code);
    this.showCouponModal.set(false);
    this.toast.show('¡Cupón aplicado al carrito!');
    const el = document.getElementById('category');
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }

  closeModal() {
    this.showCouponModal.set(false);
  }
}
