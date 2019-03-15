package com.ridehailing.pickup.predict;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PredictionController {

  private final TimeToPickUpPredictor predictor;

  public PredictionController(TimeToPickUpPredictor calc) {
    this.predictor = calc;
  }

  @GetMapping("/predict")
  public TimeToPickUpPredictor.Borrow howMuch() {
      System.out.println("predictor = " + predictor);
      return predictor.predict();
  }




}