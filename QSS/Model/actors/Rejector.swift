//
//  Rejector.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class Rejector: WaveformConvertible {
  public let id = UUID()
  
  // for drawing chart
  @Published var chartPoints: [Point]

  public init() {
    chartPoints = [Point(value: 0.0)]
  }
}
