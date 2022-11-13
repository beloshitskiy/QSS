//
//  SimulationResult.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/13/22.
//

import Foundation

struct SimulationResult {
  static var totalOrdersCount = 0
  
  private(set) var generatorResults: [GeneratorResult]
  private(set) var handlerResults: [HandlerResult]
  
  mutating func clear() {
    generatorResults.removeAll()
    handlerResults.removeAll()
  }
}

struct HandlerResult: Identifiable {
  let id = UUID()
  
  let handler: Int
  let handledOrdersCount: Int
  static var totalHandledOrdersCount = 0
  
  var usageCoefficient: Double {
    guard HandlerResult.totalHandledOrdersCount != 0 else { return 0.0 }
    return Double(handledOrdersCount) / Double(HandlerResult.totalHandledOrdersCount)
  }
}

struct GeneratorResult: Identifiable {
  let id = UUID()
  static var totalOrdersCount = 0

  let generator: Int
  let handledOrdersCount: Int
  let avProcessingTime: Double
  let avInBufferTime: Double
  let rejectCount: Int

  var rejectPercent: Double {
    guard GeneratorResult.totalOrdersCount != 0 else { return 0.0 }
    return Double(rejectCount) / Double(GeneratorResult.totalOrdersCount) * 100
  }
}

final class SimulationResultFactory {
  static func makeResult(_ ordersCount: Int, _ generators: [Generator],
                         _ handlers: [Handler]) -> SimulationResult {
    
    var generatorResults = [GeneratorResult]()
    
    for i in 0 ..< generators.count {
      let currentGenerator = generators[i]
      let result = GeneratorResult(generator: i,
                           handledOrdersCount: currentGenerator.acceptedOrders,
                           avProcessingTime: currentGenerator.handlingTimes.average,
                           avInBufferTime: currentGenerator.inBufferTimes.average,
                           rejectCount: currentGenerator.rejectedRequests)
      generatorResults.append(result)
    }
    
    var handlerResults = [HandlerResult]()
    HandlerResult.totalHandledOrdersCount = handlers.reduce(into: 0) { result, han in
      result += han.handledOrdersCount
    }
    
    for i in 0 ..< handlers.count {
      let currentHandler = handlers[i]
      let result = HandlerResult(handler: i,
                                 handledOrdersCount: currentHandler.handledOrdersCount)
      handlerResults.append(result)
    }
    
    return SimulationResult(generatorResults: generatorResults, handlerResults: handlerResults)
  }
}
