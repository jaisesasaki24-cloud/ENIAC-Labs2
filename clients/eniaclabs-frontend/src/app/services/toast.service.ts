import { Injectable, signal } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ToastService {
  toastMessage = signal<string | null>(null);
  private timer: ReturnType<typeof setTimeout> | null = null;

  show(message: string, duration = 2500) {
    if (this.timer) clearTimeout(this.timer);
    this.toastMessage.set(message);
    this.timer = setTimeout(() => {
      this.toastMessage.set(null);
    }, duration);
  }

  copyToClipboard(text: string, customMessage = 'Copia exitosa') {
    if (typeof navigator !== 'undefined' && navigator.clipboard?.writeText) {
      navigator.clipboard.writeText(text).then(() => {
        this.show(customMessage);
      }).catch(() => {
        this.show(customMessage);
      });
    } else {
      this.show(customMessage);
    }
  }
}
