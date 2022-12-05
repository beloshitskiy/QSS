import SwiftUI

struct ControlView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    HStack {
      VStack {
        HStack {
          Text("Number of orders:")
          TextField("", value: $appState.ordersCount, format: .number)
            .textFieldStyle(.roundedBorder)
            .frame(width: 75)
        }

        switch appState.appMode {
          case .auto:
            HStack {
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
            }

          case .manual:
            HStack {
              Button {
                if !appState.isStarted {
                  withAnimation {
                    appState.simulation.startManual()
                    appState.isStarted = true
                  }
                } else {
                  withAnimation {
                    appState.simulation.reset()
                    appState.isStarted = false
                  }
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
      VStack(alignment: .leading) {
        Stepper(value: $appState.simulation.generatorsCount, in: 1 ... 10, step: 1) {
          Text("Number of generators: \(appState.simulation.generatorsCount)")
        }
        Stepper(value: $appState.simulation.handlersCount, in: 1 ... 10, step: 1) {
          Text("Number of handlers: \(appState.simulation.handlersCount)")
        }
        Stepper(value: $appState.simulation.buffersCount, in: 1 ... 10, step: 1) {
          Text("Number of buffers: \(appState.simulation.buffersCount)")
        }
      }
      .padding()

      Button {
        appState.simulation.startExport()
      } label: {
        Text("Export to .csv")
      }
      .padding()
    }
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
