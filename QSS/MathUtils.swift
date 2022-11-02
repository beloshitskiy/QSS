//
//  MathUtils.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation

public class MathUtils {
  static let scalingRate = 1
  static var random: Double {
    Double.random(in: 0.2 ..< 1)
  }
  
  static func generateTimeForAction() -> Double {
    log((1 - random) / Double(-scalingRate))
  }
  
  static func getN(for p: Double) {
    round((pow(1.643, 2) * (1 - p)) / (p * 0.01))
  }
  
  static func getAverage(arr: [Double], requests: Double) -> Double {
    arr.reduce(0, +) / requests
  }
  
  static func getDispersion(arr: [Double]) -> Double {
    guard let max = arr.max(), let min = arr.min() else { return 0 }
    return abs(max - min)
  }
}
