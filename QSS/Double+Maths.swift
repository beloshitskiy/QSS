//
//  Double+Maths.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

extension Double {
  static func generateTimeForAction(withScalingRate rate: Double = 1.0) -> Double {
    log((1 - Double.random(in: 0.2 ..< 1)) / Double(-rate))
  }
}

extension [Double] {
  var average: Double {
    self.reduce(0, +) / Double(self.count)
  }
}
