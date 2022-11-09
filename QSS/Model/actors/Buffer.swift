//
//  Buffer.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class Buffer: WaveformConvertible {
  public let id = UUID()
  
  public var currentGenerator: Generator?
  
  public var waitingFrom: Double
  public var isNewest: Bool
  
  public var isBusy: Bool { currentGenerator != nil }
  
  public init() {
    currentGenerator = nil
    isNewest = false
    waitingFrom = 0.0
  }
}
