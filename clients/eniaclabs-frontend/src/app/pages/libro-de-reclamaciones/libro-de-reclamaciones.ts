import { Component, ChangeDetectionStrategy, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-libro-de-reclamaciones',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule, RouterLink],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="min-h-screen bg-gray-50 py-10 px-4 sm:px-6 lg:px-8">
      <div class="max-w-4xl mx-auto space-y-6">

        <!-- Banner Oficial INDECOPI Libro de Reclamaciones -->
        <div class="bg-white rounded-3xl p-6 sm:p-8 border-2 border-gray-900 shadow-sm">
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-gray-200 pb-6">
            <div class="flex items-center gap-4">
              <div class="w-14 h-14 bg-gray-900 text-white rounded-2xl flex items-center justify-center font-bold text-2xl shadow-sm">
                📖
              </div>
              <div>
                <div class="text-[11px] font-black tracking-widest text-[#256fff] uppercase">
                  República del Perú • INDECOPI
                </div>
                <h1 class="text-xl sm:text-2xl font-black text-gray-900">
                  Libro de Reclamaciones Virtual
                </h1>
                <div class="text-xs text-gray-500 font-medium">
                  Conforme a la Ley N° 29571 y D.S. N° 011-2011-PCM
                </div>
              </div>
            </div>

            <div class="text-left sm:text-right bg-gray-50 sm:bg-transparent p-3 sm:p-0 rounded-xl border sm:border-0 border-gray-200 text-xs text-gray-600">
              <div><strong class="text-gray-900">Hoja de Reclamación N°:</strong></div>
              <div class="text-base font-black font-mono text-[#256fff]">{{ claimCode }}</div>
              <div class="text-[11px] text-gray-400">Fecha: {{ currentDate }}</div>
            </div>
          </div>

          <!-- Datos del Proveedor Obligatorios por INDECOPI -->
          <div class="mt-4 pt-2 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 text-xs bg-gray-50/80 p-4 rounded-2xl border border-gray-200/80">
            <div><strong class="text-gray-900 block">Razón Social:</strong> ENIAC LABS E.I.R.L.</div>
            <div><strong class="text-gray-900 block">RUC:</strong> 20608945123</div>
            <div><strong class="text-gray-900 block">Establecimiento:</strong> Av. José Larco 743, Of. 502, Miraflores, Lima</div>
            <div><strong class="text-gray-900 block">Canal Virtual:</strong> Tienda Oficial Online (eniaclabs.pe)</div>
          </div>
        </div>

        @if (!submittedClaim()) {
          <!-- Formulario de Reclamación -->
          <form [formGroup]="claimForm" (ngSubmit)="onSubmitClaim()" class="bg-white rounded-3xl p-6 sm:p-10 border border-gray-200 shadow-xs space-y-8">
            
            <!-- 1. Identificación del Consumidor Reclamante -->
            <section class="space-y-4">
              <div class="flex items-center gap-2 border-b border-gray-100 pb-2">
                <span class="w-6 h-6 rounded-full bg-gray-900 text-white inline-flex items-center justify-center text-xs font-bold">1</span>
                <h2 class="text-base font-black text-gray-900">
                  Identificación del Consumidor Reclamante
                </h2>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs">
                <div>
                  <label class="block font-bold text-gray-700 mb-1">Nombres y Apellidos completos *</label>
                  <input 
                    type="text" 
                    formControlName="nombreCompleto" 
                    placeholder="Ej. Juan Pérez Quispe"
                    class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                  />
                  @if (claimForm.get('nombreCompleto')?.touched && claimForm.get('nombreCompleto')?.invalid) {
                    <span class="text-red-500 text-[10px] mt-0.5 block">Campo obligatorio</span>
                  }
                </div>

                <div class="grid grid-cols-3 gap-2">
                  <div class="col-span-1">
                    <label class="block font-bold text-gray-700 mb-1">Doc. *</label>
                    <select formControlName="tipoDocumento" class="w-full px-2 py-2.5 rounded-xl border border-gray-200 bg-white text-xs">
                      <option value="DNI">DNI</option>
                      <option value="CE">C.E.</option>
                      <option value="RUC">RUC</option>
                      <option value="PASAPORTE">Pasaporte</option>
                    </select>
                  </div>
                  <div class="col-span-2">
                    <label class="block font-bold text-gray-700 mb-1">N° Documento *</label>
                    <input 
                      type="text" 
                      formControlName="numeroDocumento" 
                      placeholder="8 dígitos"
                      class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                    />
                    @if (claimForm.get('numeroDocumento')?.touched && claimForm.get('numeroDocumento')?.invalid) {
                      <span class="text-red-500 text-[10px] mt-0.5 block">Campo obligatorio</span>
                    }
                  </div>
                </div>

                <div>
                  <label class="block font-bold text-gray-700 mb-1">Teléfono o Celular *</label>
                  <input 
                    type="tel" 
                    formControlName="telefono" 
                    placeholder="Ej. 984 512 870"
                    class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                  />
                  @if (claimForm.get('telefono')?.touched && claimForm.get('telefono')?.invalid) {
                    <span class="text-red-500 text-[10px] mt-0.5 block">Campo obligatorio</span>
                  }
                </div>

                <div>
                  <label class="block font-bold text-gray-700 mb-1">Correo Electrónico (para notificación) *</label>
                  <input 
                    type="email" 
                    formControlName="email" 
                    placeholder="tucorreo@ejemplo.com"
                    class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                  />
                  @if (claimForm.get('email')?.touched && claimForm.get('email')?.invalid) {
                    <span class="text-red-500 text-[10px] mt-0.5 block">Correo electrónico válido requerido</span>
                  }
                </div>

                <div class="sm:col-span-2">
                  <label class="block font-bold text-gray-700 mb-1">Domicilio actual (Dirección, Distrito, Provincia, Departamento) *</label>
                  <input 
                    type="text" 
                    formControlName="domicilio" 
                    placeholder="Ej. Av. José Larco 743, Dpto 502, Miraflores, Lima"
                    class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                  />
                  @if (claimForm.get('domicilio')?.touched && claimForm.get('domicilio')?.invalid) {
                    <span class="text-red-500 text-[10px] mt-0.5 block">Campo obligatorio</span>
                  }
                </div>

                <div class="sm:col-span-2">
                  <label class="block font-bold text-gray-500 mb-1">Padre, Madre o Representante (en caso el reclamante sea menor de edad)</label>
                  <input 
                    type="text" 
                    formControlName="apoderado" 
                    placeholder="Nombres completos del apoderado (opcional)"
                    class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                  />
                </div>
              </div>
            </section>

            <!-- 2. Identificación del Bien Contratado -->
            <section class="space-y-4">
              <div class="flex items-center gap-2 border-b border-gray-100 pb-2">
                <span class="w-6 h-6 rounded-full bg-gray-900 text-white inline-flex items-center justify-center text-xs font-bold">2</span>
                <h2 class="text-base font-black text-gray-900">
                  Identificación del Bien Contratado
                </h2>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 text-xs">
                <div>
                  <label class="block font-bold text-gray-700 mb-1">Tipo de Bien *</label>
                  <div class="flex gap-4 pt-1.5">
                    <label class="flex items-center gap-1.5 cursor-pointer">
                      <input type="radio" formControlName="tipoBien" value="PRODUCTO" class="accent-black" />
                      <span>Producto (Hardware/PC)</span>
                    </label>
                    <label class="flex items-center gap-1.5 cursor-pointer">
                      <input type="radio" formControlName="tipoBien" value="SERVICIO" class="accent-black" />
                      <span>Servicio</span>
                    </label>
                  </div>
                </div>

                <div>
                  <label class="block font-bold text-gray-700 mb-1">Monto Reclamado (S/) *</label>
                  <input 
                    type="number" 
                    step="0.01"
                    formControlName="montoReclamado" 
                    placeholder="0.00"
                    class="w-full px-3.5 py-2 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                  />
                </div>

                <div>
                  <label class="block font-bold text-gray-700 mb-1">N° de Pedido o Comprobante</label>
                  <input 
                    type="text" 
                    formControlName="numeroPedido" 
                    placeholder="Ej. ENIAC-2026-6475"
                    class="w-full px-3.5 py-2 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                  />
                </div>

                <div class="sm:col-span-3">
                  <label class="block font-bold text-gray-700 mb-1">Descripción del Producto o Servicio Adquirido *</label>
                  <input 
                    type="text" 
                    formControlName="descripcionBien" 
                    placeholder="Ej. Tarjeta Gráfica GeForce RTX 4080 Super / Ensamble Gamer"
                    class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs"
                  />
                  @if (claimForm.get('descripcionBien')?.touched && claimForm.get('descripcionBien')?.invalid) {
                    <span class="text-red-500 text-[10px] mt-0.5 block">Campo obligatorio</span>
                  }
                </div>
              </div>
            </section>

            <!-- 3. Detalle de la Reclamación -->
            <section class="space-y-4">
              <div class="flex items-center gap-2 border-b border-gray-100 pb-2">
                <span class="w-6 h-6 rounded-full bg-gray-900 text-white inline-flex items-center justify-center text-xs font-bold">3</span>
                <h2 class="text-base font-black text-gray-900">
                  Detalle de la Reclamación
                </h2>
              </div>

              <!-- Tipo: Reclamo o Queja según INDECOPI -->
              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <label 
                  [class.border-black]="claimForm.get('tipoReclamacion')?.value === 'RECLAMO'"
                  [class.bg-blue-50/50]="claimForm.get('tipoReclamacion')?.value === 'RECLAMO'"
                  class="p-4 rounded-2xl border-2 border-gray-200 cursor-pointer transition-all flex items-start gap-3"
                >
                  <input type="radio" formControlName="tipoReclamacion" value="RECLAMO" class="mt-1 accent-black" />
                  <div class="text-xs">
                    <strong class="text-gray-900 text-sm block">RECLAMO</strong>
                    <span class="text-gray-500 leading-tight block mt-0.5">
                      Disconformidad relacionada a los productos o servicios adquiridos.
                    </span>
                  </div>
                </label>

                <label 
                  [class.border-black]="claimForm.get('tipoReclamacion')?.value === 'QUEJA'"
                  [class.bg-amber-50/50]="claimForm.get('tipoReclamacion')?.value === 'QUEJA'"
                  class="p-4 rounded-2xl border-2 border-gray-200 cursor-pointer transition-all flex items-start gap-3"
                >
                  <input type="radio" formControlName="tipoReclamacion" value="QUEJA" class="mt-1 accent-black" />
                  <div class="text-xs">
                    <strong class="text-gray-900 text-sm block">QUEJA</strong>
                    <span class="text-gray-500 leading-tight block mt-0.5">
                      Malestar o descontento respecto a la atención al público o servicio brindado.
                    </span>
                  </div>
                </label>
              </div>

              <div class="space-y-4 text-xs">
                <div>
                  <label class="block font-bold text-gray-700 mb-1">Detalle o Motivo de los Hechos *</label>
                  <textarea 
                    rows="4" 
                    formControlName="detalle" 
                    placeholder="Describe de manera clara y precisa los hechos ocurridos..."
                    class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs resize-y"
                  ></textarea>
                  @if (claimForm.get('detalle')?.touched && claimForm.get('detalle')?.invalid) {
                    <span class="text-red-500 text-[10px] mt-0.5 block">Por favor detalla el motivo de la reclamación</span>
                  }
                </div>

                <div>
                  <label class="block font-bold text-gray-700 mb-1">Pedido Concreto del Consumidor *</label>
                  <textarea 
                    rows="2" 
                    formControlName="pedido" 
                    placeholder="Indica qué solución o acción solicitas por parte del proveedor (cambio de producto, reparación, devolución de dinero, etc.)..."
                    class="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 focus:outline-none focus:border-[#256fff] text-xs resize-y"
                  ></textarea>
                  @if (claimForm.get('pedido')?.touched && claimForm.get('pedido')?.invalid) {
                    <span class="text-red-500 text-[10px] mt-0.5 block">Indica tu pedido concreto</span>
                  }
                </div>
              </div>
            </section>

            <!-- Aceptación y Declaración Jurada -->
            <div class="bg-gray-50 p-4 rounded-2xl border border-gray-200 text-xs text-gray-600 space-y-2">
              <label class="flex items-start gap-2.5 cursor-pointer">
                <input type="checkbox" formControlName="aceptaTerminos" class="mt-1 accent-black rounded" />
                <span>
                  Declaro que la información consignada en esta Hoja de Reclamación es verídica. Conforme al D.S. N° 011-2011-PCM de INDECOPI, el proveedor cuenta con un plazo legal improrrogable de hasta <strong>quince (15) días hábiles</strong> para emitir respuesta a mi correo electrónico.
                </span>
              </label>
              @if (claimForm.get('aceptaTerminos')?.touched && claimForm.get('aceptaTerminos')?.invalid) {
                <span class="text-red-500 text-[10px] block">Debes aceptar la declaración para proceder</span>
              }
            </div>

            <!-- Botón de Envío -->
            <div class="flex flex-col sm:flex-row items-center justify-between gap-4 pt-2">
              <button 
                type="submit" 
                [disabled]="isSubmitting()"
                class="w-full sm:w-auto px-10 py-4 bg-black hover:bg-neutral-800 disabled:bg-gray-400 text-white font-bold text-sm rounded-full transition-all shadow-md cursor-pointer flex items-center justify-center gap-2"
              >
                @if (isSubmitting()) {
                  <div class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                  <span>Registrando Hoja de Reclamación...</span>
                } @else {
                  <span>📖 Enviar Hoja de Reclamación Virtual</span>
                }
              </button>

              <span class="text-[11px] text-gray-400 text-center sm:text-right">
                Se enviará una copia digital automática a tu correo electrónico registrado.
              </span>
            </div>

          </form>
        } @else {
          <!-- Hoja Registrada con Éxito (Constancia de Reclamación) -->
          <div class="bg-white rounded-3xl p-8 sm:p-10 border-2 border-emerald-500 shadow-md space-y-6 text-center animate-fadeIn">
            <div class="w-16 h-16 bg-emerald-100 text-emerald-600 rounded-full flex items-center justify-center text-3xl mx-auto">
              ✓
            </div>

            <div>
              <span class="text-xs font-bold text-emerald-600 uppercase tracking-widest bg-emerald-50 px-3 py-1 rounded-full border border-emerald-200">
                Registro Conforme a Ley
              </span>
              <h2 class="text-2xl font-black text-gray-900 mt-3">
                ¡Hoja de Reclamación Registrada Exitosamente!
              </h2>
              <p class="text-sm text-gray-600 mt-1">
                Tu solicitud ha sido ingresada formalmente en nuestro Libro de Reclamaciones Virtual.
              </p>
            </div>

            <div class="max-w-md mx-auto bg-gray-50 rounded-2xl p-5 border border-gray-200 text-left text-xs space-y-2">
              <div class="flex justify-between border-b border-gray-200 pb-2">
                <span class="text-gray-500">N° de Hoja:</span>
                <strong class="font-mono text-base text-[#256fff]">{{ claimCode }}</strong>
              </div>
              <div class="flex justify-between">
                <span class="text-gray-500">Fecha y Hora:</span>
                <span class="font-bold text-gray-900">{{ currentDate }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-gray-500">Consumidor:</span>
                <span class="font-bold text-gray-900">{{ submittedData?.nombreCompleto }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-gray-500">Documento:</span>
                <span class="font-bold text-gray-900">{{ submittedData?.tipoDocumento }} - {{ submittedData?.numeroDocumento }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-gray-500">Tipo:</span>
                <span class="font-bold uppercase" [class.text-blue-600]="submittedData?.tipoReclamacion === 'RECLAMO'" [class.text-amber-600]="submittedData?.tipoReclamacion === 'QUEJA'">
                  {{ submittedData?.tipoReclamacion }}
                </span>
              </div>
              <div class="flex justify-between border-t border-gray-200 pt-2">
                <span class="text-gray-500">Plazo máximo legal de respuesta:</span>
                <strong class="text-emerald-700">15 días hábiles</strong>
              </div>
            </div>

            <div class="flex flex-wrap items-center justify-center gap-3 pt-2">
              <button 
                type="button" 
                (click)="printClaim()"
                class="px-6 py-3 bg-gray-900 hover:bg-black text-white text-xs font-bold rounded-full transition-colors cursor-pointer flex items-center gap-2"
              >
                <span>🖨️ Imprimir / Guardar Constancia</span>
              </button>

              <button 
                type="button" 
                (click)="resetClaim()"
                class="px-6 py-3 bg-gray-100 hover:bg-gray-200 text-gray-800 text-xs font-bold rounded-full transition-colors cursor-pointer"
              >
                Ingresar otra reclamación
              </button>

              <a routerLink="/" class="px-6 py-3 text-xs font-bold text-[#256fff] hover:underline">
                Volver a la Tienda
              </a>
            </div>
          </div>
        }

      </div>
    </div>
  `
})
export class LibroDeReclamacionesPage {
  private fb = inject(FormBuilder);
  private toast = inject(ToastService);

  claimCode = 'LR-2026-' + Math.floor(100000 + Math.random() * 900000);
  currentDate = new Date().toLocaleDateString('es-PE', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });

  isSubmitting = signal<boolean>(false);
  submittedClaim = signal<boolean>(false);
  submittedData: any = null;

  claimForm = this.fb.group({
    nombreCompleto: ['', [Validators.required, Validators.minLength(3)]],
    tipoDocumento: ['DNI', Validators.required],
    numeroDocumento: ['', [Validators.required, Validators.minLength(8)]],
    telefono: ['', [Validators.required, Validators.minLength(7)]],
    email: ['', [Validators.required, Validators.email]],
    domicilio: ['', Validators.required],
    apoderado: [''],
    tipoBien: ['PRODUCTO', Validators.required],
    montoReclamado: [10.00, [Validators.required, Validators.min(0)]],
    numeroPedido: [''],
    descripcionBien: ['', Validators.required],
    tipoReclamacion: ['RECLAMO', Validators.required],
    detalle: ['', [Validators.required, Validators.minLength(10)]],
    pedido: ['', [Validators.required, Validators.minLength(5)]],
    aceptaTerminos: [false, Validators.requiredTrue]
  });

  onSubmitClaim() {
    if (this.claimForm.invalid) {
      this.claimForm.markAllAsTouched();
      this.toast.show('Por favor completa todos los campos obligatorios del formulario.');
      return;
    }

    this.isSubmitting.set(true);
    setTimeout(() => {
      this.submittedData = this.claimForm.value;
      this.submittedClaim.set(true);
      this.isSubmitting.set(false);
      this.toast.show(`Hoja de Reclamación ${this.claimCode} registrada conforme a INDECOPI.`);
    }, 800);
  }

  printClaim() {
    window.print();
  }

  resetClaim() {
    this.claimCode = 'LR-2026-' + Math.floor(100000 + Math.random() * 900000);
    this.claimForm.reset({
      tipoDocumento: 'DNI',
      tipoBien: 'PRODUCTO',
      tipoReclamacion: 'RECLAMO',
      montoReclamado: 10.00,
      aceptaTerminos: false
    });
    this.submittedClaim.set(false);
    this.submittedData = null;
  }
}
