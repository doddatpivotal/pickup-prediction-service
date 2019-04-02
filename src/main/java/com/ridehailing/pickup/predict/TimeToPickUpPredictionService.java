package com.ridehailing.pickup.predict;

import io.micrometer.core.annotation.Timed;
import org.springframework.stereotype.Service;

import java.util.Random;


@Service
@Timed
public class TimeToPickUpPredictionService {
    private Random randomGen = new Random();
    private int FIXED_DELAY_MS = 500;

    @Timed("prediction.time")
    public int predict() {
        return runPrediction();
    }

    public int runPrediction() {
        int delayInMilliseconds = 0;
        try {
            delayInMilliseconds = FIXED_DELAY_MS + randomGen.nextInt(100);
            Thread.sleep(delayInMilliseconds);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return delayInMilliseconds * 1000;
    }
}
