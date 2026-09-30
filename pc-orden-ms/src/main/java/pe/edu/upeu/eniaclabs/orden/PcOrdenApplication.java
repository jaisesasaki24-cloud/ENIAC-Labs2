package pe.edu.upeu.eniaclabs.orden;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableFeignClients
public class PcOrdenApplication {

    public static void main(String[] args) {
        SpringApplication.run(PcOrdenApplication.class, args);
    }
}