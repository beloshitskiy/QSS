//
//  QSSApp.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

@main
struct QSSApp: App {
  @StateObject var appState = AppState()

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .commands {
      Menus()
    }
  }
}
