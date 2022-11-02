//
//  Generator.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation

public class Generator {
  var y: Double
  
  // series
  
  var amountOfActions: Int
  var rejectedRequests: Int
  var acceptedRequests: Int
  var lastActionTimestamp: Double
  var lastCheckedHandlerNum: Int
  
  var waitingTimes: [Double]
  var handlingTimes: [Double]
  
  public init(y: Double, i: Int) {
    self.y = y
    // series
    amountOfActions = 0
    lastActionTimestamp = 0
    lastCheckedHandlerNum = 0
    rejectedRequests = 0
    acceptedRequests = 0
    waitingTimes = [Double]()
    handlingTimes = [Double]()
  }
  
  func makeStep(_ x: Double) {
    // series.add(x, y);
  }
  
  var isActionless: Bool { amountOfActions == 0 }
}
