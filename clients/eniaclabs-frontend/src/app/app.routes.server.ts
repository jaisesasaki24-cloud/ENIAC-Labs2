import {RenderMode, ServerRoute} from '@angular/ssr';

export const serverRoutes: ServerRoute[] = [
  {
    path: 'producto/:id',
    renderMode: RenderMode.Client,
  },
  {
    path: 'admin/productos',
    renderMode: RenderMode.Client,
  },
  {
    path: 'pagar',
    renderMode: RenderMode.Client,
  },
  {
    path: '**',
    renderMode: RenderMode.Prerender,
  },
];
