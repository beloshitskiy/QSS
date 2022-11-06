//
//  SidebarView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct SidebarView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    List(selection: $appState.appMode) {
      Section {
        ForEach(Mode.allCases, id: \.self) {
          Text($0.rawValue)
        }
      } header: {
        Text("Mode")
      }
    }
    .listStyle(.sidebar)
  }
}

struct SidebarView_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView()
      .environmentObject(AppState())
      .preferredColorScheme(.dark)
      .frame(width: 200)
  }
}
