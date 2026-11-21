import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-toast',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule],
  template: `
    @if (toast.toastMessage(); as msg) {
      <div class="fixed top-24 left-1/2 -translate-x-1/2 z-50 animate-bounceAndFade pointer-events-none">
        <div class="bg-black/85 text-white text-sm font-semibold px-6 py-3 rounded-full shadow-2xl backdrop-blur-md border border-white/10 flex items-center gap-2">
          <span>✓</span>
          <span>{{ msg }}</span>
        </div>
      </div>
    }
  `,
  styles: [`
    @keyframes bounceAndFade {
      0% { opacity: 0; transform: translate(-50%, -10px); }
      20% { opacity: 1; transform: translate(-50%, 0); }
      80% { opacity: 1; transform: translate(-50%, 0); }
      100% { opacity: 0; transform: translate(-50%, -8px); }
    }
    .animate-bounceAndFade {
      animation: bounceAndFade 2.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
  `]
})
export class ToastComponent {
  toast = inject(ToastService);
}
