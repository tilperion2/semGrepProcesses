package com.example.semgrepdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.MessageDigest;

@SpringBootApplication
@RestController
public class SemGrepDemoApplication {

    @RequestMapping("/")
    public String home() {
        MessageDigest instance = MessageDigest.getInstance("sha-1");
        return "Hello Docker World";
    }

    public static void main(String[] args) {
        SpringApplication.run(SemGrepDemoApplication.class, args);
    }

}
