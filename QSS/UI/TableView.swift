//
//  TableView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

public struct OrderContent: Identifiable {
  public let id = UUID()

  let generator: Int
  var totalOrdersCount: Int
  var avProcessingTime: Double
  var avInBufferTime: Double
  var rejectCount: Int

  var rejectPercent: Double { Double(rejectCount) / Double(totalOrdersCount) }
}

struct TableView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack {
      Table(appState.simulation.tableResults) {
        TableColumn("Generators") {
          Text("№\($0.generator + 1)")
        }
        TableColumn("Orders") {
          Text($0.totalOrdersCount, format: .number)
        }
        TableColumn("Processing time (average)") {
          Text("\($0.avProcessingTime)")
        }
        TableColumn("In-buffer time (average)") {
          Text("\($0.avInBufferTime)")
        }
        TableColumn("Reject %") {
          Text($0.rejectPercent, format: .number)
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
