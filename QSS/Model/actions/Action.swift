//
//  Action.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/2/22.
//

import Foundation

public class Action: Comparable {
  func doAction() -> Action? { nil }
  
  public func getTimestamp() -> Double { 0.0 }

  public static func < (lhs: Action, rhs: Action) -> Bool { true }

  public static func == (lhs: Action, rhs: Action) -> Bool { true }
}
