import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { CatalogService, Product } from '../../services/catalog.service';

@Component({
  selector: 'app-search-modal',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, FormsModule],
  template: `
    @if (catalog.isSearchOpen()) {
      <button 
        type="button"
        (click)="catalog.closeSearch()" 
        class="fixed inset-0 w-full h-full bg-black/60 backdrop-blur-sm z-50 transition-opacity animate-fadeIn border-none p-0 m-0 cursor-default"
        aria-label="Cerrar modal de búsqueda"
      ></button>

      <div class="fixed top-0 left-0 w-full bg-white z-50 shadow-2xl py-6 px-4 sm:px-8 border-b border-gray-200 animate-slideDown">
        <div class="max-w-[1000px] mx-auto">
          
          <!-- Search Header Input -->
          <div class="flex items-center gap-3 relative pb-4 border-b border-gray-200">
            <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
            
            <input 
              type="text" 
              [(ngModel)]="searchQuery"
              (input)="onSearchInput()"
              placeholder="Buscar componentes (Ej: RTX 4080, Ryzen 7, DDR5, Z790, SSD...)" 
              class="w-full text-base sm:text-lg text-black placeholder-gray-400 focus:outline-none bg-transparent"
              aria-label="Buscar en la tienda"
            />

            @if (searchQuery()) {
              <button type="button" (click)="clearSearch()" class="p-1 text-gray-400 hover:text-black" aria-label="Limpiar búsqueda">
                ✕
              </button>
            }

            <button 
              type="button"
              (click)="catalog.closeSearch()" 
              class="px-4 py-2 text-xs font-semibold bg-gray-100 hover:bg-black hover:text-white rounded-full transition-colors flex-shrink-0"
            >
              Cerrar
            </button>
          </div>

          <!-- Dynamic Results or Suggestions -->
          <div class="py-6 max-h-[60vh] overflow-y-auto">
            @if (filteredProducts().length > 0 && searchQuery().trim().length > 0) {
              <div>
                <h4 class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-4">
                  Productos Encontrados ({{ filteredProducts().length }})
                </h4>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                  @for (prod of filteredProducts(); track prod.id) {
                    <button 
                      type="button"
                      (click)="selectProduct(prod)"
                      class="flex items-center gap-3 p-3 rounded-2xl border border-gray-100 bg-gray-50 hover:bg-white hover:shadow-md cursor-pointer transition-all w-full text-left"
                    >
                      <img [src]="prod.colors[0].image" [alt]="prod.name" class="w-16 h-16 object-contain bg-white rounded-xl p-1" />
                      <div>
                        <h5 class="font-bold text-sm text-gray-900">{{ prod.name }}</h5>
                        <p class="text-xs text-gray-500 line-clamp-1">{{ prod.description }}</p>
                        <span class="text-xs font-bold text-black mt-1 block">S/ {{ prod.price | number:'1.0-0' }}</span>
                      </div>
                    </button>
                  }
                </div>
              </div>
            } @else if (searchQuery().trim().length > 0 && filteredProducts().length === 0) {
              <div class="text-center py-12 text-gray-500">
                <p class="text-base font-semibold">No se encontraron productos para "{{ searchQuery() }}"</p>
                <p class="text-xs text-gray-400 mt-1">Prueba con palabras como "RTX 4080", "Ryzen", "Z790", "DDR5", "SSD"</p>
              </div>
            } @else {
              <!-- Default Suggestions when empty query -->
              <div class="space-y-6">
                <!-- Trending Queries -->
                <div>
                  <h4 class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-3">
                    Resultados Populares
                  </h4>
                  <div class="flex flex-wrap gap-2">
                    @for (item of popularSearches; track item) {
                      <button 
                        type="button"
                        (click)="setQuery(item)"
                        class="px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-full text-xs font-medium text-gray-800 transition-colors"
                      >
                        {{ item }}
                      </button>
                    }
                  </div>
                </div>

                <!-- Featured Products -->
                <div>
                  <h4 class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-3">
                    Recomendaciones de Temporada
                  </h4>
                  <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
                    @for (prod of catalog.products.slice(0, 4); track prod.id) {
                      <button 
                        type="button"
                        (click)="selectProduct(prod)"
                        class="p-3 bg-gray-50 hover:bg-white rounded-2xl border border-gray-100 cursor-pointer text-center hover:shadow-sm transition-all w-full"
                      >
                        <img [src]="prod.colors[0].image" [alt]="prod.name" class="h-24 mx-auto object-contain mb-2" />
                        <h6 class="text-xs font-bold text-gray-900 truncate">{{ prod.name }}</h6>
                        <span class="text-xs text-gray-600">S/ {{ prod.price }}</span>
                      </button>
                    }
                  </div>
                </div>
              </div>
            }
          </div>

        </div>
      </div>
    }
  `,
  styles: [`
    @keyframes slideDown {
      from { transform: translateY(-100%); }
      to { transform: translateY(0); }
    }
    .animate-slideDown {
      animation: slideDown 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
  `]
})
export class SearchModalComponent {
  catalog = inject(CatalogService);

  searchQuery = signal<string>('');
  filteredProducts = signal<Product[]>([]);

  readonly popularSearches = [
    'GeForce RTX 4080',
    'AMD Ryzen 7 7800X3D',
    'ASUS ROG Z790',
    'Corsair DDR5 6000MHz',
    'Samsung 990 PRO 2TB',
    'Fuente RM1000x',
    'NZXT Kraken Elite'
  ];

  onSearchInput() {
    const q = this.searchQuery().toLowerCase().trim();
    if (!q) {
      this.filteredProducts.set([]);
      return;
    }
    const matches = this.catalog.products.filter(p => 
      p.name.toLowerCase().includes(q) || 
      p.description.toLowerCase().includes(q) ||
      p.category.toLowerCase().includes(q)
    );
    this.filteredProducts.set(matches);
  }

  setQuery(query: string) {
    this.searchQuery.set(query);
    this.onSearchInput();
  }

  clearSearch() {
    this.searchQuery.set('');
    this.filteredProducts.set([]);
  }

  selectProduct(product: Product) {
    this.catalog.closeSearch();
    this.catalog.openQuickBuy(product);
  }
}
