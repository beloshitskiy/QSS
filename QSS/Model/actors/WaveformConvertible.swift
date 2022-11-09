//
//  WaveformConvertible.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Charts
import Foundation

public struct Point: Identifiable {
  public let id = UUID()
  var x: Double
  var y: Double
}

public enum StepType: CaseIterable {
  case straight
  case up
  case down
  case tick
  case rejectorTick
}

protocol WaveformConvertible: ObservableObject, Identifiable {
  func makeStep(_ simulation: SimulationPerformer, actor: Actor, _ step: StepType, stepWidth: Double, stepHeight: Double)
}

extension WaveformConvertible {
  func makeStep(_ simulation: SimulationPerformer, actor: Actor, _ step: StepType, stepWidth: Double, stepHeight: Double = 1.0) {
    let graphModifier: Double
    let insetMultiplier = 2.0
    switch actor {
      case .rejector: graphModifier = 0.0
      case .buffer: graphModifier = stepHeight * insetMultiplier
      case .handler: graphModifier = stepHeight * insetMultiplier * Double(simulation.buffers.count + 1)
      case .generator: graphModifier = stepHeight * insetMultiplier * Double(simulation.buffers.count + simulation.handlers.count + 1)
    }

    let up = WaveformPoint(actor, .init(x: stepWidth, y: stepHeight + graphModifier))
    let addUp = WaveformPoint(actor, .init(x: stepWidth * 2, y: stepHeight + graphModifier))
    let down = WaveformPoint(actor, .init(x: stepWidth, y: 0.0 + graphModifier))
    
    guard let lastPoint = simulation.chartData.last else {
      simulation.chartData.append(down)
      return
    }

    let newPoints: [WaveformPoint]
    switch step {
      case .straight: newPoints = [lastPoint.y == up.y ? up : down]
      case .up: newPoints = [down, up]
      case .down: newPoints = [up, down]
      case .tick: newPoints = [down, up, addUp, down]
      case .rejectorTick: newPoints = [up, addUp, down]
    }
    simulation.chartData.append(contentsOf: newPoints)
  }
}
