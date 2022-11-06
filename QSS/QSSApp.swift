//
//  QSSApp.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

@main
struct QSSApp: App {
  var body: some Scene {
    let state = AppState()
    WindowGroup {
      ContentView()
        .environmentObject(state)
    }
  }
}
