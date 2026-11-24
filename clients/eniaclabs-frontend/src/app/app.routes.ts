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
    path: 'terminos',
    loadComponent: () => import('./pages/terminos/terminos').then(m => m.TerminosPage)
  },
  {
    path: 'terminos-y-condiciones',
    redirectTo: 'terminos',
    pathMatch: 'full'
  },
  {
    path: 'devoluciones',
    loadComponent: () => import('./pages/devoluciones/devoluciones').then(m => m.DevolucionesPage)
  },
  {
    path: 'politicas-de-devolucion',
    redirectTo: 'devoluciones',
    pathMatch: 'full'
  },
  {
    path: 'libro-de-reclamaciones',
    loadComponent: () => import('./pages/libro-de-reclamaciones/libro-de-reclamaciones').then(m => m.LibroDeReclamacionesPage)
  },
  {
    path: 'reclamaciones',
    redirectTo: 'libro-de-reclamaciones',
    pathMatch: 'full'
  },
  {
    path: '**',
    redirectTo: ''
  }
];
