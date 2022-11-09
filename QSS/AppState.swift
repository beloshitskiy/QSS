//
//  AppState.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

enum Mode: String, CaseIterable {
  case auto = "Auto"
  case manual = "Manual"
}

final class AppState: ObservableObject {
  @Published var simulation = SimulationPerformer()
  @Published var appMode: Mode? = .auto
  @Published var isStarted = false
  @Published var ordersCount = 0 {
    willSet {
      if newValue != ordersCount {
        simulation.ordersCount = newValue
      }
    }
  }
  @Published var kostyul = false
}
