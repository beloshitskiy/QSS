//
//  TableView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct TableView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack {
      Table(appState.simulation.simulationResult.generatorResults) {
        TableColumn("Generators") {
          Text("№\($0.generatorNumber)")
        }
        TableColumn("Generated orders") {
          Text($0.generatedOrdersCount, format: .number)
        }
        TableColumn("Reject probability") {
          Text($0.rejectProbability, format: .number)
        }
        TableColumn("Total order time (average)") {
          Text($0.totalAverageOrderTime, format: .number)
        }
        TableColumn("Processing time (average)") {
          Text($0.avProcessingTime, format: .number)
        }
        TableColumn("In-buffer time (average)") {
          Text($0.avInBufferTime, format: .number)
        }
        TableColumn("Buffer dispersion") {
          Text($0.bufferDispersion, format: .number)
        }
        TableColumn("Processing dispersion") {
          Text($0.processingDispersion, format: .number)
        }
      }

      Table(appState.simulation.simulationResult.handlerResults) {
        TableColumn("Handler") {
          Text("№\($0.handlerNumber)")
        }
        TableColumn("Usage coefficient") {
          Text($0.usageCoefficient, format: .number)
        }
      }

      ControlView()
    }
  }
}

struct TableView_Previews: PreviewProvider {
  static var previews: some View {
    TableView()
      .environmentObject(AppState())
  }
}
