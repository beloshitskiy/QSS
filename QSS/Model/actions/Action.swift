//
//  Action.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

class Action: Comparable {
  private var value: Double

  init(value: Double) {
    self.value = value
  }

  // must be overriden
  func doAction() -> Action? { nil }
  func getTimestamp() -> Double { value }

  // comparable conformance
  static func < (lhs: Action, rhs: Action) -> Bool {
    lhs.value < rhs.value
  }

  static func == (lhs: Action, rhs: Action) -> Bool {
    lhs.value == rhs.value
  }
}
