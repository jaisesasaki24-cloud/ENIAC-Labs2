import { Injectable, signal, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';

export interface ProductColor {
  name: string;
  hex: string;
  image: string;
  secondaryImage?: string;
}

export interface Product {
  id: string;
  name: string;
  category: 'phones' | 'tablets' | 'wearables' | 'choice' | 'laptops';
  series?: string;
  badge?: string;
  price: number;
  originalPrice?: number;
  description: string;
  colors: ProductColor[];
  buyUrl?: string;
  moreUrl?: string;
  specs?: string[];
}

@Injectable({
  providedIn: 'root'
})
export class CatalogService {
  selectedProductForBuy = signal<Product | null>(null);
  isQuickBuyOpen = signal<boolean>(false);
  isSearchOpen = signal<boolean>(false);
  isLoginModalOpen = signal<boolean>(false);

  readonly products: Product[] = [
    // 1. Tarjetas Gráficas y Procesadores (categoría principal con productos de prueba a S/ 5.00)
    {
      id: 'honor-600-pro',
      name: 'GeForce RTX 4080 Super OC 16GB',
      category: 'phones',
      series: 'n_series',
      badge: 'Oferta S/ 5',
      price: 5.00,
      originalPrice: 3499,
      description: 'Arquitectura Ada Lovelace, 16GB GDDR6X, Ray Tracing de 3ª generación y tecnología DLSS 3.5 con IA para gaming extremo.',
      colors: [
        {
          name: 'Edición Titanio OC',
          hex: '#e0d3be',
          image: '/images/gpu-rtx4080.jpg',
          secondaryImage: '/images/gpu-rtx4080.jpg'
        },
        {
          name: 'Edición Stealth Black',
          hex: '#000000',
          image: '/images/gpu-rtx4080.jpg',
          secondaryImage: '/images/gpu-rtx4080.jpg'
        }
      ],
      specs: ['16GB GDDR6X', 'DLSS 3.5 con IA', 'Triple Ventilador Axial', 'HDMI 2.1a + 3x DP 1.4a']
    },
    {
      id: 'honor-600',
      name: 'GeForce RTX 4070 Ti Super 16GB',
      category: 'phones',
      series: 'n_series',
      badge: 'Oferta S/ 5',
      price: 5.00,
      originalPrice: 2499,
      description: 'Potencia gráfica para gaming 1440p y 4K con 16GB de VRAM de alta velocidad y disipador térmico optimizado.',
      colors: [
        {
          name: 'Edición Gaming Cooper',
          hex: '#f2a93b',
          image: '/images/gpu-rtx4080.jpg'
        },
        {
          name: 'Edición White Platinum',
          hex: '#e0d3be',
          image: '/images/gpu-rtx4080.jpg'
        },
        {
          name: 'Edición Dark Knight',
          hex: '#000000',
          image: '/images/gpu-rtx4080.jpg'
        }
      ],
      specs: ['16GB GDDR6X 256-bit', '8448 Núcleos CUDA', 'Consumo 285W', 'Soporte G-SYNC']
    },
    {
      id: 'honor-600e',
      name: 'AMD Radeon RX 7800 XT 16GB',
      category: 'phones',
      series: 'n_series',
      badge: 'Oferta S/ 5',
      price: 5.00,
      originalPrice: 2199,
      description: 'Rendimiento imbatible en rasterizado con tecnología AMD RDNA 3, 16GB de memoria GDDR6 y FSR 3 FidelityFX.',
      colors: [
        {
          name: 'Edición Nitro Verde',
          hex: '#e7f1e9',
          image: '/images/gpu-rtx4080.jpg'
        },
        {
          name: 'Edición Pure Silver',
          hex: '#dec3b3',
          image: '/images/gpu-rtx4080.jpg'
        },
        {
          name: 'Edición Pulse Grey',
          hex: '#505358',
          image: '/images/gpu-rtx4080.jpg'
        }
      ],
      specs: ['16GB GDDR6', 'Arquitectura RDNA 3', 'AMD FSR 3 FidelityFX', 'DisplayPort 2.1']
    },
    {
      id: 'honor-600-smart',
      name: 'AMD Ryzen 7 7800X3D Gaming CPU',
      category: 'phones',
      series: 'n_series',
      badge: 'Nuevo',
      price: 1299,
      originalPrice: 1399,
      description: 'El procesador definitivo para gaming con arquitectura Zen 4, tecnología 3D V-Cache de 96MB y 8 núcleos de alto rendimiento.',
      colors: [
        {
          name: 'Edición Box AM5',
          hex: '#8e79b7',
          image: '/images/cpu-ryzen7.jpg',
          secondaryImage: '/images/cpu-ryzen7.jpg'
        }
      ],
      specs: ['8 Núcleos / 16 Hilos', 'Hasta 5.0 GHz Max Boost', '104MB Cache Total', 'Socket AM5 PCIe 5.0']
    },
    {
      id: 'honor-magic8-lite',
      name: 'GeForce RTX 4060 Ti Dual 8GB',
      category: 'phones',
      series: 'magic-series',
      badge: 'Más Vendido',
      price: 1599,
      originalPrice: 1799,
      description: 'Excelente eficiencia energética con arquitectura Ada Lovelace y DLSS 3 para jugar a 1080p y 1440p con alto framerate.',
      colors: [
        {
          name: 'Verde Militar',
          hex: '#747e72',
          image: '/images/gpu-rtx4080.jpg'
        },
        {
          name: 'Negro Mate',
          hex: '#000000',
          image: '/images/gpu-rtx4080.jpg'
        },
        {
          name: 'Blanco Nieve',
          hex: '#e5d1b6',
          image: '/images/gpu-rtx4080.jpg'
        }
      ],
      specs: ['8GB GDDR6 128-bit', 'DLSS 3 con Frame Generation', 'Bajo Consumo 160W', 'Formato Compacto']
    },
    {
      id: 'honor-magic8-pro',
      name: 'GeForce RTX 4090 Extreme 24GB',
      category: 'phones',
      series: 'magic-series',
      badge: 'Flagship',
      price: 4999,
      originalPrice: 5099,
      description: 'La tarjeta gráfica más potente para creadores de contenido 3D, IA y gamers extremos con 24GB VRAM y 16,384 núcleos CUDA.',
      colors: [
        {
          name: 'Negro ROG',
          hex: '#000000',
          image: '/images/gpu-rtx4080.jpg'
        },
        {
          name: 'Dorado Strix',
          hex: '#eae3d7',
          image: '/images/gpu-rtx4080.jpg'
        }
      ],
      specs: ['24GB GDDR6X 384-bit', '16384 CUDA Cores', '4K/8K Gaming Nativo', 'Disipador Vapor Chamber']
    },
    {
      id: 'honor-x8d',
      name: 'AMD Ryzen 5 7600X 6-Core AM5',
      category: 'phones',
      series: 'x_series',
      badge: 'Oferta',
      price: 1099,
      originalPrice: 1149,
      description: 'Procesador veloz para gaming competitivo con arquitectura Zen 4 y frecuencias de hasta 5.3 GHz.',
      colors: [
        {
          name: 'Azul Glaciar',
          hex: '#cedce8',
          image: '/images/cpu-ryzen7.jpg'
        },
        {
          name: 'Negro Grafito',
          hex: '#000000',
          image: '/images/cpu-ryzen7.jpg'
        },
        {
          name: 'Plata Titanio',
          hex: '#cccccc',
          image: '/images/cpu-ryzen7.jpg'
        }
      ],
      specs: ['6 Núcleos / 12 Hilos', 'Hasta 5.3 GHz Boost', 'Soporta DDR5 y PCIe 5.0', 'TDP 105W']
    },
    {
      id: 'honor-x7e',
      name: 'Intel Core i5 14600KF 14-Core',
      category: 'phones',
      series: 'x_series',
      badge: 'Nuevo',
      price: 949,
      originalPrice: 1099,
      description: 'Excelente balance precio-rendimiento con 14 núcleos híbridos (6P + 8E) y overclock desbloqueado.',
      colors: [
        {
          name: 'Cobre Gaming',
          hex: '#fead75',
          image: '/images/cpu-ryzen7.jpg'
        },
        {
          name: 'Azul Intel',
          hex: '#d8ecfa',
          image: '/images/cpu-ryzen7.jpg'
        },
        {
          name: 'Negro Box',
          hex: '#000000',
          image: '/images/cpu-ryzen7.jpg'
        }
      ],
      specs: ['14 Núcleos (6P + 8E) / 20 Hilos', 'Hasta 5.3 GHz Max Turbo', 'Socket LGA1700', 'Compatible DDR4/DDR5']
    },
    {
      id: 'honor-x6e',
      name: 'AMD Ryzen 5 5600X 6-Core AM4',
      category: 'phones',
      series: 'x_series',
      badge: 'Nuevo',
      price: 799,
      originalPrice: 899,
      description: 'El procesador más popular para armar setups económicos y rendidores con bajo consumo térmico de 65W.',
      colors: [
        {
          name: 'Dorado Champaña',
          hex: '#eae3d7',
          image: '/images/cpu-ryzen7.jpg'
        },
        {
          name: 'Negro Carbón',
          hex: '#000000',
          image: '/images/cpu-ryzen7.jpg'
        }
      ],
      specs: ['6 Núcleos / 12 Hilos', 'Hasta 4.6 GHz Boost', 'Socket AM4', 'TDP ultra bajo 65W']
    },

    // 2. Placas Madre y Memorias RAM (categoría tablets)
    {
      id: 'honor-pad-10',
      name: 'ASUS ROG Strix Z790-E Gaming WiFi II',
      category: 'tablets',
      series: 'honor-pad-n-series',
      badge: 'Top Venta',
      price: 1799,
      originalPrice: 1999,
      description: 'Placa madre Intel Z790 con 18+1 fases de poder, PCIe 5.0 para GPU y M.2, Wi-Fi 7 y audio SupremeFX.',
      colors: [
        {
          name: 'Gris ROG Armor',
          hex: '#717276',
          image: '/images/mobo-rog.jpg'
        }
      ],
      specs: ['Socket LGA1700 Gen 14/13', 'Soporte DDR5 hasta 8000+ MHz', 'Slot PCIe 5.0 x16', 'Wi-Fi 7 + 2.5G LAN']
    },
    {
      id: 'honor-pad-x9b-max',
      name: 'MSI MAG B650 Tomahawk WiFi AM5',
      category: 'tablets',
      series: 'honor-pad-x-series',
      badge: 'Nuevo',
      price: 1699,
      originalPrice: 1999,
      description: 'Construcción militar duradera para procesadores AMD Ryzen 7000/8000/9000 con slots M.2 blindados.',
      colors: [
        {
          name: 'Negro Militar',
          hex: '#717276',
          image: '/images/mobo-rog.jpg'
        }
      ],
      specs: ['Socket AM5 DDR5', '14+2+1 Duet Rail VRM', '3x Slots M.2 Shield Frozr', 'Wi-Fi 6E + Bluetooth 5.3']
    },
    {
      id: 'honor-pad-x8b',
      name: 'Gigabyte B760M AORUS Elite AX',
      category: 'tablets',
      series: 'honor-pad-x-series',
      price: 729,
      originalPrice: 799,
      description: 'Placa madre formato Micro-ATX compacta para Intel Gen 14/13 con conectividad inalámbrica y disipador térmico.',
      colors: [
        {
          name: 'Plata Aorus',
          hex: '#bebab7',
          image: '/images/mobo-rog.jpg'
        }
      ],
      specs: ['Formato Micro-ATX', '4x Slots DDR5', '2x PCIe 4.0 M.2', 'Antena Wi-Fi 6E incluida']
    },
    {
      id: 'honor-pad-x9a-lte',
      name: 'Corsair Vengeance RGB 64GB DDR5 6000MHz',
      category: 'tablets',
      series: 'honor-pad-x-series',
      price: 1199,
      originalPrice: 1299,
      description: 'Kit de 64GB (2x32GB) con iluminación dinámica RGB de diez zonas y perfil XMP 3.0 / AMD EXPO.',
      colors: [
        {
          name: 'Gris Grafito',
          hex: '#717276',
          image: '/images/ram-ddr5.jpg'
        }
      ],
      specs: ['Capacidad 64GB (2x32GB)', 'Velocidad 6000 MT/s CL30', 'Iluminación iCUE RGB', 'Perfil Intel XMP y AMD EXPO']
    },
    {
      id: 'honor-pad-x9a-wifi',
      name: 'Kingston Fury Beast RGB 32GB DDR5 5600MHz',
      category: 'tablets',
      series: 'honor-pad-x-series',
      price: 999,
      description: 'Kit de memoria RAM de 32GB (2x16GB) con sincronización infrarroja patentada y disipador negro agresivo.',
      colors: [
        {
          name: 'Negro Beast',
          hex: '#717276',
          image: '/images/ram-ddr5.jpg'
        }
      ],
      specs: ['Capacidad 32GB (2x16GB)', 'Velocidad 5600 MHz', 'Certificación Plug N Play', 'Garantía de por vida']
    },
    {
      id: 'honor-pad-x7-wifi',
      name: 'TeamGroup T-Force Delta RGB 32GB DDR5',
      category: 'tablets',
      series: 'honor-pad-x-series',
      price: 469,
      originalPrice: 499,
      description: 'Memoria RAM gamer de alto rendimiento con difusor de luz translúcido de 120° gran angular.',
      colors: [
        {
          name: 'Gris Titanio',
          hex: '#717276',
          image: '/images/ram-ddr5.jpg'
        }
      ],
      specs: ['Capacidad 32GB (2x16GB)', 'Velocidad 5200 MHz', 'On-Die ECC para estabilidad', 'Iluminación RGB Aura Sync']
    },

    // 3. Almacenamiento SSD y Refrigeración (categoría wearables)
    {
      id: 'honor-watch-6',
      name: 'Samsung 990 PRO 2TB NVMe PCIe 4.0 M.2',
      category: 'wearables',
      series: 'honor-watch',
      badge: 'Nuevo',
      price: 799,
      description: 'El SSD NVMe más rápido con velocidades de lectura secuencial de hasta 7450 MB/s y disipador térmico de aluminio.',
      colors: [
        {
          name: 'Negro Heatsink',
          hex: '#000000',
          image: '/images/ssd-nvme.jpg'
        },
        {
          name: 'Gris Standar',
          hex: '#7b5944',
          image: '/images/ssd-nvme.jpg'
        }
      ],
      specs: ['Lectura hasta 7,450 MB/s', 'Escritura hasta 6,900 MB/s', 'Memoria V-NAND TLC', 'Compatible con PS5 y PC']
    },
    {
      id: 'honor-choice-watch-2-pro',
      name: 'Kingston KC3000 2TB PCIe 4.0 NVMe SSD',
      category: 'wearables',
      series: 'honor-watch',
      price: 289,
      originalPrice: 299,
      description: 'Unidad de estado sólido de alta velocidad con controlador Phison E18 y lámina de grafeno térmico.',
      colors: [
        {
          name: 'Negro',
          hex: '#000000',
          image: '/images/ssd-nvme.jpg'
        },
        {
          name: 'Plata',
          hex: '#ffffff',
          image: '/images/ssd-nvme.jpg'
        }
      ],
      specs: ['Velocidad 7000 MB/s', 'Capacidad 2048GB', 'Formato M.2 2280', 'Garantía 5 años']
    },
    {
      id: 'honor-earbuds-a-pro',
      name: 'Corsair iCUE H150i Elite Liquid 360mm',
      category: 'wearables',
      series: 'audio',
      price: 549,
      originalPrice: 629,
      description: 'Refrigeración líquida todo en uno con radiador de 360mm, 3 ventiladores AF120 RGB y bomba de alto flujo silenciosa.',
      colors: [
        {
          name: 'Blanco Ártico',
          hex: '#f8f8f8',
          image: '/images/aio-cooler.jpg'
        },
        {
          name: 'Negro Mate',
          hex: '#000000',
          image: '/images/aio-cooler.jpg'
        }
      ],
      specs: ['Radiador de 360mm', 'Bomba ultrasilenciosa', 'Ventiladores PWM hasta 2100 RPM', 'Control iCUE Commander']
    },
    {
      id: 'honor-choice-cubuds',
      name: 'NZXT Kraken Elite 360 RGB Cooler',
      category: 'wearables',
      series: 'audio',
      price: 649,
      originalPrice: 699,
      description: 'Refrigeración líquida premium con pantalla LCD personalizable para monitorear temperaturas de CPU/GPU y GIFs.',
      colors: [
        {
          name: 'Negro RGB',
          hex: '#000000',
          image: '/images/aio-cooler.jpg'
        }
      ],
      specs: ['Pantalla LCD 2.36" 60Hz', 'Bomba Asetek Gen 7', 'Ventiladores estáticos F120', 'Software NZXT CAM']
    },
    {
      id: 'honor-choice-watch-2i',
      name: 'Crucial T700 1TB PCIe 5.0 NVMe SSD',
      category: 'wearables',
      series: 'honor-watch',
      price: 539,
      originalPrice: 599,
      description: 'La nueva generación PCIe Gen5 con transferencias supersónicas de hasta 11,700 MB/s para cargas instantáneas.',
      colors: [
        {
          name: 'Negro con Disipador',
          hex: '#000000',
          image: '/images/ssd-nvme.jpg'
        }
      ],
      specs: ['PCIe 5.0 x4 de última generación', 'Lecturas 11700 MB/s', 'Micron 232-Layer TLC NAND', 'Disipador pasivo de aluminio']
    },
    {
      id: 'honor-choice-earbuds-clip',
      name: 'DeepCool LT720 Liquid Cooler 360mm',
      category: 'wearables',
      series: 'audio',
      price: 479,
      originalPrice: 499,
      description: 'Diseño geométrico de espejo infinito multidimensional con bomba de 4ª generación de alta disipación.',
      colors: [
        {
          name: 'Negro Espejo',
          hex: '#000000',
          image: '/images/aio-cooler.jpg'
        }
      ],
      specs: ['Bomba de 4ª generación 3100 RPM', 'Radiador de aluminio 360mm', 'Tubos reforzados con malla', 'TDP soportado hasta 300W']
    },

    // 4. Fuentes de Poder y Gabinetes (categoría choice)
    {
      id: 'honor-choice-speaker-pro',
      name: 'Fuente Corsair RM1000x 1000W 80 Plus Gold',
      category: 'choice',
      badge: 'Popular',
      price: 799,
      originalPrice: 850,
      description: 'Fuente de poder 100% modular con condensadores 105°C 100% japoneses y ventilador de levitación magnética.',
      colors: [
        {
          name: 'Negro Modular',
          hex: '#363636',
          image: '/images/psu-1000w.jpg'
        }
      ],
      specs: ['Potencia 1000 Watts', 'Certificación 80 PLUS Gold', 'Cableado 100% Modular', '10 Años de Garantía']
    },
    {
      id: 'honor-choice-hair-dryer-pro',
      name: 'Gabinete Lian Li O11 Dynamic EVO RGB',
      category: 'choice',
      price: 689,
      originalPrice: 749,
      description: 'Chasis gamer premium con paneles de cristal templado dual, soporte para radiadores triples y modo invertido.',
      colors: [
        {
          name: 'Blanco Nieve',
          hex: '#ffffff',
          image: '/images/hero-pc-rig.jpg'
        },
        {
          name: 'Negro Titanio',
          hex: '#000000',
          image: '/images/hero-pc-rig.jpg'
        }
      ],
      specs: ['Panel frontal y lateral de vidrio', 'Tiras de luz ARGB difusas', 'Doble cámara para cables', 'Soporte hasta 3x radiadores 360']
    }
  ];

  openQuickBuy(product: Product) {
    this.selectedProductForBuy.set(product);
    this.isQuickBuyOpen.set(true);
  }

  closeQuickBuy() {
    this.isQuickBuyOpen.set(false);
  }

  openSearch() {
    this.isSearchOpen.set(true);
  }

  closeSearch() {
    this.isSearchOpen.set(false);
  }

  openLoginModal() {
    this.isLoginModalOpen.set(true);
  }

  closeLoginModal() {
    this.isLoginModalOpen.set(false);
  }

  private http = inject(HttpClient);

  readonly backendProducts = signal<any[]>([]);
  readonly backendCategorias = signal<any[]>([]);
  readonly backendLoaded = signal<boolean>(false);

  getProductosBackend() {
    return this.http.get<any[]>(`${environment.apiBaseUrl}/api/v1/productos`);
  }

  getCategoriasBackend() {
    return this.http.get<any[]>(`${environment.apiBaseUrl}/api/v1/categorias`);
  }

  loadBackendCatalog() {
    this.getProductosBackend().subscribe({
      next: (prods) => {
        this.backendProducts.set(prods || []);
        this.backendLoaded.set(true);
        console.log(`[ENIAC Distributed System] ${prods?.length || 0} productos cargados desde pc-catalogo-ms (PostgreSQL) vía Gateway :18080`);
      },
      error: (err) => console.warn('[ENIAC Distributed System] Warning loading productos:', err)
    });

    this.getCategoriasBackend().subscribe({
      next: (cats) => {
        this.backendCategorias.set(cats || []);
        console.log(`[ENIAC Distributed System] ${cats?.length || 0} categorías cargadas desde Gateway :18080`);
      },
      error: (err) => console.warn('[ENIAC Distributed System] Warning loading categorias:', err)
    });
  }

  getProductById(id: string): Product | undefined {
    const found = this.products.find(p => p.id === id || p.id.toLowerCase() === id.toLowerCase());
    return found || this.products[0];
  }
}
