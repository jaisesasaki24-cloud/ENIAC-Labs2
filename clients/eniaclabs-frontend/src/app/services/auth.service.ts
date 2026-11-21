import { Injectable, inject, signal, computed } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable, tap, catchError, throwError, of, map } from 'rxjs';
import { environment } from '../../environments/environment';

export interface TokenResponse {
  access_token: string;
  expires_in: number;
  refresh_expires_in: number;
  refresh_token: string;
  token_type: string;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private http = inject(HttpClient);

  readonly token = signal<string | null>(this.getInitialToken());
  readonly currentUser = signal<string | null>(typeof window !== 'undefined' ? localStorage.getItem('username') : null);
  readonly userRoles = signal<string[]>(
    typeof window !== 'undefined' ? JSON.parse(localStorage.getItem('roles') || '[]') : []
  );

  readonly isAuthenticated = computed(() => !!this.token());
  readonly isAdmin = computed(() => this.userRoles().includes('ADMIN'));

  isTokenExpired(token: string | null): boolean {
    if (!token) return true;
    try {
      const payloadPart = token.split('.')[1];
      const decoded = JSON.parse(atob(payloadPart.replace(/-/g, '+').replace(/_/g, '/')));
      if (!decoded.exp) return false;
      return Date.now() >= (decoded.exp * 1000 - 10000);
    } catch {
      return true;
    }
  }

  private getInitialToken(): string | null {
    if (typeof window === 'undefined') return null;
    const token = localStorage.getItem('access_token');
    if (!token || this.isTokenExpired(token)) {
      if (token) {
        localStorage.removeItem('access_token');
        localStorage.removeItem('username');
        localStorage.removeItem('roles');
      }
      return null;
    }
    return token;
  }

  login(identifier: string, password: string): Observable<TokenResponse> {
    const url = `${environment.keycloakUrl}/realms/${environment.realm}/protocol/openid-connect/token`;

    const body = new HttpParams()
      .set('client_id', environment.clientId)
      .set('grant_type', 'password')
      .set('username', identifier)
      .set('password', password);

    const headers = new HttpHeaders({
      'Content-Type': 'application/x-www-form-urlencoded'
    });

    return this.http.post<TokenResponse>(url, body.toString(), { headers }).pipe(
      tap(res => {
        const token = res.access_token;
        this.token.set(token);
        if (typeof window !== 'undefined') {
          localStorage.setItem('access_token', token);
        }

        try {
          const payloadPart = token.split('.')[1];
          const decoded = JSON.parse(atob(payloadPart.replace(/-/g, '+').replace(/_/g, '/')));
          const username = decoded.preferred_username || identifier;
          const roles = decoded.realm_access?.roles || [];

          this.currentUser.set(username);
          this.userRoles.set(roles);

          if (typeof window !== 'undefined') {
            localStorage.setItem('username', username);
            localStorage.setItem('roles', JSON.stringify(roles));
          }
        } catch {
          this.currentUser.set(identifier);
        }
      }),
      catchError(err => throwError(() => err))
    );
  }

  ensureToken(): Observable<string | null> {
    if (typeof window === 'undefined') return of(null);
    const existing = this.token();
    if (existing && !this.isTokenExpired(existing)) return of(existing);

    if (existing && this.isTokenExpired(existing)) {
      this.logout();
    }

    return this.login('cliente1', 'cliente123').pipe(
      map(res => res.access_token),
      catchError(() => of(null))
    );
  }

  logout() {
    this.token.set(null);
    this.currentUser.set(null);
    this.userRoles.set([]);
    if (typeof window !== 'undefined') {
      localStorage.removeItem('access_token');
      localStorage.removeItem('username');
      localStorage.removeItem('roles');
    }
  }

  getAuthHeaders(): HttpHeaders {
    let headers = new HttpHeaders();
    const token = this.token();
    if (token) {
      headers = headers.set('Authorization', `Bearer ${token}`);
    }
    return headers;
  }
}
