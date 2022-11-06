//
//  HandlerAction.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class HandlerAction: Action {
  private let timestamp: Double
  
  override public func getTimestamp() -> Double { timestamp }
  
  private let handler: Handler
  private let generator: Generator
  private let performer: SimulationPerformer
  
  override public func doAction() -> Action? {
    handler.isBusy = false
    handler.chartHeight -= 10
    handler.makeStep(timestamp)
    if let buffer = optFreeBuffer {
      handler.isBusy = true
      handler.chartHeight += 10
      handler.makeStep(timestamp)
      if let generator = buffer.currentGenerator {
        buffer.currentGenerator = nil
        buffer.chartHeight -= 10
        buffer.makeStep(timestamp)
        let time = timestamp + Double.generateTimeForAction()
        handler.usageTime = handler.usageTime + time - timestamp
        generator.acceptedRequests += 1
        generator.inBufferTimes.append(timestamp - buffer.waitingFrom)
        generator.handlingTimes.append(time - timestamp)
        return HandlerAction(time, handler, generator, performer)
      }
    }
    
    return nil
  }
  
  private var optFreeBuffer: Buffer? {
    guard !performer.buffers.allSatisfy({ $0.isBusy }) else { return nil }
  
    for buf in performer.buffers where !buf.isBusy {
      return buf
    }
  
    return nil
  }
  
  public init(_ timestamp: Double, _ handler: Handler, _ generator: Generator, _ helper: SimulationPerformer) {
    self.timestamp = timestamp
    self.handler = handler
    self.generator = generator
    self.performer = helper
    
    super.init()
  }
  
  // Comparable conformance
  public static func < (lhs: HandlerAction, rhs: HandlerAction) -> Bool {
    lhs.timestamp < rhs.timestamp
  }

  public static func == (lhs: HandlerAction, rhs: HandlerAction) -> Bool {
    lhs.timestamp == rhs.timestamp
  }
}
