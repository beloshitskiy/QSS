//
//  ActionHelper.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation
import SwiftPriorityQueue

public class ActionHelper {
  let actionsPerGenerations = 100

  var totalRequestsCount: Int
  var rejectedRequestsCount: Int

  private var step: Double

  private var actions: PriorityQueue<Action>

  public var generators: [Generator]
  public var buffers: [Buffer]
  public var handlers: [Handler]
  public let rejector: Rejector

  private let generatorsCount: Int
  private let buffersCount: Int
  private let handlersCount: Int

  public init(actions: PriorityQueue<Action>,
              generatorsCount: Int,
              buffersCount: Int,
              handlersCount: Int)
  {
    self.step = 0
    self.totalRequestsCount = 0
    self.rejectedRequestsCount = 0

    self.actions = actions

    self.generatorsCount = generatorsCount
    self.buffersCount = buffersCount
    self.handlersCount = handlersCount

    self.generators = [Generator]()
    self.buffers = [Buffer]()
    self.handlers = [Handler]()
    self.rejector = Rejector(y: 10)
  }

  public func performStep() {
    for generator in generators where generator.isActionless {
      fillWithNewActions(generator)
    }

    if let action = actions.pop() {
      step = action.getTimestamp()
      rejector.makeStep(step)

      generators.forEach { $0.makeStep(step) }
      buffers.forEach { $0.makeStep(step) }
      handlers.forEach { $0.makeStep(step) }

      if let act = action.doAction() {
        actions.push(act)
      }
    }
  }

  public func fillWithNewActions(_ generator: Generator) {
    generator.amountOfActions = actionsPerGenerations
    var timestamp = generator.lastActionTimestamp

    for _ in 0 ..< actionsPerGenerations {
      timestamp = timestamp + MathUtils.generateTimeForAction()
      actions.push(GeneratorAction(timestamp, generator, self))
    }
    generator.lastActionTimestamp = timestamp
  }

  public func reset() {
    step = 0
    totalRequestsCount = 0
    rejectedRequestsCount = 0

    actions.clear()

    generators.removeAll()
    handlers.removeAll()
    buffers.removeAll()
  }
}
