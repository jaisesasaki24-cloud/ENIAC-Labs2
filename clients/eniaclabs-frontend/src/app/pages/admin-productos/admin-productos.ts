import { Component, OnInit, inject, signal, computed, PLATFORM_ID } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { ProductAdminService, ProductoItem, CategoriaItem } from '../../services/product-admin.service';
import { AuthService } from '../../services/auth.service';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-admin-productos',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <div class="min-h-screen bg-[#f8fafc] py-8 px-4 sm:px-6 lg:px-10">
      <div class="max-w-7xl mx-auto space-y-6">

        <!-- Top Navigation / Breadcrumb -->
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-2 text-xs text-gray-500">
            <a routerLink="/" class="hover:text-black font-medium">Inicio</a>
            <span>/</span>
            <span class="text-black font-bold">Panel Administrador</span>
            @if (auth.isAdmin()) {
              <span>/</span>
              <span class="text-[#256fff] font-bold">Catálogo de Productos</span>
            }
          </div>

          <div class="flex items-center gap-3">
            @if (auth.isAdmin()) {
              <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-green-50 text-green-700 text-xs font-semibold rounded-full border border-green-200">
                <span class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></span>
                Admin: {{ auth.currentUser() }}
              </span>
              <button 
                type="button" 
                (click)="cerrarSesionAdmin()"
                class="px-3 py-1 bg-gray-100 hover:bg-black hover:text-white text-gray-700 text-xs font-semibold rounded-full transition-colors cursor-pointer"
              >
                Cerrar sesión
              </button>
            }
            <a routerLink="/componentes" class="text-xs text-gray-600 hover:text-black font-semibold underline">
              Ver Tienda Pública &rarr;
            </a>
          </div>
        </div>

        @if (!auth.isAdmin()) {
          <!-- PANTALLA DE ACCESO POR USUARIO Y CONTRASEÑA -->
          <div class="max-w-md mx-auto my-12 bg-white rounded-3xl p-8 sm:p-10 shadow-xl border border-gray-100 text-center space-y-6 animate-scaleUp">
            <div class="w-16 h-16 rounded-2xl bg-black text-white flex items-center justify-center mx-auto shadow-md">
              <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
            </div>
            
            <div class="space-y-1">
              <div class="inline-flex items-center gap-1.5 px-3 py-1 bg-blue-50 text-[#256fff] text-[11px] font-bold rounded-full border border-blue-100">
                🔒 Área Restringida
              </div>
              <h2 class="text-2xl font-black text-gray-900">Acceso al Panel Admin</h2>
              <p class="text-xs text-gray-500">
                Ingresa con tu usuario y contraseña de Administrador para gestionar el catálogo de productos (CRUD).
              </p>
            </div>

            <form (ngSubmit)="iniciarSesionAdmin()" class="space-y-4 text-left text-xs">
              <div>
                <label class="block font-bold text-gray-700 mb-1">Usuario Administrador:</label>
                <input 
                  type="text" 
                  [(ngModel)]="loginUser" 
                  name="adminUser"
                  required
                  placeholder="admin" 
                  class="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:outline-none focus:border-black font-medium"
                />
              </div>

              <div>
                <label class="block font-bold text-gray-700 mb-1">Contraseña:</label>
                <input 
                  type="password" 
                  [(ngModel)]="loginPass" 
                  name="adminPass"
                  required
                  placeholder="••••••••" 
                  class="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl focus:bg-white focus:outline-none focus:border-black font-medium"
                />
              </div>

              <button 
                type="submit" 
                [disabled]="iniciandoSesion()"
                class="w-full py-3.5 bg-black hover:bg-[#256fff] text-white font-bold text-xs rounded-full transition-colors shadow-md flex items-center justify-center gap-2 disabled:opacity-50 mt-2 cursor-pointer"
              >
                @if (iniciandoSesion()) {
                  <span class="animate-spin w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full"></span>
                }
                <span>Iniciar Sesión como Administrador</span>
              </button>
            </form>

            <div class="pt-4 border-t border-gray-100 text-[11px] text-gray-400">
              Autenticación centralizada Keycloak OIDC (Realm: <code>eniaclabs</code>)
            </div>
          </div>
        } @else {
          <!-- PANTALLA PRINCIPAL DEL CRUD (Solo visible tras iniciar sesión como ADMIN) -->

          <!-- Header Hero Card -->
          <div class="bg-white rounded-3xl p-6 sm:p-8 shadow-xs border border-gray-100 flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
            <div class="space-y-2">
              <div class="inline-flex items-center gap-2 px-3 py-1 bg-black text-white rounded-full text-xs font-bold uppercase tracking-wider">
                <span>🛠️ Microservicio No Transaccional</span>
                <span class="opacity-40">|</span>
                <span>pc-catalogo-ms (:8081)</span>
              </div>
              <h1 class="text-2xl sm:text-3xl font-black text-black">
                Gestión de Catálogo Gamer <span class="text-[#256fff]">(CRUD Completo)</span>
              </h1>
              <p class="text-xs sm:text-sm text-gray-500 max-w-2xl">
                Crea, edita, actualiza stock y desactiva componentes de hardware en tiempo real. 
                Operaciones aseguradas con roles RBAC de Keycloak IAM (<code>ROLE_ADMIN</code>) mediante Spring Cloud Gateway.
              </p>
            </div>

            <div class="flex flex-wrap items-center gap-3 w-full md:w-auto">
              <button 
                type="button"
                (click)="abrirModalCrear()"
                class="flex-1 md:flex-initial px-5 py-3 bg-[#256fff] hover:bg-blue-700 text-white font-bold text-xs rounded-2xl transition-all shadow-md flex items-center justify-center gap-2 cursor-pointer"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                <span>Añadir Producto</span>
              </button>

              <button 
                type="button"
                (click)="cargarDatos()"
                class="px-4 py-3 bg-gray-100 hover:bg-gray-200 text-gray-800 font-semibold text-xs rounded-2xl transition-colors flex items-center justify-center gap-1.5 cursor-pointer"
                title="Recargar datos"
              >
                <svg class="w-4 h-4" [class.animate-spin]="cargando()" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
                <span>Refrescar</span>
              </button>
            </div>
          </div>

          <!-- Metric Counter Badges -->
          <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs">
              <div class="text-[11px] font-bold text-gray-400 uppercase tracking-wider">Total Productos</div>
              <div class="text-2xl font-black text-black mt-1">{{ productos().length }}</div>
              <div class="text-[11px] text-gray-500 mt-0.5">En catálogo activo/inactivo</div>
            </div>
            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs">
              <div class="text-[11px] font-bold text-gray-400 uppercase tracking-wider">Categorías</div>
              <div class="text-2xl font-black text-[#256fff] mt-1">{{ categorias().length }}</div>
              <div class="text-[11px] text-gray-500 mt-0.5">Procesadores, GPUs, RAMs...</div>
            </div>
            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs">
              <div class="text-[11px] font-bold text-gray-400 uppercase tracking-wider">Stock Total Unidades</div>
              <div class="text-2xl font-black text-green-600 mt-1">{{ stockTotal() }}</div>
              <div class="text-[11px] text-gray-500 mt-0.5">Inventario en tiempo real</div>
            </div>
            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs">
              <div class="text-[11px] font-bold text-gray-400 uppercase tracking-wider">Sesión IAM</div>
              <div class="text-xs font-black mt-2 inline-flex items-center gap-1.5 px-2 py-0.5 rounded-lg bg-green-50 text-green-700">
                <span class="w-2 h-2 rounded-full bg-green-500"></span>
                ROLE_ADMIN
              </div>
              <div class="text-[11px] text-gray-500 mt-1">Usuario: {{ auth.currentUser() }}</div>
            </div>
          </div>

          <!-- Filters & Search Toolbar -->
          <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-xs flex flex-col md:flex-row gap-3 items-center justify-between">
            <div class="relative w-full md:w-96">
              <svg class="w-4 h-4 absolute left-3.5 top-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
              <input 
                type="text" 
                [(ngModel)]="busqueda"
                placeholder="Buscar por SKU, nombre, marca o modelo..."
                class="w-full pl-10 pr-4 py-2 text-xs bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:border-black transition-colors"
              />
            </div>

            <div class="flex items-center gap-3 w-full md:w-auto">
              <select 
                [(ngModel)]="categoriaFiltro" 
                class="px-3 py-2 text-xs bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:border-black font-medium text-gray-700"
              >
                <option [value]="0">Todas las categorías</option>
                @for (cat of categorias(); track cat.id) {
                  <option [value]="cat.id">{{ cat.nombre }}</option>
                }
              </select>

              <select 
                [(ngModel)]="estadoFiltro" 
                class="px-3 py-2 text-xs bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:border-black font-medium text-gray-700"
              >
                <option value="todos">Todos los estados</option>
                <option value="activos">Solo activos</option>
                <option value="inactivos">Solo inactivos</option>
              </select>
            </div>
          </div>

          <!-- Main Product Table -->
          <div class="bg-white rounded-3xl border border-gray-100 shadow-xs overflow-hidden">
            @if (cargando()) {
              <div class="p-16 text-center space-y-3">
                <div class="animate-spin w-8 h-8 border-4 border-black border-t-transparent rounded-full mx-auto"></div>
                <p class="text-xs text-gray-500 font-medium">Cargando inventario desde pc-catalogo-ms...</p>
              </div>
            } @else if (productosFiltrados().length === 0) {
              <div class="p-16 text-center space-y-3">
                <div class="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center mx-auto text-xl">🔍</div>
                <h3 class="font-bold text-gray-800 text-sm">No se encontraron productos</h3>
                <p class="text-xs text-gray-400">Intenta cambiar los términos de búsqueda o filtros.</p>
                <button 
                  type="button" 
                  (click)="limpiarFiltros()"
                  class="px-4 py-1.5 bg-black text-white text-xs font-semibold rounded-full hover:bg-[#256fff] transition-colors cursor-pointer"
                >
                  Limpiar filtros
                </button>
              </div>
            } @else {
              <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse text-xs">
                  <thead>
                    <tr class="bg-gray-50/80 border-b border-gray-100 text-gray-500 font-semibold uppercase tracking-wider text-[11px]">
                      <th class="py-3.5 px-4">ID</th>
                      <th class="py-3.5 px-4">SKU</th>
                      <th class="py-3.5 px-4">Nombre / Modelo</th>
                      <th class="py-3.5 px-4">Categoría</th>
                      <th class="py-3.5 px-4 text-right">Precio (S/)</th>
                      <th class="py-3.5 px-4 text-center">Stock</th>
                      <th class="py-3.5 px-4 text-center">Garantía</th>
                      <th class="py-3.5 px-4 text-center">Estado</th>
                      <th class="py-3.5 px-4 text-right">Acciones</th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-100 text-gray-800">
                    @for (prod of productosFiltrados(); track prod.id) {
                      <tr class="hover:bg-gray-50/60 transition-colors group">
                        <td class="py-3 px-4 font-mono text-gray-400 text-[11px]">
                          #{{ prod.id }}
                        </td>
                        <td class="py-3 px-4 font-mono font-bold text-gray-900">
                          <span class="px-2 py-0.5 bg-gray-100 text-gray-800 rounded-md text-[11px]">
                            {{ prod.sku }}
                          </span>
                        </td>
                        <td class="py-3 px-4 max-w-xs">
                          <div class="font-bold text-gray-900 truncate">{{ prod.nombre }}</div>
                          <div class="text-[11px] text-gray-500">{{ prod.marca }} • {{ prod.modelo }}</div>
                        </td>
                        <td class="py-3 px-4">
                          <span class="inline-flex px-2 py-0.5 rounded-full text-[10px] font-bold bg-blue-50 text-[#256fff]">
                            {{ prod.categoriaNombre || obtenerNombreCategoria(prod.categoriaId) }}
                          </span>
                        </td>
                        <td class="py-3 px-4 text-right font-bold text-black text-sm">
                          S/ {{ prod.precio | number:'1.2-2' }}
                        </td>
                        <td class="py-3 px-4 text-center">
                          <span 
                            class="inline-block px-2 py-0.5 rounded-full text-[11px] font-bold"
                            [class.bg-green-100]="prod.stockActual > (prod.stockMinimo || 3)"
                            [class.text-green-800]="prod.stockActual > (prod.stockMinimo || 3)"
                            [class.bg-amber-100]="prod.stockActual <= (prod.stockMinimo || 3) && prod.stockActual > 0"
                            [class.text-amber-800]="prod.stockActual <= (prod.stockMinimo || 3) && prod.stockActual > 0"
                            [class.bg-red-100]="prod.stockActual === 0"
                            [class.text-red-800]="prod.stockActual === 0"
                          >
                            {{ prod.stockActual }} un.
                          </span>
                        </td>
                        <td class="py-3 px-4 text-center text-gray-500 text-[11px]">
                          {{ prod.garantiaMeses || 24 }} meses
                        </td>
                        <td class="py-3 px-4 text-center">
                          @if (prod.activo) {
                            <span class="inline-flex items-center gap-1 text-[11px] font-semibold text-green-700">
                              <span class="w-1.5 h-1.5 rounded-full bg-green-500"></span> Activo
                            </span>
                          } @else {
                            <span class="inline-flex items-center gap-1 text-[11px] font-semibold text-gray-400">
                              <span class="w-1.5 h-1.5 rounded-full bg-gray-400"></span> Inactivo
                            </span>
                          }
                        </td>
                        <td class="py-3 px-4 text-right space-x-1.5">
                          <button 
                            type="button" 
                            (click)="abrirModalEditar(prod)"
                            class="px-2.5 py-1 bg-gray-100 hover:bg-black hover:text-white rounded-lg text-xs font-semibold transition-colors cursor-pointer"
                            title="Editar producto"
                          >
                            Editar
                          </button>
                          <button 
                            type="button" 
                            (click)="confirmarEliminar(prod)"
                            class="px-2.5 py-1 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-lg text-xs font-semibold transition-colors cursor-pointer"
                            title="Eliminar producto"
                          >
                            Eliminar
                          </button>
                        </td>
                      </tr>
                    }
                  </tbody>
                </table>
              </div>
            }
          </div>

        }

      </div>
    </div>

    <!-- MODAL: Crear / Editar Producto -->
    @if (modalAbierto()) {
      <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-fadeIn">
        <div class="bg-white rounded-3xl max-w-2xl w-full p-6 sm:p-8 relative shadow-2xl border border-gray-100 max-h-[90vh] overflow-y-auto">
          
          <button 
            type="button" 
            (click)="cerrarModal()" 
            class="absolute top-5 right-5 text-gray-400 hover:text-black text-xl font-bold p-1 cursor-pointer"
          >
            ✕
          </button>

          <div class="flex items-center gap-3 mb-6">
            <div class="w-10 h-10 rounded-2xl bg-black text-white flex items-center justify-center font-bold">
              {{ modoEdicion() ? '✏️' : '✨' }}
            </div>
            <div>
              <h2 class="text-xl font-bold text-gray-900">
                {{ modoEdicion() ? 'Editar Componente Gamer' : 'Registrar Nuevo Componente' }}
              </h2>
              <p class="text-xs text-gray-500">
                Microservicio No Transaccional: <code>pc-catalogo-ms</code> (:8081)
              </p>
            </div>
          </div>

          <form (ngSubmit)="guardarProducto()" class="space-y-4 text-xs">
            
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label class="block font-bold text-gray-700 mb-1">Código SKU *</label>
                <input 
                  type="text" 
                  [(ngModel)]="productoForm.sku" 
                  name="sku" 
                  required
                  placeholder="Ej: NV-RTX5090"
                  class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black font-mono font-bold"
                />
              </div>

              <div>
                <label class="block font-bold text-gray-700 mb-1">Categoría de Hardware *</label>
                <select 
                  [(ngModel)]="productoForm.categoriaId" 
                  name="categoriaId" 
                  required
                  class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black"
                >
                  @for (cat of categorias(); track cat.id) {
                    <option [value]="cat.id">{{ cat.nombre }}</option>
                  }
                </select>
              </div>
            </div>

            <div>
              <label class="block font-bold text-gray-700 mb-1">Nombre Comercial del Producto *</label>
              <input 
                type="text" 
                [(ngModel)]="productoForm.nombre" 
                name="nombre" 
                required
                placeholder="Ej: ASUS ROG Strix GeForce RTX 5090 32GB OC"
                class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black"
              />
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label class="block font-bold text-gray-700 mb-1">Marca *</label>
                <input 
                  type="text" 
                  [(ngModel)]="productoForm.marca" 
                  name="marca" 
                  required
                  placeholder="Ej: ASUS ROG, AMD, Intel, Corsair"
                  class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black"
                />
              </div>

              <div>
                <label class="block font-bold text-gray-700 mb-1">Modelo *</label>
                <input 
                  type="text" 
                  [(ngModel)]="productoForm.modelo" 
                  name="modelo" 
                  required
                  placeholder="Ej: ROG-STRIX-RTX5090-O32G"
                  class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black"
                />
              </div>
            </div>

            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
              <div>
                <label class="block font-bold text-gray-700 mb-1">Precio (S/) *</label>
                <input 
                  type="number" 
                  step="0.01" 
                  [(ngModel)]="productoForm.precio" 
                  name="precio" 
                  required
                  placeholder="3499.00"
                  class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black font-bold"
                />
              </div>

              <div>
                <label class="block font-bold text-gray-700 mb-1">Stock Actual *</label>
                <input 
                  type="number" 
                  [(ngModel)]="productoForm.stockActual" 
                  name="stockActual" 
                  required
                  placeholder="10"
                  class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black"
                />
              </div>

              <div>
                <label class="block font-bold text-gray-700 mb-1">Stock Mínimo</label>
                <input 
                  type="number" 
                  [(ngModel)]="productoForm.stockMinimo" 
                  name="stockMinimo" 
                  placeholder="3"
                  class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black"
                />
              </div>

              <div>
                <label class="block font-bold text-gray-700 mb-1">Garantía (Meses)</label>
                <input 
                  type="number" 
                  [(ngModel)]="productoForm.garantiaMeses" 
                  name="garantiaMeses" 
                  placeholder="24"
                  class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black"
                />
              </div>
            </div>

            <div>
              <label class="block font-bold text-gray-700 mb-1">Especificaciones Técnicas (JSON o Resumen)</label>
              <textarea 
                [(ngModel)]="productoForm.especificaciones" 
                name="especificaciones" 
                rows="2"
                placeholder='Ej: {"vram": "32GB GDDR7", "dlss": "4.0", "boost": "2.8GHz"}'
                class="w-full px-3 py-2 border rounded-xl text-xs bg-gray-50 focus:bg-white focus:outline-none focus:border-black font-mono"
              ></textarea>
            </div>

            <div class="flex items-center gap-2 pt-1">
              <input 
                type="checkbox" 
                id="activoCheck"
                [(ngModel)]="productoForm.activo" 
                name="activo" 
                class="w-4 h-4 rounded text-black focus:ring-black border-gray-300"
              />
              <label for="activoCheck" class="text-xs font-semibold text-gray-700 select-none">
                Componente activo y visible en el catálogo de ventas
              </label>
            </div>

            <div class="pt-4 border-t border-gray-100 flex items-center justify-end gap-3">
              <button 
                type="button" 
                (click)="cerrarModal()" 
                class="px-5 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-bold rounded-full transition-colors cursor-pointer"
              >
                Cancelar
              </button>
              <button 
                type="submit" 
                [disabled]="guardando()"
                class="px-6 py-2.5 bg-black hover:bg-[#256fff] text-white text-xs font-bold rounded-full transition-colors flex items-center gap-2 shadow-md disabled:opacity-50 cursor-pointer"
              >
                @if (guardando()) {
                  <span class="animate-spin w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full"></span>
                }
                <span>{{ modoEdicion() ? 'Actualizar Producto' : 'Crear Producto' }}</span>
              </button>
            </div>

          </form>

        </div>
      </div>
    }

    <!-- MODAL: Confirmar Eliminación -->
    @if (productoAEliminar()) {
      <div class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-fadeIn">
        <div class="bg-white rounded-3xl max-w-md w-full p-6 text-center space-y-4 shadow-2xl border border-gray-100">
          <div class="w-12 h-12 rounded-full bg-red-100 text-red-600 flex items-center justify-center mx-auto text-xl font-bold">
            ⚠️
          </div>
          <h3 class="text-lg font-bold text-gray-900">¿Desactivar Componente?</h3>
          <p class="text-xs text-gray-500">
            Estás a punto de desactivar del catálogo: 
            <strong class="text-black block mt-1">{{ productoAEliminar()?.nombre }} (SKU: {{ productoAEliminar()?.sku }})</strong>
          </p>
          <div class="flex items-center justify-center gap-3 pt-2">
            <button 
              type="button" 
              (click)="productoAEliminar.set(null)"
              class="px-5 py-2.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-bold rounded-full transition-colors cursor-pointer"
            >
              Cancelar
            </button>
            <button 
              type="button" 
              (click)="ejecutarEliminar()"
              class="px-5 py-2.5 bg-red-600 hover:bg-red-700 text-white text-xs font-bold rounded-full transition-colors shadow-md cursor-pointer"
            >
              Confirmar Desactivación
            </button>
          </div>
        </div>
      </div>
    }
  `
})
export class AdminProductosPage implements OnInit {
  private adminService = inject(ProductAdminService);
  protected auth = inject(AuthService);
  private toast = inject(ToastService);
  private platformId = inject(PLATFORM_ID);

  productos = signal<ProductoItem[]>([]);
  categorias = signal<CategoriaItem[]>([]);
  cargando = signal<boolean>(false);
  guardando = signal<boolean>(false);

  // Formulario de login administrativo
  loginUser = 'admin';
  loginPass = 'admin123';
  iniciandoSesion = signal<boolean>(false);

  // Filtros
  busqueda = signal<string>('');
  categoriaFiltro = signal<number>(0);
  estadoFiltro = signal<string>('todos');

  // Modal
  modalAbierto = signal<boolean>(false);
  modoEdicion = signal<boolean>(false);
  productoAEliminar = signal<ProductoItem | null>(null);

  productoForm: ProductoItem = {
    sku: '',
    nombre: '',
    marca: '',
    modelo: '',
    precio: 0,
    stockActual: 10,
    stockMinimo: 3,
    garantiaMeses: 24,
    especificaciones: '',
    categoriaId: 1,
    activo: true
  };

  stockTotal = computed(() => {
    return this.productos().reduce((acc, p) => acc + (p.stockActual || 0), 0);
  });

  productosFiltrados = computed(() => {
    let list = this.productos();
    const q = this.busqueda().toLowerCase().trim();
    const cat = Number(this.categoriaFiltro());
    const estado = this.estadoFiltro();

    if (q) {
      list = list.filter(p => 
        p.nombre.toLowerCase().includes(q) ||
        p.sku.toLowerCase().includes(q) ||
        p.marca.toLowerCase().includes(q) ||
        p.modelo.toLowerCase().includes(q)
      );
    }

    if (cat > 0) {
      list = list.filter(p => p.categoriaId === cat);
    }

    if (estado === 'activos') {
      list = list.filter(p => p.activo);
    } else if (estado === 'inactivos') {
      list = list.filter(p => !p.activo);
    }

    return list;
  });

  ngOnInit() {
    if (isPlatformBrowser(this.platformId) && this.auth.isAdmin()) {
      this.cargarDatos();
    }
  }

  iniciarSesionAdmin() {
    if (!this.loginUser || !this.loginPass) {
      this.toast.show('Ingresa usuario y contraseña de administrador');
      return;
    }

    this.iniciandoSesion.set(true);
    this.auth.login(this.loginUser, this.loginPass).subscribe({
      next: () => {
        this.iniciandoSesion.set(false);
        if (this.auth.isAdmin()) {
          this.toast.show(`¡Bienvenido Administrador ${this.auth.currentUser()}! Catálogo cargado.`, 4000);
          this.cargarDatos();
        } else {
          this.toast.show('Tu cuenta no posee el rol ROLE_ADMIN en Keycloak.', 4000);
        }
      },
      error: () => {
        this.iniciandoSesion.set(false);
        this.toast.show('Usuario o contraseña incorrectos en Keycloak IAM.');
      }
    });
  }

  cerrarSesionAdmin() {
    this.auth.logout();
    this.productos.set([]);
    this.toast.show('Sesión de administrador cerrada.');
  }

  cargarDatos() {
    this.cargando.set(true);
    this.adminService.listarCategorias().subscribe({
      next: (cats) => this.categorias.set(cats),
      error: () => {}
    });

    this.adminService.listarProductos().subscribe({
      next: (prods) => {
        this.productos.set(prods);
        this.cargando.set(false);
      },
      error: () => {
        this.cargando.set(false);
        this.toast.show('Error al consultar el microservicio pc-catalogo-ms');
      }
    });
  }

  obtenerNombreCategoria(catId: number): string {
    const found = this.categorias().find(c => c.id === catId);
    return found ? found.nombre : `Cat #${catId}`;
  }

  limpiarFiltros() {
    this.busqueda.set('');
    this.categoriaFiltro.set(0);
    this.estadoFiltro.set('todos');
  }

  abrirModalCrear() {
    this.modoEdicion.set(false);
    const primerCat = this.categorias().length > 0 ? this.categorias()[0].id : 1;
    this.productoForm = {
      sku: '',
      nombre: '',
      marca: '',
      modelo: '',
      precio: 0,
      stockActual: 10,
      stockMinimo: 3,
      garantiaMeses: 24,
      especificaciones: '',
      categoriaId: primerCat,
      activo: true
    };
    this.modalAbierto.set(true);
  }

  abrirModalEditar(prod: ProductoItem) {
    this.modoEdicion.set(true);
    this.productoForm = { ...prod };
    this.modalAbierto.set(true);
  }

  cerrarModal() {
    this.modalAbierto.set(false);
  }

  guardarProducto() {
    if (!this.productoForm.sku || !this.productoForm.nombre || !this.productoForm.precio) {
      this.toast.show('Completa los campos obligatorios (*)');
      return;
    }

    this.guardando.set(true);

    if (this.modoEdicion() && this.productoForm.id) {
      this.adminService.actualizarProducto(this.productoForm.id, this.productoForm).subscribe({
        next: (actualizado) => {
          this.guardando.set(false);
          this.modalAbierto.set(false);
          this.toast.show(`Producto #${actualizado.sku} actualizado con éxito`);
          this.cargarDatos();
        },
        error: () => {
          this.guardando.set(false);
          this.toast.show('Error al actualizar producto. Verifica permisos ADMIN.');
        }
      });
    } else {
      this.adminService.crearProducto(this.productoForm).subscribe({
        next: (creado) => {
          this.guardando.set(false);
          this.modalAbierto.set(false);
          this.toast.show(`Nuevo producto #${creado.sku} registrado exitosamente`);
          this.cargarDatos();
        },
        error: () => {
          this.guardando.set(false);
          this.toast.show('Error al crear producto. Verifica permisos ADMIN.');
        }
      });
    }
  }

  confirmarEliminar(prod: ProductoItem) {
    this.productoAEliminar.set(prod);
  }

  ejecutarEliminar() {
    const prod = this.productoAEliminar();
    if (!prod || !prod.id) return;

    this.adminService.eliminarProducto(prod.id).subscribe({
      next: () => {
        this.productoAEliminar.set(null);
        this.toast.show(`Producto ${prod.sku} desactivado del catálogo`);
        this.cargarDatos();
      },
      error: () => {
        this.productoAEliminar.set(null);
        this.toast.show('Error al desactivar producto en pc-catalogo-ms');
      }
    });
  }
}
