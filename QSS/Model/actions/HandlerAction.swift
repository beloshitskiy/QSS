final class HandlerAction: Action {
  private let timestamp: Double

  private let handler: Handler
  private let generator: Generator
  private let performer: SimulationPerformer

  init(
    _ timestamp: Double,
    _ handler: Handler,
    _ generator: Generator,
    _ helper: SimulationPerformer
  ) {
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
    handler.currentOrderPriority = nil
    handler.makeStep(.down, stepWidth: timestamp)

    if let buffer = optBusyBuffer {
      handler.isBusy = true
      handler.currentOrderPriority = buffer.currentGenerator?.priority
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
    for buf in performer.buffers where
      buf.isBusy && buf.currentGenerator?.priority == performer.currentPriority {
      return buf
    }

    for buf in performer.buffers where buf.isBusy {
      performer.currentPriority = buf.currentGenerator?.priority
      return buf
    }

    return nil
  }
}
