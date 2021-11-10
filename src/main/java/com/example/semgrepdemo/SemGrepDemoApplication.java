package com.example.semgrepdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@SpringBootApplication
@RestController
public class SemGrepDemoApplication {

    @RequestMapping("/")
    public String home() {
        risky();
        return "Hello Docker World";
    }

    private void risky() {
        try {
            MessageDigest instance = MessageDigest.getInstance("sha-1");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        SpringApplication.run(SemGrepDemoApplication.class, args);
    }

}
