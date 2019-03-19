package com.ridehailing.pickup.predict;

import io.micrometer.core.annotation.Timed;
import org.springframework.stereotype.Service;

import java.util.Random;


@Service
@Timed
public class TimeToPickUpPredictionService {
    private Random randomGen = new Random();

    @Timed("prediction.time")
    public int predict() {
        return calculate();
    }

    public int calculate() {
        try {
            int millis = randomGen.nextInt(300);
            Thread.sleep(millis * 10);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return 50;
    }
}
