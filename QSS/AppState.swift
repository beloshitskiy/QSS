//
//  AppState.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

enum AppMode: String, CaseIterable {
  case auto = "Auto"
  case manual = "Manual"
}

final class AppState: ObservableObject {
  @Published var simulation = SimulationPerformer()
  @Published var appMode: AppMode? = .auto
  @Published var isStarted = false
  @Published var ordersCount = 0 {
    willSet {
      if newValue != ordersCount {
        simulation.ordersCount = newValue
      }
    }
  }

  // TODO: Get rid of explicit view updater
  @Published var kostyul = false
}
