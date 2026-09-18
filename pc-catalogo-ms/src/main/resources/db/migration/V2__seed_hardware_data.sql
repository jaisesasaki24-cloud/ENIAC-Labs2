INSERT INTO categorias_hardware (codigo, nombre, descripcion, activo) VALUES
('PROC', 'Procesadores Gaming', 'CPUs de alto rendimiento AMD Ryzen e Intel Core para gaming y productividad', true),
('GPU', 'Tarjetas Gráficas', 'GPUs dedicadas NVIDIA GeForce RTX y AMD Radeon con trazado de rayos', true),
('MBO', 'Placas Madre', 'Motherboards gaming chipsets B650, X670, Z790 con soporte PCIe 5.0 y DDR5', true),
('RAM', 'Memorias RAM', 'Módulos de memoria de alta velocidad DDR4 y DDR5 con iluminación RGB', true),
('SSD', 'Almacenamiento NVMe', 'Unidades de estado sólido M.2 PCIe Gen4 y Gen5 ultrarrápidas', true),
('PSU', 'Fuentes de Poder', 'Unidades de suministro de poder con certificación 80 Plus Gold y Platinum', true),
('COOL', 'Refrigeración Líquida', 'Sistemas AIO y disipadores de aire para overclocking seguro', true),
('CASE', 'Gabinetes Gamer', 'Gabinetes ATX de alto flujo de aire con paneles de vidrio templado', true);

INSERT INTO productos_hardware (sku, nombre, marca, modelo, precio, stock_actual, stock_minimo, garantia_meses, especificaciones, activo, categoria_id) VALUES
('AMD-7800X3D', 'AMD Ryzen 7 7800X3D 8 Cores 5.0GHz AM5', 'AMD', 'Ryzen 7 7800X3D', 1850.00, 15, 3, 36, '{"cores": 8, "threads": 16, "socket": "AM5", "tdp": "120W", "cache3d": "96MB"}', true, 1),
('INT-14700K', 'Intel Core i7-14700K 20 Cores LGA1700', 'Intel', 'Core i7-14700K', 1780.00, 10, 3, 36, '{"cores": 20, "threads": 28, "socket": "LGA1700", "boost": "5.6GHz"}', true, 1),
('NV-RTX4080S', 'ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB OC', 'ASUS ROG', 'RTX 4080 SUPER', 4699.00, 8, 2, 36, '{"vram": "16GB GDDR6X", "dlss": "3.5", "trazadoRayos": true}', true, 2),
('NV-RTX4070S', 'Gigabyte GeForce RTX 4070 SUPER Windforce 12GB', 'Gigabyte', 'RTX 4070 SUPER', 2899.00, 12, 3, 36, '{"vram": "12GB GDDR6X", "dlss": "3.5"}', true, 2),
('ASUS-B650E-F', 'ASUS ROG Strix B650E-F Gaming WiFi AM5', 'ASUS ROG', 'ROG STRIX B650E-F', 1250.00, 14, 4, 36, '{"chipset": "AMD B650E", "ram": "DDR5 6400+", "wifi": "WiFi 6E"}', true, 3),
('MSI-Z790-P', 'MSI PRO Z790-P WiFi DDR5 LGA1700', 'MSI', 'PRO Z790-P', 980.00, 10, 3, 24, '{"chipset": "Intel Z790", "ram": "DDR5 7200+", "pcie": "PCIe 5.0"}', true, 3),
('COR-DDR5-32G', 'Corsair Vengeance RGB 32GB (2x16GB) DDR5 6000MHz CL30', 'Corsair', 'Vengeance RGB DDR5', 540.00, 25, 5, 60, '{"capacidad": "32GB", "frecuencia": "6000MHz", "latencia": "CL30"}', true, 4),
('KIN-DDR5-32G', 'Kingston Fury Beast 32GB (2x16GB) DDR5 5600MHz Expo', 'Kingston', 'Fury Beast DDR5', 470.00, 20, 5, 60, '{"capacidad": "32GB", "frecuencia": "5600MHz"}', true, 4),
('SAM-990PRO-2TB', 'Samsung 990 PRO 2TB PCIe 4.0 NVMe M.2 con Heatsink', 'Samsung', '990 PRO 2TB', 790.00, 18, 4, 60, '{"lectura": "7450 MB/s", "escritura": "6900 MB/s"}', true, 5),
('KIN-NV2-1TB', 'Kingston NV2 1TB PCIe 4.0 NVMe M.2 SSD', 'Kingston', 'NV2 1TB', 280.00, 35, 8, 36, '{"lectura": "3500 MB/s", "escritura": "2100 MB/s"}', true, 5),
('SEA-850-GOLD', 'Seasonic Focus GX-850 850W 80+ Gold Full Modular ATX3.0', 'Seasonic', 'Focus GX-850', 650.00, 16, 4, 120, '{"potencia": "850W", "certificacion": "80+ Gold", "modular": true}', true, 6),
('NZXT-KRAKEN-360', 'NZXT Kraken 360 RGB Refrigeración Líquida Pantalla LCD', 'NZXT', 'Kraken 360 RGB', 1120.00, 9, 2, 72, '{"radiador": "360mm", "pantalla": "LCD 1.54 inch", "fans": 3}', true, 7),
('LIA-O11-DYNAMIC', 'Lian Li O11 Dynamic EVO RGB Gabinete Gamer Blanco', 'Lian Li', 'O11D EVO RGB', 799.00, 11, 3, 24, '{"tipo": "Mid-Tower", "vidrio": "Doble templado", "color": "Blanco"}', true, 8);