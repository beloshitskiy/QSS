//
//  ControlView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct ControlView: View {
  @EnvironmentObject var appState: AppState
  let mode: Mode
  @State private var num = 1
  @State private var isStarted = false

  var body: some View {
    VStack {
      HStack {
        Text("Number of orders:")
        TextField("", value: $num, format: .number)
          .textFieldStyle(.roundedBorder)
          .frame(width: 75)
      }

      switch mode {
        case .auto:
          Button {
            if !isStarted {
              appState.simulation.start()
              isStarted = true
            } else {
              appState.simulation.clear()
              isStarted = false
            }
          } label: {
            Text("Start")
          }.buttonStyle(.bordered)

        case .manual:
          HStack {
            Button {
              if !isStarted {
                appState.simulation.stepStart()
                isStarted = true
              } else {
                appState.simulation.clear()
                isStarted = false
              }
            } label: {
              Text(!isStarted ? "Start" : "Clear")
            }.buttonStyle(.bordered)

            Button {
              appState.simulation.step()
            } label: {
              Text("Step")
            }.disabled(!isStarted)
              .buttonStyle(.bordered)
          }
      }
    }
    .padding()
  }
}

struct ControlView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ControlView(mode: .auto)
        .environmentObject(AppState())
      ControlView(mode: .manual)
        .environmentObject(AppState())
    }
  }
}
