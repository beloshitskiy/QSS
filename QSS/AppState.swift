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

class AppState: ObservableObject {
  @Published var simulation = SimulationPerformer()
  @Published var appMode: Mode? = .auto
}
