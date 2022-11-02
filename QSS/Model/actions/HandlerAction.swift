//
//  HandlerAction.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation

public class HandlerAction: Action {
  private let timestamp: Double
  
  override public func getTimestamp() -> Double { timestamp }
  
  private let handler: Handler
  private let generator: Generator
  private let helper: ActionHelper
  
  override public func doAction() -> Action? {
    handler.isOccupied = false
    handler.y -= 10
    handler.makeStep(timestamp)
    if let buffer = optFreeBuffer {
      handler.isOccupied = true
      handler.y += 10
      handler.makeStep(timestamp)
      if let generator = buffer.currentGenerator {
        buffer.currentGenerator = nil
        buffer.y -= 10
        buffer.makeStep(timestamp)
        let time = timestamp + MathUtils.generateTimeForAction()
        handler.usageTime = handler.usageTime + time - timestamp
        generator.acceptedRequests += 1
        generator.waitingTimes.append(timestamp - buffer.startedWaitingTime)
        generator.handlingTimes.append(time - timestamp)
        return HandlerAction(timestamp: time, handler: handler,
                             generator: generator, helper: helper)
      }
    }
    
    return nil
  }
  
  private var optFreeBuffer: Buffer? {
    guard !helper.buffers.allSatisfy({ $0.isBusy }) else { return nil }
  
    for buf in helper.buffers where !buf.isBusy {
      return buf
    }
  
    return nil
  }
  
  public init(_ timestamp: Double, _ handler: Handler, _ generator: Generator, _ helper: ActionHelper) {
    self.timestamp = timestamp
    self.handler = handler
    self.generator = generator
    self.helper = helper
    
    super.init()
  }
  
  public static func < (lhs: HandlerAction, rhs: HandlerAction) -> Bool {
    lhs.timestamp < rhs.timestamp
  }

  public static func == (lhs: HandlerAction, rhs: HandlerAction) -> Bool {
    lhs.timestamp == rhs.timestamp
  }
}
