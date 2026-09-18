package pe.edu.upeu.eniaclabs.cotizacion;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class PcCotizacionApplication {

    public static void main(String[] args) {
        SpringApplication.run(PcCotizacionApplication.class, args);
    }
}