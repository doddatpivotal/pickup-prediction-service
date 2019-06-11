package com.ridehailing.pickup.predict;

import io.micrometer.core.annotation.Timed;
import org.springframework.stereotype.Service;

import java.util.Random;


@Service
@Timed
public class TimeToPickUpPredictionService {

    private Random randomGen = new Random();
    private int PREDICTION_TIME_MS = 250;

    @Timed("prediction.time")
    public int predict() {
        return runPredictionAlgorithm();
    }

    public int runPredictionAlgorithm() {
        int delayInMilliseconds = 0;
        try {
            delayInMilliseconds = PREDICTION_TIME_MS + randomGen.nextInt(100);
            Thread.sleep(delayInMilliseconds);
        } catch (InterruptedException e) {
        }
        return delayInMilliseconds * 1000;
    }
}
