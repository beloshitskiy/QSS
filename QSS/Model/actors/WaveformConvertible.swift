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

public enum Step: CaseIterable {
  case straight
  case up
  case down
}

protocol WaveformConvertible: ObservableObject, Identifiable, Equatable {
  var chartData: [WaveformPoint] { get set }

  var baseLine: Double { get }

  func makeStep(_ step: Step, stepWidth: Double, stepHeight: Double)
  
  static func == (lhs: Self, rhs: Self) -> Bool
}

extension WaveformConvertible {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}
