import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, switchMap, of } from 'rxjs';
import { environment } from '../../environments/environment';
import { AuthService } from './auth.service';

export interface ProductoItem {
  id?: number;
  sku: string;
  nombre: string;
  marca: string;
  modelo: string;
  precio: number;
  stockActual: number;
  stockMinimo?: number;
  garantiaMeses?: number;
  especificaciones?: string;
  categoriaId: number;
  categoriaNombre?: string;
  activo?: boolean;
}

export interface CategoriaItem {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;
  activo: boolean;
  totalProductos?: number;
}

@Injectable({
  providedIn: 'root'
})
export class ProductAdminService {
  private http = inject(HttpClient);
  private auth = inject(AuthService);

  private isBrowser(): boolean {
    return typeof window !== 'undefined';
  }

  ensureAdminAuth(): Observable<any> {
    if (!this.isBrowser()) return of(null);
    if (this.auth.token() && this.auth.isAdmin()) {
      return of(this.auth.token());
    }
    // Auto-login con credenciales oficiales de Administrador de Keycloak
    return this.auth.login('admin', 'admin123');
  }

  listarProductos(categoriaId?: number, activo?: boolean): Observable<ProductoItem[]> {
    if (!this.isBrowser()) return of([]);
    let url = `${environment.apiBaseUrl}/api/v1/productos`;
    const params: string[] = [];
    if (categoriaId !== undefined) params.push(`categoriaId=${categoriaId}`);
    if (activo !== undefined) params.push(`activo=${activo}`);
    if (params.length > 0) url += `?${params.join('&')}`;
    return this.http.get<ProductoItem[]>(url);
  }

  obtenerProducto(id: number): Observable<ProductoItem> {
    const url = `${environment.apiBaseUrl}/api/v1/productos/${id}`;
    return this.http.get<ProductoItem>(url);
  }

  listarCategorias(): Observable<CategoriaItem[]> {
    if (!this.isBrowser()) return of([]);
    return this.http.get<CategoriaItem[]>(`${environment.apiBaseUrl}/api/v1/categorias`);
  }

  crearProducto(producto: ProductoItem): Observable<ProductoItem> {
    const url = `${environment.apiBaseUrl}/api/v1/productos`;
    return this.ensureAdminAuth().pipe(
      switchMap(() => {
        const headers = this.auth.getAuthHeaders();
        return this.http.post<ProductoItem>(url, producto, { headers });
      })
    );
  }

  actualizarProducto(id: number, producto: ProductoItem): Observable<ProductoItem> {
    const url = `${environment.apiBaseUrl}/api/v1/productos/${id}`;
    return this.ensureAdminAuth().pipe(
      switchMap(() => {
        const headers = this.auth.getAuthHeaders();
        return this.http.put<ProductoItem>(url, producto, { headers });
      })
    );
  }

  eliminarProducto(id: number): Observable<void> {
    const url = `${environment.apiBaseUrl}/api/v1/productos/${id}`;
    return this.ensureAdminAuth().pipe(
      switchMap(() => {
        const headers = this.auth.getAuthHeaders();
        return this.http.delete<void>(url, { headers });
      })
    );
  }
}
