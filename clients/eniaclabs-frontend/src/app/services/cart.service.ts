import { Injectable, signal, computed } from '@angular/core';

export interface CartItem {
  id: string;
  name: string;
  color: string;
  storage?: string;
  price: number;
  originalPrice?: number;
  quantity: number;
  image: string;
}

@Injectable({
  providedIn: 'root'
})
export class CartService {
  private itemsSignal = signal<CartItem[]>([
    {
      id: 'cable-hdmi-8k',
      name: 'Cable HDMI 2.1 Ultra High Speed 8K (2m)',
      color: 'Negro Blindado Oro 24K',
      storage: '2 Metros (48Gbps)',
      price: 10.00,
      originalPrice: 45.00,
      quantity: 1,
      image: '/images/cable-hdmi.svg'
    }
  ]);

  isCartOpen = signal<boolean>(false);
  appliedCoupon = signal<string | null>(null);
  couponDiscountPercent = signal<number>(0);

  items = computed(() => this.itemsSignal());

  itemCount = computed(() => {
    return this.itemsSignal().reduce((sum, item) => sum + item.quantity, 0);
  });

  subtotal = computed(() => {
    return this.itemsSignal().reduce((sum, item) => sum + (item.price * item.quantity), 0);
  });

  discountAmount = computed(() => {
    if (!this.appliedCoupon()) return 0;
    return Math.round((this.subtotal() * (this.couponDiscountPercent() / 100)) * 100) / 100;
  });

  total = computed(() => {
    const raw = this.subtotal() - this.discountAmount();
    return Math.max(0, raw);
  });

  installment12 = computed(() => {
    return (this.total() / 12).toFixed(2);
  });

  addToCart(product: Omit<CartItem, 'quantity'>, quantity = 1) {
    const current = this.itemsSignal();
    const existingIndex = current.findIndex(i => i.id === product.id && i.color === product.color);
    if (existingIndex > -1) {
      const updated = [...current];
      updated[existingIndex].quantity += quantity;
      this.itemsSignal.set(updated);
    } else {
      this.itemsSignal.set([...current, { ...product, quantity }]);
    }
    this.isCartOpen.set(true);
  }

  updateQuantity(itemId: string, color: string, delta: number) {
    const current = this.itemsSignal();
    const updated = current
      .map(item => {
        if (item.id === itemId && item.color === color) {
          const newQty = item.quantity + delta;
          return newQty > 0 ? { ...item, quantity: newQty } : null;
        }
        return item;
      })
      .filter((item): item is CartItem => item !== null);
    
    this.itemsSignal.set(updated);
  }

  removeItem(itemId: string, color: string) {
    const current = this.itemsSignal();
    this.itemsSignal.set(current.filter(i => !(i.id === itemId && i.color === color)));
  }

  clearCart() {
    this.itemsSignal.set([]);
  }

  openCart() {
    this.isCartOpen.set(true);
  }

  closeCart() {
    this.isCartOpen.set(false);
  }

  applyCoupon(code: string): boolean {
    if (code.trim().toUpperCase() === 'APEALL35' || code.trim().toUpperCase() === 'HONOR8') {
      this.appliedCoupon.set(code.trim().toUpperCase());
      this.couponDiscountPercent.set(8);
      return true;
    }
    return false;
  }

  removeCoupon() {
    this.appliedCoupon.set(null);
  }
}
