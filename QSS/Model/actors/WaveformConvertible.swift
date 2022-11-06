//
//  WaveformConvertible.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation
import SwiftUICharts

public typealias Point = LineChartDataPoint

public enum StepType: CaseIterable {
  case straight
  case up
  case down
  case tick
  case rejectorTick
}

protocol WaveformConvertible: ObservableObject, Identifiable {
  var chartPoints: [Point] { get set }

  func makeStep(_ step: StepType)
}

extension WaveformConvertible {
  public func makeStep(_ step: StepType = .straight) {
    let up = Point(value: 2.0)
    let down = Point(value: 0.0)
    guard let lastPoint = chartPoints.last else { return }
    let newPoints: [Point]
    switch step {
      case .straight:
      let newPoint = lastPoint.value == up.value ? up : down
        newPoints = [newPoint, newPoint]
      case .up: newPoints = [down, up]
      case .down: newPoints = [up, down]
      case .tick: newPoints = [down, up, up, down]
      case .rejectorTick: newPoints = [up, up, down]
    }
    chartPoints.append(contentsOf: newPoints)
  }
}
