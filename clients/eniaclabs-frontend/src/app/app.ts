import { ChangeDetectionStrategy, Component, OnInit, inject, PLATFORM_ID } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { HeaderComponent } from './components/header/header';
import { FooterComponent } from './components/footer/footer';
import { CartDrawerComponent } from './components/cart-drawer/cart-drawer';
import { SearchModalComponent } from './components/search-modal/search-modal';
import { QuickBuyModalComponent } from './components/quick-buy-modal/quick-buy-modal';
import { LoginModalComponent } from './components/login-modal/login-modal';
import { FloatingActionsComponent } from './components/floating-actions/floating-actions';
import { ToastComponent } from './components/toast/toast';
import { AuthService } from './services/auth.service';
import { CatalogService } from './services/catalog.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'app-root',
  imports: [
    CommonModule,
    RouterOutlet,
    HeaderComponent,
    FooterComponent,
    CartDrawerComponent,
    SearchModalComponent,
    QuickBuyModalComponent,
    LoginModalComponent,
    FloatingActionsComponent,
    ToastComponent
  ],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App implements OnInit {
  private auth = inject(AuthService);
  private catalog = inject(CatalogService);
  private platformId = inject(PLATFORM_ID);

  ngOnInit() {
    if (isPlatformBrowser(this.platformId)) {
      // 1. Conexión segura con Keycloak (OAuth2 / OIDC): Obtiene token JWT Bearer
      this.auth.ensureToken().subscribe({
        next: (token) => {
          if (token) {
            console.log('[ENIAC Distributed System] ✓ Sesión segura Keycloak activa. Token JWT Bearer listo.');
          }
          // 2. Conexión observable e integrada con Gateway :18080 y pc-catalogo-ms
          this.catalog.loadBackendCatalog();
        },
        error: (err) => {
          console.warn('[ENIAC Distributed System] Advertencia de autenticación:', err);
          this.catalog.loadBackendCatalog();
        }
      });
    }
  }
}
