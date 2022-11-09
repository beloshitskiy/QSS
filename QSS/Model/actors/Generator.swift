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
  
  public init() {
    remainingActions = 0
    lastActionTimestamp = 0.0
    circlePointer = 0
    rejectedRequests = 0
    acceptedOrders = 0
    inBufferTimes = [Double]()
    handlingTimes = [Double]()
  }
}
