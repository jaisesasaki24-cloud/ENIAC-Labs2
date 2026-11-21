import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/home/home').then(m => m.HomePage)
  },
  {
    path: 'componentes',
    loadComponent: () => import('./pages/componentes/componentes').then(m => m.ComponentesPage)
  },
  {
    path: 'catalogo',
    redirectTo: 'componentes',
    pathMatch: 'full'
  },
  {
    path: 'tienda',
    redirectTo: 'componentes',
    pathMatch: 'full'
  },
  {
    path: 'explorar',
    loadComponent: () => import('./pages/explorar/explorar').then(m => m.ExplorarPage)
  },
  {
    path: 'mis-pedidos',
    loadComponent: () => import('./pages/mis-pedidos/mis-pedidos').then(m => m.MisPedidosPage)
  },
  {
    path: 'producto/:id',
    loadComponent: () => import('./pages/producto-detalle/producto-detalle').then(m => m.ProductoDetallePage)
  },
  {
    path: 'pagar',
    loadComponent: () => import('./pages/pagar/pagar').then(m => m.PagarPage)
  },
  {
    path: 'pagar/success',
    loadComponent: () => import('./pages/pagar/pagar').then(m => m.PagarPage)
  },
  {
    path: 'pagar/failure',
    loadComponent: () => import('./pages/pagar/pagar').then(m => m.PagarPage)
  },
  {
    path: 'pagar/pending',
    loadComponent: () => import('./pages/pagar/pagar').then(m => m.PagarPage)
  },
  {
    path: 'checkout',
    redirectTo: 'pagar',
    pathMatch: 'full'
  },
  {
    path: 'admin',
    redirectTo: 'admin/productos',
    pathMatch: 'full'
  },
  {
    path: 'admin/productos',
    loadComponent: () => import('./pages/admin-productos/admin-productos').then(m => m.AdminProductosPage)
  },
  {
    path: '**',
    redirectTo: ''
  }
];
