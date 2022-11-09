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
  
  public init() {
    isBusy = false
    usageTime = 0.0
  }
}
