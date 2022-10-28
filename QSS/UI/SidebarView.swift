//
//  SidebarView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

enum Mode: String, CaseIterable {
  case auto = "Auto"
  case manual = "Manual"
}

struct SidebarView: View {
  @Binding var mode: Mode?

  var body: some View {
    List(selection: $mode) {
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
    SidebarView(mode: .constant(.auto))
      .preferredColorScheme(.dark)
      .frame(width: 200)
  }
}
