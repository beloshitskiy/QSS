final class GeneratorAction: Action {
  private let timestamp: Double
  
  private let generator: Generator
  private let performer: SimulationPerformer
  
  init(_ timestamp: Double, _ generator: Generator, _ helper: SimulationPerformer) {
    self.timestamp = timestamp
    self.generator = generator
    performer = helper
    
    super.init(value: timestamp)
  }
  
  // methods from Action
  override func getTimestamp() -> Double { timestamp }
  
  override func doAction() -> Action? {
    generator.makeStep(.up, stepWidth: timestamp)
    generator.makeStep(.down, stepWidth: timestamp)

    if let handler = optHandler {
      handler.isBusy = true
      handler.currentOrderPriority = generator.priority
      performer.currentPriority = generator.priority
      handler.makeStep(.up, stepWidth: timestamp)
      
      if performer.currentPriority == nil {
        performer.currentPriority = generator.priority
      }

      let time = timestamp + Double.generateTimeForAction(for: .generator)
      handler.usageTime += (time - timestamp)
      generator.acceptedOrders += 1
      generator.handlingTimes.append(time - timestamp)
      
      return HandlerAction(time, handler, generator, performer)
    }
    
    if let buffer = optFreeBuffer {
      return BufferAction(timestamp, buffer, generator, performer)
    }
    
    performer.rejector.makeStep(.up, stepWidth: timestamp)
    performer.rejector.makeStep(.down, stepWidth: timestamp)
    generator.rejectedRequests += 1
    
    return nil
  }
  
  // free handler finder
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
  
  // free buffer finder
  private var optFreeBuffer: Buffer? {
    for buf in performer.buffers where !buf.isBusy {
      return buf
    }
    
    if let lowestPriorityBuffer = performer.buffers.sorted(by: <).last,
       let lowestPriority = lowestPriorityBuffer.currentGenerator?.priority {
      if generator.priority < lowestPriority {
        performer.rejector.makeStep(.up, stepWidth: timestamp)
        performer.rejector.makeStep(.down, stepWidth: timestamp)
        lowestPriorityBuffer.currentGenerator?.rejectedRequests += 1
        lowestPriorityBuffer.currentGenerator = generator
        lowestPriorityBuffer.waitingFrom = timestamp
      }
    }

    return nil
  }
}

private extension Buffer {
  static func < (lhs: Buffer, rhs: Buffer) -> Bool {
    if let lpriority = lhs.currentGenerator?.priority,
       let rpriority = rhs.currentGenerator?.priority {
      return lpriority < rpriority
    } else if lhs.isBusy {
      return true
    } else {
      return false
    }
  }
}
