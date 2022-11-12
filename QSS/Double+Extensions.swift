//
//  Double+Maths.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

// used for generating time with logarithmic distribution
extension Double {
  static func generateTimeForAction() -> Double {
    -log(1 - Double.random(in: 0.2 ..< 1))
  }
}

// used for convenient calculating of average value of elements
extension [Double] {
  var average: Double {
    guard !self.isEmpty else { return 0.0 }
    return self.reduce(0, +) / Double(self.count)
  }
}
