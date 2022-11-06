//
//  BufferAction.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class BufferAction: Action {
  private let timestamp: Double
  
  override public func getTimestamp() -> Double { timestamp }
  
  private let buffer: Buffer
  
  private let generator: Generator
  
  private let performer: SimulationPerformer
  
  override public func doAction() -> Action? {
    if buffer.isBusy {
      buffer.currentGenerator = generator
      buffer.waitingFrom = timestamp
      buffer.makeStep(.up)
    } else {
      buffer.makeStep(.down)
//      buffer.makeStep(.up)

      let rejector = performer.rejector
      generator.rejectedRequests += 1
      generator.inBufferTimes.append(timestamp - buffer.waitingFrom)
      performer.rejectedRequestsCount += 1
      buffer.currentGenerator = generator
      buffer.waitingFrom = timestamp
      rejector.makeStep(.rejectorTick)
    }
    return nil
  }
  
  public init(_ timestamp: Double, _ buffer: Buffer, _ generator: Generator, _ performer: SimulationPerformer) {
    self.timestamp = timestamp
    self.buffer = buffer
    self.generator = generator
    self.performer = performer
    
    super.init()
  }
  
  // Comparable conformance
  public static func < (lhs: BufferAction, rhs: BufferAction) -> Bool {
    lhs.timestamp < rhs.timestamp
  }
  
  public static func == (lhs: BufferAction, rhs: BufferAction) -> Bool {
    lhs.timestamp == rhs.timestamp
  }
}
