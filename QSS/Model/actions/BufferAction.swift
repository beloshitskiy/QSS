final class BufferAction: Action {
  private let timestamp: Double

  private let buffer: Buffer
  private let generator: Generator
  private let performer: SimulationPerformer

  init(
    _ timestamp: Double,
    _ buffer: Buffer,
    _ generator: Generator,
    _ performer: SimulationPerformer
  ) {
    self.timestamp = timestamp
    self.buffer = buffer
    self.generator = generator
    self.performer = performer

    super.init(value: timestamp)
  }

  // methods from Action
  override func getTimestamp() -> Double { timestamp }

  override func doAction() -> Action? {
    if !buffer.isBusy {
      buffer.currentGenerator = generator
      buffer.waitingFrom = timestamp
      buffer.makeStep(.up, stepWidth: timestamp)
    } else {
      buffer.makeStep(.down, stepWidth: timestamp)
      buffer.makeStep(.up, stepWidth: timestamp)

      let rejector = performer.rejector
      generator.rejectedRequests += 1
      rejector.makeStep(.up, stepWidth: timestamp)
      rejector.makeStep(.down, stepWidth: timestamp)

      generator.inBufferTimes.append(timestamp - buffer.waitingFrom)

      buffer.currentGenerator = generator
      buffer.waitingFrom = timestamp
    }
    return nil
  }
}
