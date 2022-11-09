//
//  Rejector.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class Rejector: WaveformConvertible {
  public let id = UUID()

  let baseLine = 0.0
  @Published var chartData = [WaveformPoint]()

  func makeStep(_ step: ShortStep = .straight, stepWidth: Double, stepHeight: Double = 1.0) {
    let up = WaveformPoint(.rejector, .init(x: stepWidth, y: baseLine + stepHeight))
    let down = WaveformPoint(.rejector, .init(x: stepWidth, y: baseLine))
    
    guard let lastPoint = chartData.last else {
      chartData.append(down)
      return
    }
    
    let newPoint: WaveformPoint
    switch step {
      case .straight: newPoint = lastPoint.y == up.y ? up : down
      case .up: newPoint = up
      case .down: newPoint = down
    }
    
    chartData.append(newPoint)
  }
}
