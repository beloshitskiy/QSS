//
//  ControlView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct ControlView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack {
      HStack {
        Text("Number of orders:")
        TextField("", value: $appState.ordersCount, format: .number)
          .textFieldStyle(.roundedBorder)
          .frame(width: 75)
      }

      switch appState.appMode {
        case .auto:
          Button {
            if !appState.isStarted {
              appState.simulation.startAuto()
              appState.isStarted = true
            } else {
              appState.simulation.reset()
              appState.isStarted = false
            }
          } label: {
            Text(!appState.isStarted ? "Start" : "Reset")
          }.buttonStyle(.bordered)

        case .manual:
          HStack {
            Button {
              if !appState.isStarted {
                appState.simulation.startManual()
                appState.isStarted = true
              } else {
                appState.simulation.reset()
                appState.isStarted = false
              }
            } label: {
              Text(!appState.isStarted ? "Start" : "Reset")
            }.buttonStyle(.bordered)

            Button {
              withAnimation {
                appState.simulation.performStep()
                appState.kostyul.toggle()
              }
            } label: {
              Text("Step")
            }.disabled(!appState.isStarted)
              .buttonStyle(.bordered)
          }

        default: EmptyView()
      }
    }
    .padding()
  }
}

struct ControlView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ControlView()
      ControlView()
    }.environmentObject(AppState())
  }
}
