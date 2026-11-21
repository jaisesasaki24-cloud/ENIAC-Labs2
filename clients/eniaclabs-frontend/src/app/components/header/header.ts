import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { CartService } from '../../services/cart.service';
import { CatalogService, Product } from '../../services/catalog.service';
import { AuthService } from '../../services/auth.service';

interface MegaPhoneItem {
  id: string;
  name: string;
  badge?: string;
  backImage: string;
  frontImage: string;
}

@Component({
  selector: 'app-header',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, RouterLink, RouterLinkActive],
  template: `
    <!-- Accessibility skip links -->
    <div class="sr-only focus-within:not-sr-only focus-within:absolute focus-within:top-2 focus-within:left-2 focus-within:z-50 focus-within:bg-black focus-within:text-white focus-within:p-3 focus-within:rounded-lg">
      <a href="#mainContent" class="underline mr-4">Saltar al contenido principal</a>
      <a href="#footer" class="underline">Saltar a Acerca de Nosotros</a>
    </div>

    <!-- Main Navigation Header (Exact 3-column replica with Computer Component Names) -->
    <header class="sticky top-0 z-40 w-full bg-white border-b border-gray-100 transition-all select-none">
      <div class="w-full px-6 sm:px-10 lg:px-16 h-[68px] flex items-center justify-between relative">
        
        <!-- 1. LEFT: Logo -->
        <div class="flex-shrink-0">
          <a routerLink="/" (click)="closeAllMenus()" class="flex items-center gap-2.5 text-black hover:opacity-85 transition-opacity" aria-label="ENIAC Labs">
            <span class="flex items-center gap-2">
              <span class="w-8 h-8 rounded-xl bg-black text-white flex items-center justify-center shadow-xs">
                <!-- Computer chip icon for ENIAC Labs -->
                <svg class="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                  <rect x="4" y="4" width="16" height="16" rx="3"/>
                  <rect x="9" y="9" width="6" height="6" rx="1"/>
                  <path d="M9 1v3M15 1v3M9 20v3M15 20v3M20 9h3M20 15h3M1 9h3M1 15h3"/>
                </svg>
              </span>
              <span class="text-[21px] font-black tracking-tight text-black flex items-center font-sans">
                ENIAC<span class="ml-1 text-[#256fff] font-bold">Labs</span>
              </span>
            </span>
          </a>
        </div>

        <!-- 2. CENTER: Desktop Navigation Links (Solo lo visible en la imagen) -->
        <nav class="hidden xl:flex items-center gap-8 text-[14.5px] text-[#111111] font-normal ml-6">
          
          <!-- Componentes -->
          <div 
            class="relative h-[68px] flex items-center"
            (mouseenter)="onHoverOpen('phones')"
            (mouseleave)="onHoverClose()"
          >
            <a 
              routerLink="/componentes"
              routerLinkActive="font-semibold text-black"
              (click)="closeAllMenus()"
              class="relative h-full flex items-center gap-1 hover:text-black transition-colors"
            >
              <span>Componentes</span>
              @if (activeMegaMenu() === 'phones') {
                <span class="absolute bottom-0 left-0 w-full h-[2.5px] bg-black"></span>
              }
            </a>
          </div>

          <!-- Explorar -->
          <div 
            class="relative h-[68px] flex items-center"
            (mouseenter)="onHoverOpen('explore')"
            (mouseleave)="onHoverClose()"
          >
            <a 
              routerLink="/explorar"
              routerLinkActive="font-semibold text-black"
              (click)="closeAllMenus()"
              class="relative h-full flex items-center gap-1 hover:text-black transition-colors"
            >
              <span>Explorar</span>
              @if (activeMegaMenu() === 'explore') {
                <span class="absolute bottom-0 left-0 w-full h-[2.5px] bg-black"></span>
              }
            </a>
          </div>
        </nav>

        <!-- 3. RIGHT: Search, Shopping Bag, User Account, Tienda Button -->
        <div class="flex items-center gap-4 sm:gap-5 flex-shrink-0">
          
          <!-- Search Icon -->
          <button type="button" (click)="openSearch()" class="text-black hover:text-[#256fff] p-1.5 transition-colors" aria-label="Buscar componentes">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
          </button>

          <!-- Shopping Bag Icon -->
          <button type="button" (click)="openCart()" class="relative text-black hover:text-[#256fff] p-1.5 transition-colors" aria-label="Carrito de compras">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path>
            </svg>
            @if (cart.itemCount() > 0) {
              <span class="absolute -top-1 -right-1 min-w-[17px] h-[17px] bg-[#eb1406] text-white text-[10px] font-bold rounded-full flex items-center justify-center px-1">
                {{ cart.itemCount() }}
              </span>
            }
          </button>

          <!-- User Profile Icon -->
          <div class="relative">
            <button type="button" (click)="toggleUserDropdown()" class="text-black hover:text-[#256fff] p-1.5 transition-colors" aria-label="Perfil de usuario">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
              </svg>
            </button>
            @if (isUserMenuOpen()) {
              <div class="absolute right-0 mt-2 w-56 bg-white rounded-2xl shadow-xl border border-black/10 py-3 z-50 text-[13px] animate-fadeIn">
                <div class="px-4 py-2 border-b border-gray-100 flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full bg-black text-white flex items-center justify-center font-bold uppercase text-xs">
                    {{ auth.currentUser() ? auth.currentUser()!.substring(0, 2) : 'PC' }}
                  </div>
                  <div>
                    <div class="font-medium text-black">{{ auth.currentUser() || 'Usuario PC Gamer' }}</div>
                    <div class="text-[11px] text-gray-400">
                      {{ auth.currentUser() ? (auth.currentUser() + ' [' + (auth.isAdmin() ? 'ADMIN' : 'CLIENTE') + ']') : 'cliente@hardware.pe' }}
                    </div>
                  </div>
                </div>
                <button type="button" (click)="openLoginModal()" class="w-full text-left px-4 py-2.5 hover:bg-gray-50 flex items-center gap-2.5 text-gray-700">
                  <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                  Mi cuenta
                </button>
                <a routerLink="/mis-pedidos" (click)="isUserMenuOpen.set(false)" class="w-full text-left px-4 py-2.5 hover:bg-gray-50 flex items-center gap-2.5 text-gray-700 no-underline cursor-pointer">
                  <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                  Seguimiento de pedidos
                </a>
                @if (auth.isAdmin()) {
                  <a routerLink="/admin/productos" (click)="isUserMenuOpen.set(false)" class="w-full text-left px-4 py-2.5 hover:bg-blue-50 flex items-center gap-2.5 text-[#256fff] font-bold no-underline cursor-pointer">
                    <svg class="w-4 h-4 text-[#256fff]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                    Panel Admin (CRUD Productos)
                  </a>
                }
                <button type="button" (click)="openLoginModal()" class="w-full text-left px-4 py-2.5 hover:bg-gray-50 flex items-center gap-2.5 text-gray-700">
                  <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/></svg>
                  Dirección de envío
                </button>
                <div class="border-t border-gray-100 my-1"></div>
                <button type="button" (click)="handleAuthClick()" class="w-full text-left px-4 py-2.5 hover:bg-gray-50 flex items-center gap-2.5 font-medium text-[#256fff]">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/></svg>
                  {{ auth.isAuthenticated() ? 'Cerrar sesión Keycloak' : 'Iniciar sesión / Registrarse' }}
                </button>
              </div>
            }
          </div>

          <!-- Tienda Button -->
          <a 
            href="#category" 
            (click)="scrollToCategory('category', $event)" 
            class="hidden sm:inline-flex items-center justify-center px-5 py-1.5 rounded-full border border-black text-black hover:bg-black hover:text-white text-[13px] font-normal transition-colors"
          >
            Tienda
          </a>

          <!-- Mobile Hamburger Toggle -->
          <button type="button" (click)="toggleMobileMenu()" class="xl:hidden p-2 text-black" aria-label="Abrir menú">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              @if (!isMobileMenuOpen()) {
                <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16"></path>
              } @else {
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"></path>
              }
            </svg>
          </button>
        </div>

      </div>

      <!-- ================= DROPDOWN MENU PARA COMPONENTES (Subcategorías y productos de Hardware) ================= -->
      @if (activeMegaMenu() === 'phones') {
        <div 
          class="absolute top-[68px] left-0 w-full bg-white border-b border-gray-200 shadow-2xl pt-6 pb-8 z-50 transition-all animate-slideDown"
          (mouseenter)="keepMenu()"
          (mouseleave)="onHoverClose()"
        >
          <div class="max-w-[1400px] mx-auto px-4 sm:px-8">
            
            <!-- Sub-pestañas de componentes de PC -->
            <div class="flex items-center justify-center gap-8 sm:gap-12 text-[14px] sm:text-[15px] mb-8">
              <button 
                type="button"
                (click)="phoneTab.set('all')"
                [class.font-semibold]="phoneTab() === 'all'"
                [class.text-black]="phoneTab() === 'all'"
                [class.text-gray-500]="phoneTab() !== 'all'"
                class="hover:text-black transition-colors"
              >
                Últimos lanzamientos
              </button>

              <button 
                type="button"
                (click)="phoneTab.set('magic')"
                [class.font-semibold]="phoneTab() === 'magic'"
                [class.text-black]="phoneTab() === 'magic'"
                [class.text-gray-500]="phoneTab() !== 'magic'"
                class="hover:text-black transition-colors"
              >
                Tarjetas Gráficas RTX
              </button>

              <button 
                type="button"
                (click)="phoneTab.set('n')"
                [class.font-semibold]="phoneTab() === 'n'"
                [class.text-black]="phoneTab() === 'n'"
                [class.text-gray-500]="phoneTab() !== 'n'"
                class="hover:text-black transition-colors"
              >
                Procesadores Gamer
              </button>

              <button 
                type="button"
                (click)="phoneTab.set('x')"
                [class.font-semibold]="phoneTab() === 'x'"
                [class.text-black]="phoneTab() === 'x'"
                [class.text-gray-500]="phoneTab() !== 'x'"
                class="hover:text-black transition-colors"
              >
                Placas & Rendimiento
              </button>
            </div>

            <!-- Fila de 5 tarjetas de componentes de PC -->
            <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4 lg:gap-5 justify-center">
              @for (item of currentPhoneList(); track item.id + '_' + $index) {
                <button 
                  type="button"
                  (click)="onSelectMegaItem(item.id)"
                  class="group flex flex-col items-center justify-between text-center bg-[#f8f9fa] hover:bg-[#f3f4f6] rounded-2xl sm:rounded-3xl p-4 sm:p-5 transition-all duration-200 border border-transparent hover:border-gray-200 cursor-pointer w-full h-[260px] sm:h-[280px]"
                >
                  <!-- Dual angles / hardware presentation -->
                  <div class="h-36 sm:h-40 w-full flex items-center justify-center relative my-auto">
                    <img 
                      [src]="item.backImage" 
                      [alt]="item.name + ' vista posterior'" 
                      class="h-28 sm:h-32 object-contain translate-x-2.5 group-hover:scale-105 transition-transform duration-300"
                    />
                    <img 
                      [src]="item.frontImage" 
                      [alt]="item.name + ' vista frontal'" 
                      class="h-28 sm:h-32 object-contain -translate-x-2.5 group-hover:scale-105 transition-transform duration-300"
                    />
                  </div>

                  <!-- Text Container -->
                  <div class="w-full pb-1">
                    <div 
                      class="text-[12px] font-medium leading-none mb-1 text-center"
                      [class.text-[#256fff]]="item.badge"
                      [class.invisible]="!item.badge"
                    >
                      Nuevo
                    </div>

                    <!-- Component Name -->
                    <div class="text-[13px] sm:text-[14px] font-semibold text-black tracking-tight leading-tight group-hover:text-[#256fff] transition-colors line-clamp-2">
                      {{ item.name }}
                    </div>
                  </div>
                </button>
              }
            </div>

            <!-- Botones inferiores en píldora -->
            <div class="flex items-center justify-center gap-4 mt-8">
              <button 
                type="button" 
                (click)="onMoreProductsClick()"
                class="flex items-center gap-2 px-6 py-2.5 rounded-full border border-gray-300 hover:border-black text-[13px] sm:text-[14px] font-medium text-black bg-white hover:bg-gray-50 transition-colors shadow-xs"
              >
                <!-- 4 squares grid icon -->
                <svg class="w-4 h-4 text-black" viewBox="0 0 16 16" fill="currentColor">
                  <rect x="2" y="2" width="5" height="5" rx="1.2"/>
                  <rect x="9" y="2" width="5" height="5" rx="1.2"/>
                  <rect x="2" y="9" width="5" height="5" rx="1.2"/>
                  <rect x="9" y="9" width="5" height="5" rx="1.2"/>
                </svg>
                <span>Más componentes</span>
              </button>

              <button 
                type="button"
                (click)="onMoreProductsClick()"
                class="flex items-center gap-2 px-6 py-2.5 rounded-full border border-gray-300 hover:border-black text-[13px] sm:text-[14px] font-medium text-black bg-white hover:bg-gray-50 transition-colors shadow-xs"
              >
                <!-- comparison icon -->
                <svg class="w-4 h-4 text-black" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                  <rect x="3" y="4" width="7" height="16" rx="1.5"/>
                  <rect x="14" y="4" width="7" height="16" rx="1.5"/>
                  <line x1="10" y1="12" x2="14" y2="12"/>
                </svg>
                <span>Comparar hardware</span>
              </button>
            </div>

          </div>
        </div>
      }


      @if (activeMegaMenu() === 'explore') {
        <div 
          class="absolute top-[68px] left-0 w-full bg-white border-b border-gray-200 shadow-2xl py-8 z-50 transition-all animate-slideDown"
          (mouseenter)="keepMenu()"
          (mouseleave)="onHoverClose()"
        >
          <div class="max-w-[1400px] mx-auto px-8 grid grid-cols-4 gap-8 text-xs">
            <div>
              <h4 class="font-bold text-sm text-gray-900 mb-3">Marcas Oficiales</h4>
              <ul class="space-y-2 text-gray-600">
                <li><a href="#category" class="hover:text-[#256fff]">NVIDIA GeForce</a></li>
                <li><a href="#category" class="hover:text-[#256fff]">AMD Radeon & Ryzen</a></li>
                <li><a href="#category" class="hover:text-[#256fff]">Intel Core Ultra</a></li>
                <li><a href="#category" class="hover:text-[#256fff]">ASUS Republic of Gamers</a></li>
              </ul>
            </div>
            <div>
              <h4 class="font-bold text-sm text-gray-900 mb-3">Servicios</h4>
              <ul class="space-y-2 text-gray-600">
                <li><a href="#peshop1" class="hover:text-[#256fff]">Servicio de Ensamblado Profesional</a></li>
                <li><a href="#peshop2" class="hover:text-[#256fff]">Instalación de Drivers y BIOS</a></li>
              </ul>
            </div>
            <div>
              <h4 class="font-bold text-sm text-gray-900 mb-3">Tienda</h4>
              <ul class="space-y-2 text-gray-600">
                <li><a href="#peshop2" (click)="scrollToCategory('peshop2', $event)" class="hover:text-[#256fff]">Nuevos Componentes</a></li>
                <li><a href="#sub" (click)="scrollToCategory('sub', $event)" class="hover:text-[#256fff]">Cupones de Descuento</a></li>
              </ul>
            </div>
            <div class="bg-gray-50 p-4 rounded-2xl">
              <span class="text-[10px] font-bold uppercase text-[#256fff]">Garantía PC</span>
              <h5 class="font-bold text-sm text-gray-900 mt-1">Garantía Directa</h5>
              <p class="text-xs text-gray-500 mt-1">Todos los componentes cuentan con garantía oficial de fabricante.</p>
            </div>
          </div>
        </div>
      }

      <!-- Mobile Menu Drawer -->
      @if (isMobileMenuOpen()) {
        <div class="xl:hidden bg-white border-b border-gray-200 px-6 py-6 space-y-4 animate-fadeIn max-h-[80vh] overflow-y-auto">
          <div class="space-y-3 font-medium text-[15px] text-gray-800">
            <a routerLink="/componentes" (click)="closeAllMenus()" class="block py-2 border-b border-gray-100 font-bold text-black flex items-center justify-between">
              <span>Componentes</span>
              <span>›</span>
            </a>
            <a routerLink="/explorar" (click)="closeAllMenus()" class="block py-2 border-b border-gray-100">
              Explorar
            </a>
          </div>

          <div class="pt-2 flex flex-col gap-3">
            <button type="button" (click)="openLoginModal(); isMobileMenuOpen.set(false)" class="w-full py-3 bg-gray-100 text-gray-800 rounded-xl font-medium text-sm">
              Iniciar sesión / Registrarse
            </button>
            <button type="button" (click)="scrollToCategoryMobile('category')" class="w-full py-3 bg-black text-white rounded-xl font-medium text-sm">
              Comprar en Tienda Oficial
            </button>
          </div>
        </div>
      }
    </header>
  `,
  styles: [`
    @keyframes slideDown {
      from { 
        opacity: 0; 
        transform: translateY(-6px); 
      }
      to { 
        opacity: 1; 
        transform: translateY(0); 
      }
    }
    .animate-slideDown {
      animation: slideDown 0.2s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    .animate-fadeIn {
      animation: fadeIn 0.15s ease forwards;
    }
  `]
})
export class HeaderComponent {
  cart = inject(CartService);
  catalog = inject(CatalogService);
  auth = inject(AuthService);

  activeMegaMenu = signal<'phones' | 'explore' | null>(null);
  phoneTab = signal<'all' | 'magic' | 'n' | 'x'>('all');
  isMobileMenuOpen = signal<boolean>(false);
  isUserMenuOpen = signal<boolean>(false);

  private closeTimer: ReturnType<typeof setTimeout> | null = null;

  // 5 Componentes de PC para "Últimos lanzamientos"
  readonly latestPhones: MegaPhoneItem[] = [
    {
      id: 'honor-600-smart',
      name: 'AMD Ryzen 7 7800X3D',
      badge: 'Nuevo',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-smart/honor-600-smart-purple-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-smart/honor-600-smart-purple-front.png'
    },
    {
      id: 'honor-600',
      name: 'GeForce RTX 4070 Ti Super',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600/honor-600-id-orange-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600/honor-600-id-orange-front.png'
    },
    {
      id: 'honor-600-pro',
      name: 'GeForce RTX 4080 Super',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-pro/honor-600-pro-id-white-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-pro/honor-600-pro-id-white-front.png'
    },
    {
      id: 'honor-600e',
      name: 'Radeon RX 7800 XT',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-lite/honor-600-lite-id-green-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-lite/honor-600-lite-id-green-front.png'
    },
    {
      id: 'honor-x7e-plus-5g',
      name: 'Intel Core i9 14900KS',
      badge: 'Nuevo',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e-plus-5g/honor-x7e-plus-5g-gold-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e-plus-5g/honor-x7e-plus-5g-gold-front.png'
    }
  ];

  // Tarjetas Gráficas RTX
  readonly magicPhones: MegaPhoneItem[] = [
    {
      id: 'honor-magic8-pro',
      name: 'GeForce RTX 4090 Extreme',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-magic8-pro/magic8-pro-id-gold-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-magic8-pro/cn/magic8-pro-id-gold-front.png'
    },
    {
      id: 'honor-magic8-lite',
      name: 'GeForce RTX 4060 Ti Dual',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-magic8-lite/honor-magic8-lite-green-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-magic8-lite/honor-magic8-lite-green-front.png'
    },
    {
      id: 'honor-600-pro',
      name: 'GeForce RTX 4080 Super',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-pro/honor-600-pro-id-white-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-pro/honor-600-pro-id-white-front.png'
    },
    {
      id: 'honor-600',
      name: 'GeForce RTX 4070 Ti Super',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600/honor-600-id-orange-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600/honor-600-id-orange-front.png'
    },
    {
      id: 'honor-600e',
      name: 'Radeon RX 7800 XT',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-lite/honor-600-lite-id-green-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-lite/honor-600-lite-id-green-front.png'
    }
  ];

  // Procesadores Gamer
  readonly nPhones: MegaPhoneItem[] = [
    {
      id: 'honor-600-smart',
      name: 'AMD Ryzen 7 7800X3D',
      badge: 'Nuevo',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-smart/honor-600-smart-purple-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600-smart/honor-600-smart-purple-front.png'
    },
    {
      id: 'honor-x7e-plus-5g',
      name: 'Intel Core i9 14900KS',
      badge: 'Nuevo',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e-plus-5g/honor-x7e-plus-5g-gold-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e-plus-5g/honor-x7e-plus-5g-gold-front.png'
    },
    {
      id: 'honor-x7e',
      name: 'Intel Core i5 14600KF',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e/honor-x7e-orange-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e/honor-x7e-orange-front.png'
    },
    {
      id: 'honor-x8d',
      name: 'AMD Ryzen 5 7600X',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x8d/honor-x8d-blue-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x8d/honor-x8d-blue-front.png'
    },
    {
      id: 'honor-x6e',
      name: 'AMD Ryzen 5 5600X',
      backImage: 'https://www-file.honor.com/content/dam/honor/pe/shop/id/x6e-gold.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/pe/shop/id/x6e-black.png'
    }
  ];

  // Placas & Rendimiento
  readonly xPhones: MegaPhoneItem[] = [
    {
      id: 'honor-x7e-plus-5g',
      name: 'ASUS ROG Strix Z790-E',
      badge: 'Nuevo',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e-plus-5g/honor-x7e-plus-5g-gold-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e-plus-5g/honor-x7e-plus-5g-gold-front.png'
    },
    {
      id: 'honor-x7e',
      name: 'MSI MAG B650 Tomahawk',
      badge: 'Nuevo',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e/honor-x7e-orange-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x7e/honor-x7e-orange-front.png'
    },
    {
      id: 'honor-x6e',
      name: 'Gigabyte B760M AORUS',
      badge: 'Nuevo',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x6e/honor-x6e-id-gold-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x6e/honor-x6e-id-black-front.png'
    },
    {
      id: 'honor-x8d',
      name: 'Corsair Vengeance 64GB',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x8d/honor-x8d-blue-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-x8d/honor-x8d-blue-front.png'
    },
    {
      id: 'honor-600',
      name: 'Kingston Fury Beast 32GB',
      backImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600/honor-600-id-orange-back.png',
      frontImage: 'https://www-file.honor.com/content/dam/honor/common/product-list/product-series/honor-600/honor-600-id-orange-front.png'
    }
  ];

  currentPhoneList(): MegaPhoneItem[] {
    const tab = this.phoneTab();
    if (tab === 'all') return this.latestPhones;
    if (tab === 'magic') return this.magicPhones;
    if (tab === 'n') return this.nPhones;
    if (tab === 'x') return this.xPhones;
    return this.latestPhones;
  }

  onHoverOpen(menu: 'phones' | 'explore') {
    if (this.closeTimer) clearTimeout(this.closeTimer);
    this.activeMegaMenu.set(menu);
  }

  onHoverClose() {
    this.closeTimer = setTimeout(() => {
      this.activeMegaMenu.set(null);
    }, 220);
  }

  keepMenu() {
    if (this.closeTimer) clearTimeout(this.closeTimer);
  }

  toggleMenu(menu: 'phones' | 'explore') {
    if (this.activeMegaMenu() === menu) {
      this.activeMegaMenu.set(null);
    } else {
      this.activeMegaMenu.set(menu);
    }
  }

  closeMenuImmediately() {
    if (this.closeTimer) clearTimeout(this.closeTimer);
    this.activeMegaMenu.set(null);
  }

  closeAllMenus() {
    this.closeMenuImmediately();
    this.isMobileMenuOpen.set(false);
    this.isUserMenuOpen.set(false);
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen.update(v => !v);
  }

  toggleUserDropdown() {
    this.isUserMenuOpen.update(v => !v);
  }

  openSearch() {
    this.catalog.openSearch();
  }

  openCart() {
    this.cart.openCart();
  }

  openLoginModal() {
    this.catalog.openLoginModal();
    this.isUserMenuOpen.set(false);
  }

  handleAuthClick() {
    if (this.auth.isAuthenticated()) {
      this.auth.logout();
      this.isUserMenuOpen.set(false);
    } else {
      this.openLoginModal();
    }
  }

  onSelectMegaItem(id: string) {
    this.closeMenuImmediately();
    const product = this.catalog.products.find(p => p.id === id);
    if (product) {
      this.catalog.openQuickBuy(product);
    } else {
      this.scrollToCategory('category', new Event('click'));
    }
  }

  onSelectProduct(product: Product) {
    this.closeMenuImmediately();
    this.catalog.openQuickBuy(product);
  }

  onMoreProductsClick() {
    this.closeMenuImmediately();
    const el = document.getElementById('category');
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }

  scrollToCategory(id: string, event: Event) {
    event.preventDefault();
    this.closeMenuImmediately();
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }

  scrollToCategoryMobile(id: string) {
    this.isMobileMenuOpen.set(false);
    this.closeMenuImmediately();
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }

  scrollToTop(event: Event) {
    event.preventDefault();
    this.closeMenuImmediately();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
}
