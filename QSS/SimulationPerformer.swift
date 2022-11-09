//
//  ActionHelper.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation
import SwiftPriorityQueue

public class SimulationPerformer: ObservableObject {
  // queue for actions
  @Published private var actions: PriorityQueue<Action>

  // count of actions to be generated
  @Published var ordersCount: Int

  // count of actors of each-type below
  @Published public var generatorsCount: Int
  @Published public var handlersCount: Int
  @Published public var buffersCount: Int

  // actors
  @Published public var generators: [Generator]
  @Published public var handlers: [Handler]
  @Published public var buffers: [Buffer]
  @Published public var rejector: Rejector

  // statistics for TableView
  @Published var totalRequestsCount: Int
  @Published var tableResults: [OrderContent]

  // variables and constants for beautifing WaveformView
  private var baseLine = 0.0
  private let inset = 1.5
  private var step: Double

  // MARK: - Inits

  public init(actions: PriorityQueue<Action> = PriorityQueue<Action>(ascending: true),
              generatorsCount: Int = 3, handlersCount: Int = 3, buffersCount: Int = 3)
  {
    self.actions = actions
    ordersCount = 0

    self.generatorsCount = generatorsCount
    self.handlersCount = handlersCount
    self.buffersCount = buffersCount

    var generators = [Generator]()
    var handlers = [Handler]()
    var buffers = [Buffer]()

    step = 0

    for _ in 0 ..< buffersCount {
      baseLine += inset
      let buf = Buffer(baseLine: baseLine)
      buffers.append(buf)
      buf.makeStep(stepWidth: step)
    }

    for _ in 0 ..< handlersCount {
      baseLine += inset
      let han = Handler(baseLine: baseLine)
      handlers.append(han)
      han.makeStep(stepWidth: step)
    }

    for _ in 0 ..< generatorsCount {
      baseLine += inset
      let gen = Generator(baseLine: baseLine)
      generators.append(gen)
      gen.makeStep(stepWidth: step)
    }

    self.generators = generators
    self.handlers = handlers
    self.buffers = buffers
    rejector = Rejector()

    totalRequestsCount = 0
    tableResults = []
  }

  // MARK: - Start

  public func startAuto() {
    reset()
    fillWithActions()
    guard !actions.isEmpty else {
      return
    }

    while !actions.isEmpty {
      performStep()
    }

    tableResults = getTableResults()
  }

  public func startManual() {
    reset()
    fillWithActions()
    guard !actions.isEmpty else {
      return
    }
    performStep()
  }

  public func performStep() {
    if let action = actions.pop() {
      step = action.getTimestamp()
      rejector.makeStep(stepWidth: step)

      generators.forEach {
        $0.makeStep(stepWidth: step)
      }
      handlers.forEach {
        $0.makeStep(stepWidth: step)
      }
      buffers.forEach {
        $0.makeStep(stepWidth: step)
      }

      if let act = action.doAction() {
        actions.push(act)
      }
    }
  }

  public func fillWithActions() {
    for _ in 0 ..< ordersCount {
      guard let generator = generators.randomElement() else {
        return
      }
      generator.remainingActions += 1
      var timestamp = generator.lastActionTimestamp

      timestamp += Double.generateTimeForAction()
      actions.push(GeneratorAction(timestamp, generator, self))

      generator.lastActionTimestamp = timestamp
    }
  }

  public func reset() {
    step = 0
    totalRequestsCount = 0

    actions.clear()

    generators.removeAll()
    handlers.removeAll()
    buffers.removeAll()
    rejector.chartData.removeAll()
    tableResults.removeAll()

    baseLine = 0.0

    for _ in 0 ..< buffersCount {
      baseLine += inset
      let buf = Buffer(baseLine: baseLine)
      buffers.append(buf)
      buf.makeStep(stepWidth: step)
    }

    for _ in 0 ..< handlersCount {
      baseLine += inset
      let han = Handler(baseLine: baseLine)
      handlers.append(han)
      han.makeStep(stepWidth: step)
    }

    for _ in 0 ..< generatorsCount {
      baseLine += inset
      let gen = Generator(baseLine: baseLine)
      generators.append(gen)
      gen.makeStep(stepWidth: step)
    }
  }

  public func getTableResults() -> [OrderContent] {
    var contents = [OrderContent]()
    OrderContent.totalOrdersCount = ordersCount

    for i in 0 ..< generators.count {
      let currentGen = generators[i]
      let c = OrderContent(generator: i,
                           handledOrdersCount: currentGen.acceptedOrders,
                           avProcessingTime: currentGen.handlingTimes.average,
                           avInBufferTime: currentGen.inBufferTimes.average,
                           rejectCount: currentGen.rejectedRequests)
      contents.append(c)
    }
    return contents
  }
}
