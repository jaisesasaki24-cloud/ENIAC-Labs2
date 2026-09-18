package pe.edu.upeu.eniaclabs.catalogo.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import pe.edu.upeu.eniaclabs.catalogo.entity.CategoriaHardware;
import pe.edu.upeu.eniaclabs.catalogo.entity.ProductoHardware;
import pe.edu.upeu.eniaclabs.catalogo.repository.CategoriaHardwareRepository;
import pe.edu.upeu.eniaclabs.catalogo.repository.ProductoHardwareRepository;

import java.math.BigDecimal;
import java.util.List;

@Component
@RequiredArgsConstructor
public class CatalogoDataInitializer implements CommandLineRunner {

    private final CategoriaHardwareRepository categoriaRepository;
    private final ProductoHardwareRepository productoRepository;

    @Override
    public void run(String... args) {
        if (categoriaRepository.count() > 0) {
            return;
        }

        CategoriaHardware proc = CategoriaHardware.builder()
                .codigo("PROC").nombre("Procesadores Gaming")
                .descripcion("CPUs de alto rendimiento AMD Ryzen e Intel Core").activo(true).build();
        CategoriaHardware gpu = CategoriaHardware.builder()
                .codigo("GPU").nombre("Tarjetas GrÃ¡ficas")
                .descripcion("GPUs NVIDIA GeForce RTX y AMD Radeon con Ray Tracing").activo(true).build();
        CategoriaHardware mbo = CategoriaHardware.builder()
                .codigo("MBO").nombre("Placas Madre")
                .descripcion("Motherboards chipsets B650, X670, Z790").activo(true).build();
        CategoriaHardware ram = CategoriaHardware.builder()
                .codigo("RAM").nombre("Memorias RAM")
                .descripcion("MÃ³dulos DDR5 de alta velocidad con RGB").activo(true).build();
        CategoriaHardware ssd = CategoriaHardware.builder()
                .codigo("SSD").nombre("Almacenamiento NVMe")
                .descripcion("SSDs M.2 PCIe Gen4 y Gen5 ultrarrÃ¡pidos").activo(true).build();

        categoriaRepository.saveAll(List.of(proc, gpu, mbo, ram, ssd));

        ProductoHardware p1 = ProductoHardware.builder()
                .sku("AMD-7800X3D").nombre("AMD Ryzen 7 7800X3D 8 Cores 5.0GHz AM5")
                .marca("AMD").modelo("Ryzen 7 7800X3D").precio(new BigDecimal("1850.00"))
                .stockActual(15).stockMinimo(3).garantiaMeses(36)
                .especificaciones("{\"cores\": 8, \"threads\": 16, \"cache3d\": \"96MB\"}").activo(true)
                .categoria(proc).build();

        ProductoHardware p2 = ProductoHardware.builder()
                .sku("INT-14700K").nombre("Intel Core i7-14700K 20 Cores LGA1700")
                .marca("Intel").modelo("Core i7-14700K").precio(new BigDecimal("1780.00"))
                .stockActual(10).stockMinimo(3).garantiaMeses(36)
                .especificaciones("{\"cores\": 20, \"threads\": 28, \"boost\": \"5.6GHz\"}").activo(true)
                .categoria(proc).build();

        ProductoHardware p3 = ProductoHardware.builder()
                .sku("NV-RTX4080S").nombre("ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB OC")
                .marca("ASUS ROG").modelo("RTX 4080 SUPER").precio(new BigDecimal("4699.00"))
                .stockActual(8).stockMinimo(2).garantiaMeses(36)
                .especificaciones("{\"vram\": \"16GB GDDR6X\", \"dlss\": \"3.5\"}").activo(true)
                .categoria(gpu).build();

        ProductoHardware p4 = ProductoHardware.builder()
                .sku("COR-DDR5-32G").nombre("Corsair Vengeance RGB 32GB (2x16GB) DDR5 6000MHz")
                .marca("Corsair").modelo("Vengeance RGB").precio(new BigDecimal("540.00"))
                .stockActual(25).stockMinimo(5).garantiaMeses(60)
                .especificaciones("{\"capacidad\": \"32GB\", \"frecuencia\": \"6000MHz\"}").activo(true)
                .categoria(ram).build();

        ProductoHardware p5 = ProductoHardware.builder()
                .sku("SAM-990PRO-2TB").nombre("Samsung 990 PRO 2TB PCIe 4.0 NVMe M.2")
                .marca("Samsung").modelo("990 PRO 2TB").precio(new BigDecimal("790.00"))
                .stockActual(18).stockMinimo(4).garantiaMeses(60)
                .especificaciones("{\"lectura\": \"7450 MB/s\", \"escritura\": \"6900 MB/s\"}").activo(true)
                .categoria(ssd).build();

        productoRepository.saveAll(List.of(p1, p2, p3, p4, p5));
    }
}