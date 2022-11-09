//
//  Double+Maths.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

extension Double {
  static func generateTimeForAction(withScalingRate rate: Double = 1.0) -> Double {
    -log(1 - Double.random(in: 0.2 ..< 1))
  }
}

extension Int {
  static func generateTimeForAction() -> Int {
    Int.random(in: 1 ... 5)
  }
}

extension [Double] {
  var average: Double {
    guard !self.isEmpty else { return 0.0 }
    return self.reduce(0, +) / Double(self.count)
  }
}
