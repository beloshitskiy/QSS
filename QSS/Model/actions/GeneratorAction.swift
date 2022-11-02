//
//  GeneratorAction.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation

public class GeneratorAction: Action {
  private let timestamp: Double
  
  override public func getTimestamp() -> Double { timestamp }
  
  private let generator: Generator
  
  private let helper: ActionHelper
  
  override public func doAction() -> Action? {
    generator.amountOfActions -= 1
    generator.y += 10
    generator.makeStep(timestamp);
    generator.y -= 10
    generator.makeStep(timestamp);
    
    if let handler = optHandler {
      handler.isOccupied = true
      handler.y += 10
      handler.makeStep(timestamp)
      let time = timestamp + MathUtils.generateTimeForAction()
      handler.usageTime = handler.usageTime + time - timestamp
      generator.acceptedRequests += 1
      generator.handlingTimes.append(time - timestamp)
      
      return HandlerAction(timestamp: time, handler: handler,
                           generator: generator, helper: helper)
    }
    
    
    var target: Buffer? = nil
    for buffer in helper.buffers {
      if buffer.currentGenerator == nil {
        target = buffer
        break
      }
      
      if buffer.isNewest {
        target = buffer
      }
    }
    
    for buffer in helper.buffers {
      buffer.isNewest = false
    }
    
    if let target {
      target.isNewest = true
      return BufferAction(timestamp: timestamp, buffer: target,
                          generator: generator, helper: helper)
    }
    
    return nil
  }
  
  private var optHandler: Handler? {
    let handlers = helper.handlers
    guard !handlers.allSatisfy({ $0.isOccupied }) else { return nil }
  
    for i in generator.lastCheckedHandlerNum ..< handlers.count where !handlers[i].isOccupied {
      generator.lastCheckedHandlerNum = i
      return handlers[i]
    }
  
    for i in 0 ..< handlers.count where !handlers[i].isOccupied {
      generator.lastCheckedHandlerNum = i
      return handlers[i]
    }
  
    return nil
  }
  
  public init(_ timestamp: Double, _ generator: Generator, _ helper: ActionHelper) {
    self.timestamp = timestamp
    self.generator = generator
    self.helper = helper
    
    super.init()
  }
  
  public static func < (lhs: GeneratorAction, rhs: GeneratorAction) -> Bool {
    lhs.timestamp < rhs.timestamp
  }
  
  public static func == (lhs: GeneratorAction, rhs: GeneratorAction) -> Bool {
    lhs.timestamp == rhs.timestamp
  }
}
