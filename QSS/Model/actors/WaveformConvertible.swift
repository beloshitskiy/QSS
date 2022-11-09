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

public enum ShortStep: CaseIterable {
  case straight
  case up
  case down
}

public enum StepType: CaseIterable {
  case straight
  case up
  case down
  case tick
  case rejectorTick
}

protocol WaveformConvertible: ObservableObject, Identifiable, Equatable {
  var chartData: [WaveformPoint] { get set }

  var baseLine: Double { get }

  func makeStep(_ step: ShortStep, stepWidth: Double, stepHeight: Double)
  
  static func == (lhs: Self, rhs: Self) -> Bool
}

extension WaveformConvertible {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}
