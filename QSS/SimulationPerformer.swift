//
//  ActionHelper.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation
import SwiftPriorityQueue

final class SimulationPerformer {
  // queue for actions
  private var actions: PriorityQueue<Action>

  // count of actions to be generated
  var ordersCount: Int

  // count of actors of each-type below
  var generatorsCount: Int
  var handlersCount: Int
  var buffersCount: Int

  // actors
  private(set) var generators: [Generator]
  private(set) var handlers: [Handler]
  private(set) var buffers: [Buffer]
  private(set) var rejector: Rejector

  // statistics for TableView
  private(set) var simulationResult: SimulationResult

  // variables and constants for beautifying WaveformView
  private var baseLine: Double
  private let inset: Double
  private var step: Double

  // MARK: - Inits

  init(generatorsCount: Int = 3, handlersCount: Int = 3, buffersCount: Int = 3,
       baseLine: Double = 0.0, inset: Double = 1.5) {
    actions = PriorityQueue<Action>(ascending: true)
    ordersCount = 0

    self.generatorsCount = generatorsCount
    self.handlersCount = handlersCount
    self.buffersCount = buffersCount

    let actors = ActorsFactory.makeActors(generatorsCount: generatorsCount,
                                          handlersCount: handlersCount,
                                          buffersCount: buffersCount)

    generators = actors.generators
    handlers = actors.handlers
    buffers = actors.buffers
    rejector = actors.rejector

    self.baseLine = baseLine
    self.inset = inset
    step = 0.0
    simulationResult = SimulationResult(generatorResults: [], handlerResults: [])
  }

  // MARK: - Start

  func startAuto() {
    reset()
    fillWithActions()
    guard !actions.isEmpty else { return }

    while !actions.isEmpty {
      performStep()
    }

    simulationResult = SimulationResultFactory.makeResult(ordersCount, generators, handlers)
    endGeneration()
  }

  func startManual() {
    reset()
    fillWithActions()
    guard !actions.isEmpty else { return }
    performStep()
  }

  // MARK: - Process functions

  func performStep() {
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

  private func fillWithActions() {
    for _ in 0 ..< ordersCount {
      guard let generator = generators.randomElement() else {
        return
      }
      generator.remainingActions += 1
      var timestamp = generator.lastActionTimestamp

      timestamp += Double.generateTimeForAction(for: .generator)
      actions.push(GeneratorAction(timestamp, generator, self))

      generator.lastActionTimestamp = timestamp
    }
  }

  func reset() {
    actions.clear()

    generators.removeAll()
    handlers.removeAll()
    buffers.removeAll()

    let actors = ActorsFactory.makeActors(generatorsCount: generatorsCount,
                                          handlersCount: handlersCount,
                                          buffersCount: buffersCount)

    generators = actors.generators
    handlers = actors.handlers
    buffers = actors.buffers
    rejector = actors.rejector

    baseLine = 0.0
    step = 0.0
    simulationResult.clear()
  }

  // MARK: - End

  private func endGeneration() {
    step += Double.generateTimeForAction(for: .generator)
    generators.forEach { $0.makeStep(stepWidth: step) }
    handlers.forEach { $0.makeStep(stepWidth: step) }
    buffers.forEach { $0.makeStep(stepWidth: step) }
    rejector.makeStep(stepWidth: step)
  }
}
