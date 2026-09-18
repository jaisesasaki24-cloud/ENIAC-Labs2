package pe.edu.upeu.eniaclabs.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class PcEurekaApplication {

    public static void main(String[] args) {
        SpringApplication.run(PcEurekaApplication.class, args);
    }
}