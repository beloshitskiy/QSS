//
//  BufferAction.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation

public class BufferAction: Action {
  private let timestamp: Double
  
  override public func getTimestamp() -> Double { timestamp }
  
  private let buffer: Buffer
  
  private let generator: Generator
  
  private let helper: ActionHelper
  
  override public func doAction() -> Action? {
    if buffer.currentGenerator == nil {
      buffer.currentGenerator = generator
      buffer.startedWaitingTime = timestamp
      buffer.y += 10
      buffer.makeStep(timestamp)
    } else {
      buffer.y -= 10
      buffer.makeStep(timestamp)
      buffer.y += 10
      buffer.makeStep(timestamp)
      
      let rejector = helper.rejector
      generator.rejectedRequests += 1
      generator.waitingTimes.append(timestamp - buffer.startedWaitingTime)
      helper.rejectedRequestsCount += 1
      buffer.currentGenerator = generator
      buffer.startedWaitingTime = timestamp
      rejector.y += 10
      rejector.makeStep(timestamp)
      rejector.y -= 10
      rejector.makeStep(timestamp)
    }
    return nil
  }
  
  public init(_ timestamp: Double, _ buffer: Buffer, _ generator: Generator, _ helper: ActionHelper) {
    self.timestamp = timestamp
    self.buffer = buffer
    self.generator = generator
    self.helper = helper
    
    super.init()
  }
  
  public static func < (lhs: BufferAction, rhs: BufferAction) -> Bool {
    lhs.timestamp < rhs.timestamp
  }
  
  public static func == (lhs: BufferAction, rhs: BufferAction) -> Bool {
    lhs.timestamp == rhs.timestamp
  }
}
