import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HeroBannerComponent } from '../../components/hero-banner/hero-banner';
import { PromoGridComponent } from '../../components/promo-grid/promo-grid';
import { CategorySliderComponent } from '../../components/category-slider/category-slider';
import { SubscribeComponent } from '../../components/subscribe/subscribe';

@Component({
  selector: 'app-home',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [
    CommonModule,
    HeroBannerComponent,
    PromoGridComponent,
    CategorySliderComponent,
    SubscribeComponent
  ],
  template: `
    <!-- Hero Banner & Value Proposition Strip -->
    <app-hero-banner />

    <!-- Promotional Offers & "Nuevos Ingresos" Grid -->
    <app-promo-grid />

    <!-- "Comprar por categoría" Category Sliders -->
    <app-category-slider />

    <!-- Exclusive Offers Newsletter Subscription Banner -->
    <app-subscribe />
  `
})
export class HomePage {}
