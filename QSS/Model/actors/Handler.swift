//
//  Handler.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation

public class Handler {
  var y: Int
  
  // series
  
  public var isOccupied: Bool
  
  public var lastCheckedBufferNum: Int
  
  public var usageTime: Double
  
  public init(y: Int, i: Int) {
    self.y = y
    // series
    isOccupied = false
    lastCheckedBufferNum = 0
    usageTime = 0
  }
  
  func makeStep(_ x: Double) {
    // series.add(x, y);
  }
}
