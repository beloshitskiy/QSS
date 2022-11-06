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
  
  // for drawing chart
  @Published var chartPoints: [Point]
  
  // for statistics
  var acceptedRequests: Int
  var rejectedRequests: Int
  
  var inBufferTimes: [Double]
  var handlingTimes: [Double]
  
  public init() {
    remainingActions = 0
    lastActionTimestamp = 0
    circlePointer = 0
    rejectedRequests = 0
    acceptedRequests = 0
    inBufferTimes = [Double]()
    handlingTimes = [Double]()
    chartPoints = [Point(value: 0.0)]
  }
}
