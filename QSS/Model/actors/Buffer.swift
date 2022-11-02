//
//  Buffer.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation

public class Buffer {
  
  var y: Double
  
  // series
  
  public var currentGenerator: Generator?
  
  public var startedWaitingTime: Double
  public var isNewest: Bool
  
  public var isBusy: Bool { currentGenerator != nil }
  
  public init(y: Double, i: Int) {
    self.y = y
    currentGenerator = nil
    isNewest = false
    startedWaitingTime = 0
  }
  
  public func makeStep(_ x: Double) {
    // series.add(x, y) // add point to series
  }
  
}


