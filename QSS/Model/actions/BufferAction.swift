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
    if !buffer.isBusy {
      buffer.currentGenerator = generator
      buffer.waitingFrom = timestamp
//      buffer.makeStep(performer, actor: .buffer, .up, stepWidth: timestamp)
      buffer.makeStep(.up, stepWidth: timestamp)
      buffer.makeStep(stepWidth: timestamp)
    } else {
      buffer.makeStep(.down, stepWidth: timestamp)
      buffer.makeStep(stepWidth: timestamp)
      buffer.makeStep(.up, stepWidth: timestamp)
      buffer.makeStep(stepWidth: timestamp)
      
      let rejector = performer.rejector
      generator.rejectedRequests += 1
      rejector.makeStep(.up, stepWidth: timestamp)
      rejector.makeStep(stepWidth: timestamp)
      rejector.makeStep(.down, stepWidth: timestamp)
      rejector.makeStep(stepWidth: timestamp)
      
      generator.inBufferTimes.append(timestamp - buffer.waitingFrom)
      
      buffer.currentGenerator = generator
      buffer.waitingFrom = timestamp
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
