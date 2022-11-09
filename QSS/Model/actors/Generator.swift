//
//  Generator.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class Generator: WaveformConvertible {
  public let id = UUID()
  
  var remainingActions: Int
  var lastActionTimestamp: Double
  
  var circlePointer: Int
  
  var isEmpty: Bool { remainingActions == 0 }
  
  // for statistics
  var acceptedOrders: Int
  var rejectedRequests: Int
  
  var inBufferTimes: [Double]
  var handlingTimes: [Double]
  
  let baseLine: Double
  
  @Published var chartData: [WaveformPoint]
  
  func makeStep(_ step: ShortStep = .straight, stepWidth: Double, stepHeight: Double = 1.0) {
    let up = WaveformPoint(.generator, .init(x: stepWidth, y: baseLine + stepHeight))
    let down = WaveformPoint(.generator, .init(x: stepWidth, y: baseLine))
    
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
    remainingActions = 0
    lastActionTimestamp = 0.0
    circlePointer = 0
    rejectedRequests = 0
    acceptedOrders = 0
    inBufferTimes = []
    handlingTimes = []
    self.baseLine = baseLine
    chartData = []
  }
}
