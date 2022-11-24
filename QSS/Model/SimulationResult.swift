import Foundation

struct SimulationResult {
  private(set) var generatorResults: [GeneratorResult]
  private(set) var handlerResults: [HandlerResult]

  mutating func clear() {
    generatorResults.removeAll()
    handlerResults.removeAll()
  }
}

struct HandlerResult: Identifiable {
  let id = UUID()

  let handlerNumber: Int
  let handledOrdersCount: Int
  static var totalTime = 0.0

  var usageCoefficient: Double {
    guard HandlerResult.totalTime != 0 else { return 0.0 }
    return Double(handledOrdersCount) / Double(HandlerResult.totalTime)
  }
}

struct GeneratorResult: Identifiable {
  let id = UUID()

  let generatorNumber: Int
  let generatedOrdersCount: Int
  let rejectCount: Int

  var rejectProbability: Double {
    guard generatedOrdersCount != 0 else { return 0.0 }
    return Double(rejectCount) / Double(generatedOrdersCount)
  }

  var totalAverageOrderTime: Double { avProcessingTime + avInBufferTime }
  let avProcessingTime: Double
  let avInBufferTime: Double

  let bufferDispersion: Double
  let processingDispersion: Double
}

enum SimulationResultFactory {
  static func makeResult(
    _ totalTime: Double,
    _ generators: [Generator],
    _ handlers: [Handler]
  ) -> SimulationResult {
    var generatorResults = [GeneratorResult]()

    for i in 0 ..< generators.count {
      let currentGenerator = generators[i]
      let result = GeneratorResult(
        generatorNumber: i + 1,
        generatedOrdersCount: currentGenerator.totalOrders,
        rejectCount: currentGenerator.rejectedRequests,
        avProcessingTime: currentGenerator.handlingTimes.average,
        avInBufferTime: currentGenerator.inBufferTimes.average,
        bufferDispersion: currentGenerator.inBufferTimes.dispersion,
        processingDispersion: currentGenerator.handlingTimes.dispersion
      )
      generatorResults.append(result)
    }

    var handlerResults = [HandlerResult]()
    HandlerResult.totalTime = totalTime

    for i in 0 ..< handlers.count {
      let currentHandler = handlers[i]
      let result = HandlerResult(
        handlerNumber: i + 1,
        handledOrdersCount: currentHandler.handledOrdersCount
      )
      handlerResults.append(result)
    }

    return SimulationResult(generatorResults: generatorResults, handlerResults: handlerResults)
  }
}
