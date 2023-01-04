package com;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.util.Map;
import java.util.Properties;

@SpringBootApplication
public class ShellApplication {

    public static void main(String[] args) {
        Map<String, String> settings = System.getenv();
        settings.getOrDefault("APP_PORT", "8012");
        settings.getOrDefault("APP_NAME", "SpringBootWebshell");
        settings.getOrDefault("APP_ENV", "local");
        System.out.println("APP_PORT: "+ settings.getOrDefault("APP_PORT", "8012"));
        SpringApplication app = new SpringApplication(ShellApplication.class);
        Properties properties = new Properties();
        properties.put("server.port", Integer.parseInt(settings.getOrDefault("APP_PORT", "8012")));
        properties.put("server.contextPath", "/"+settings.getOrDefault("APP_NAME", "SpringBootWebshell"));
        app.setDefaultProperties(properties);
        app.run(args);
        //SpringApplication.run(ShellApplication.class,args);
    }
}
