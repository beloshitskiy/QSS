//
//  ContentView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct ContentView: View {
  @State private var currentMode: Mode? = .auto

  var body: some View {
    NavigationView {
      SidebarView(mode: $currentMode)
      switch currentMode {
        case .auto: TableView()
        case .manual: WaveformView()
        case nil: Text("Choose mode").font(.largeTitle)
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
    if let currentMode = currentMode {
      return "QSS - \(currentMode.rawValue)"
    }
    return "QSS"
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
