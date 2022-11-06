//
//  Action.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

public class Action: Comparable {
  func doAction() -> Action? { nil }

  public func getTimestamp() -> Double { 0.0 }

  public static func < (lhs: Action, rhs: Action) -> Bool { true }

  public static func == (lhs: Action, rhs: Action) -> Bool { true }
}
