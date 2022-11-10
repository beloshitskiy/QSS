//
//  Handler.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class Handler: WaveformConvertible {
  public let id = UUID()
  
  public var isBusy: Bool
  
  public var usageTime: Double
  
  let baseLine: Double
  
  @Published var chartData: [WaveformPoint]
  
  func makeStep(_ step: Step = .straight, stepWidth: Double, stepHeight: Double = 1.0) {
    let up = WaveformPoint(.handler, .init(x: stepWidth, y: baseLine + stepHeight))
    let down = WaveformPoint(.handler, .init(x: stepWidth, y: baseLine))
    
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
  
  public init(baseLine: Double) {
    isBusy = false
    usageTime = 0.0
    self.baseLine = baseLine
    chartData = []
  }
}
