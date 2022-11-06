//
//  ContentView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    NavigationView {
      SidebarView()
      switch appState.appMode {
        case .auto: TableView()
        case .manual: ScrollView { WaveformsView() }
        default: Text("Choose mode").font(.largeTitle)
      }
    }
    .frame(
      minWidth: 1000,
      idealWidth: 1200,
      maxWidth: .infinity,
      minHeight: 600,
      idealHeight: 800,
      maxHeight: .infinity)
    .navigationTitle(windowTitle)
    .toolbar(id: "mainToolbar") {
      Toolbar()
    }
  }

  private var windowTitle: String {
    if let currentMode = appState.appMode {
      return "QSS - \(currentMode.rawValue)"
    }
    return "QSS"
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(AppState())
  }
}
