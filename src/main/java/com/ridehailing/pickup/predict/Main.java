package com.ridehailing.pickup.predict;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Main {
  public static void main(String[] args) {
    SpringApplication.run(Main.class, args);
  }

//  @Bean
//  LoggingMeterRegistry loggingMeterRegistry() {
//    return new LoggingMeterRegistry(new LoggingRegistryConfig() {
//      @Override
//      public String get(String key) {
//        return null;
//      }
//
//      @Override
//      public Duration step() {
//        return Duration.ofSeconds(2);
//      }
//    }, Clock.SYSTEM);
//  }


}
