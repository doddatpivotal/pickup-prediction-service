package com.ridehailing.pickup.predict;

import io.micrometer.core.annotation.Timed;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Timed
public class PredictionController {

  private final TimeToPickUpPredictionService predictionService;

  public PredictionController(TimeToPickUpPredictionService predictionService) {
    this.predictionService = predictionService;
  }

  @GetMapping("/predict")
  public TimeToPickUp howLongToPickUp() {
      int seconds = predictionService.predict();
      return new TimeToPickUp(seconds);
  }


   static class TimeToPickUp {
        private final int seconds;

        public TimeToPickUp(int seconds) {
            this.seconds = seconds;
        }

       public int getSeconds() {
           return seconds;
       }
   }
}