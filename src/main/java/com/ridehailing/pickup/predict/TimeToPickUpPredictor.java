package com.ridehailing.pickup.predict;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
public class TimeToPickUpPredictor {
  private Timer timer;

  public TimeToPickUpPredictor(MeterRegistry meterRegistry) {
    this.timer = Timer
            .builder("prediction.time")
            .publishPercentileHistogram(true)
            .description("a description of what this timer does") // optional
            .register(meterRegistry);

  }

  public Borrow predict() {
    return timer.record(() -> calculate());
  }

  public Borrow calculate() {
    Random r = new Random();
    try {
      int millis = r.nextInt(5);
      int seconds = millis * 10;
      Thread.sleep(millis);
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    return new Borrow(r.nextInt(10000));
  }

  static class Borrow {
    private Integer dollars;

    public Borrow(Integer dollars) {
      this.dollars = dollars;
    }

    public Integer getDollars() {
      return dollars;
    }
  }
}
