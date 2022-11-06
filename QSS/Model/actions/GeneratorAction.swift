//
//  GeneratorAction.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class GeneratorAction: Action {
  private let timestamp: Double
  
  override public func getTimestamp() -> Double { timestamp }
  
  private let generator: Generator
  
  private let performer: SimulationPerformer
  
  override public func doAction() -> Action? {
    generator.remainingActions -= 1
    generator.makeStep(.tick)

    if let handler = optHandler {
      handler.isBusy = true
      handler.makeStep(.up)

      let time = timestamp + Double.generateTimeForAction()
      handler.usageTime = handler.usageTime + time - timestamp
      generator.acceptedOrders += 1
      generator.handlingTimes.append(time - timestamp)
      
      return HandlerAction(time, handler, generator, performer)
    }
    
    
    if let buffer = optFreeBuffer {
      return BufferAction(timestamp, buffer, generator, performer)
    }
    
    return nil
  }
  
  public init(_ timestamp: Double, _ generator: Generator, _ helper: SimulationPerformer) {
    self.timestamp = timestamp
    self.generator = generator
    self.performer = helper
    
    super.init()
  }
  
  private var optFreeBuffer: Buffer? {
    guard !performer.buffers.allSatisfy({ $0.isBusy }) else {
      return nil
    }

    for buf in performer.buffers where !buf.isBusy {
      return buf
    }

    return nil
  }
  
  // choosing handler for order
  private var optHandler: Handler? {
    let handlers = performer.handlers
    guard !handlers.allSatisfy({ $0.isBusy }) else { return nil }
  
    for i in generator.circlePointer ..< handlers.count where !handlers[i].isBusy {
      generator.circlePointer = i
      return handlers[i]
    }
  
    for i in 0 ..< handlers.count where !handlers[i].isBusy {
      generator.circlePointer = i
      return handlers[i]
    }
  
    return nil
  }
  
  // Comparable conformance
  public static func < (lhs: GeneratorAction, rhs: GeneratorAction) -> Bool {
    lhs.timestamp < rhs.timestamp
  }
  
  public static func == (lhs: GeneratorAction, rhs: GeneratorAction) -> Bool {
    lhs.timestamp == rhs.timestamp
  }
}
