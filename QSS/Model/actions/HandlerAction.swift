final class HandlerAction: Action {
  private let timestamp: Double

  private let handler: Handler
  private let generator: Generator
  private let performer: SimulationPerformer

  init(_ timestamp: Double, _ handler: Handler,
       _ generator: Generator, _ helper: SimulationPerformer) {
    self.timestamp = timestamp
    self.handler = handler
    self.generator = generator
    performer = helper

    super.init(value: timestamp)
  }

  // methods from Action
  override func getTimestamp() -> Double { timestamp }

  override func doAction() -> Action? {
    handler.isBusy = false
    handler.makeStep(.down, stepWidth: timestamp)

    if let buffer = optBusyBuffer {
      handler.isBusy = true
      handler.makeStep(.up, stepWidth: timestamp)
      if let generator = buffer.currentGenerator {
        buffer.currentGenerator = nil

        buffer.makeStep(.down, stepWidth: timestamp)

        let time = timestamp + Double.generateTimeForAction(for: .handler)
        handler.usageTime += (time - timestamp)
        generator.acceptedOrders += 1
        generator.inBufferTimes.append(timestamp - buffer.waitingFrom)
        generator.handlingTimes.append(time - timestamp)
        return HandlerAction(time, handler, generator, performer)
      }
    }
    return nil
  }

  // busy buffer finder
  private var optBusyBuffer: Buffer? {
    let sortedBuffers = performer.buffers.sorted(by: <)
    
    for buf in sortedBuffers where buf.isBusy {
      return buf
    }

    return nil
  }
}

fileprivate extension Buffer {
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
