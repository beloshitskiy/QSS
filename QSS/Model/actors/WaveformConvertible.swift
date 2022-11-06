//
//  WaveformConvertible.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation
import SwiftUICharts

public typealias Point = LineChartDataPoint

protocol WaveformConvertible: ObservableObject, Identifiable {
  var chartPoints: [Point] { get set }

  func makeStep()
}

extension WaveformConvertible {
  public func makeStep() {
    let lastPoints = chartPoints.suffix(2)
    guard lastPoints.count > 1 else {
      chartPoints.append(Point(value: 0.0))
      return
    }

    let newPoint = Point(value: chartPoints.allSatisfy { $0.value == 1 } ? 0 : 1)
    chartPoints.append(newPoint)
  }
}
