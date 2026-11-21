import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { CatalogService } from '../../services/catalog.service';
import { ToastService } from '../../services/toast.service';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login-modal',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, ReactiveFormsModule],
  template: `
    @if (catalog.isLoginModalOpen()) {
      <button 
        type="button"
        (click)="catalog.closeLoginModal()" 
        class="fixed inset-0 w-full h-full bg-black/60 backdrop-blur-sm z-50 transition-opacity animate-fadeIn border-none p-0 m-0 cursor-default"
        aria-label="Cerrar ventana de inicio de sesión"
      ></button>

      <div class="fixed inset-0 z-50 flex items-center justify-center p-4 pointer-events-none">
        <div class="bg-white rounded-3xl max-w-md w-full p-6 sm:p-8 pointer-events-auto relative shadow-2xl border border-gray-100 animate-scaleUp">
          
          <button 
            type="button"
            (click)="catalog.closeLoginModal()" 
            class="absolute top-5 right-5 w-8 h-8 rounded-full bg-gray-100 hover:bg-black hover:text-white flex items-center justify-center text-sm font-bold transition-colors"
            aria-label="Cerrar modal"
          >
            ✕
          </button>

          <div class="text-center mb-6">
            <div class="flex items-center justify-center gap-2 mb-3">
              <span class="w-8 h-8 rounded-xl bg-black text-white flex items-center justify-center shadow-xs">
                <svg class="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                  <rect x="4" y="4" width="16" height="16" rx="3"/>
                  <rect x="9" y="9" width="6" height="6" rx="1"/>
                  <path d="M9 1v3M15 1v3M9 20v3M15 20v3M20 9h3M20 15h3M1 9h3M1 15h3"/>
                </svg>
              </span>
              <span class="text-2xl font-black tracking-tight text-black font-sans">
                ENIAC<span class="ml-1 text-[#256fff]">Labs</span>
              </span>
            </div>
            <h3 class="text-xl font-bold text-gray-900">
              {{ isRegister() ? 'Crear cuenta de Usuario' : 'Iniciar sesión en tu Cuenta Gamer' }}
            </h3>
            <p class="text-xs text-gray-500 mt-1">
              Gana Puntos Gamer, cupones en componentes y realiza seguimiento a tus pedidos
            </p>
          </div>

          <form [formGroup]="authForm" (ngSubmit)="onSubmit()" class="space-y-4 text-xs">
            <div>
              <label for="loginIdentifier" class="block font-bold text-gray-700 mb-1">Correo electrónico o Teléfono:</label>
              <input 
                id="loginIdentifier"
                type="text" 
                formControlName="identifier"
                placeholder="ejemplo@correo.com o 987654321" 
                class="w-full px-3.5 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-xs focus:outline-none focus:border-black"
              />
            </div>

            <div>
              <label for="loginPassword" class="block font-bold text-gray-700 mb-1">Contraseña:</label>
              <input 
                id="loginPassword"
                type="password" 
                formControlName="password"
                placeholder="••••••••" 
                class="w-full px-3.5 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-xs focus:outline-none focus:border-black"
              />
            </div>

            <div class="flex items-center justify-between text-[11px] text-gray-500">
              <label class="flex items-center gap-1.5 cursor-pointer">
                <input type="checkbox" checked class="rounded text-[#256fff]" />
                Recordar mi sesión
              </label>
              <a href="#" (click)="$event.preventDefault()" class="text-[#256fff] hover:underline">¿Olvidaste tu contraseña?</a>
            </div>

            <button 
              type="submit" 
              class="w-full py-3 bg-black hover:bg-[#256fff] text-white font-bold rounded-full transition-colors text-xs shadow-md mt-2"
            >
              {{ isRegister() ? 'Crear Cuenta' : 'Iniciar Sesión' }}
            </button>

            <div class="text-center pt-2">
              <button 
                type="button" 
                (click)="isRegister.set(!isRegister())" 
                class="text-[#256fff] hover:underline font-semibold"
              >
                {{ isRegister() ? '¿Ya tienes cuenta? Inicia sesión aquí' : '¿No tienes cuenta? Regístrate gratis' }}
              </button>
            </div>
          </form>

        </div>
      </div>
    }
  `
})
export class LoginModalComponent {
  catalog = inject(CatalogService);
  toast = inject(ToastService);
  auth = inject(AuthService);
  private fb = inject(FormBuilder);
  private router = inject(Router);

  isRegister = signal<boolean>(false);

  authForm = this.fb.group({
    identifier: ['cliente1', [Validators.required]],
    password: ['cliente123', [Validators.required, Validators.minLength(4)]]
  });

  onSubmit() {
    if (this.authForm.valid) {
      const identifier = this.authForm.value.identifier || '';
      const password = this.authForm.value.password || '';

      this.auth.login(identifier, password).subscribe({
        next: () => {
          const role = this.auth.isAdmin() ? 'ADMIN' : 'CLIENTE';
          this.toast.show(`¡Bienvenido ${this.auth.currentUser()}! Sesión autenticada en Keycloak [${role}].`, 4000);
          this.catalog.closeLoginModal();
          if (this.auth.isAdmin()) {
            this.router.navigate(['/admin/productos']);
          }
        },
        error: (err) => {
          console.error('Error de autenticación Keycloak:', err);
          this.toast.show('Error al autenticar con Keycloak. Verifica usuario y contraseña.', 3500);
        }
      });
    }
  }
}
