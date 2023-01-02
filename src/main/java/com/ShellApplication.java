package com;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.util.Map;

@SpringBootApplication
public class ShellApplication {

    public static void main(String[] args) {
        Map<String, String> settings = System.getenv();
        settings.getOrDefault("APP_PORT", "8012");
        settings.getOrDefault("APP_NAME", "SpringBootWebshell");
        settings.getOrDefault("APP_ENV", "local");
        SpringApplication app = new SpringApplication(ShellApplication.class);
        app.setDefaultProperties(Collections
          .singletonMap("server.port", settings.getOrDefault("APP_PORT", "8012")));
        app.run(args);
        //SpringApplication.run(ShellApplication.class,args);
    }
}
