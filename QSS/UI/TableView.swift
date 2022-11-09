//
//  TableView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

public struct OrderContent: Identifiable {
  public let id = UUID()
  static var totalOrdersCount = 0

  let generator: Int
  var handledOrdersCount: Int
  var avProcessingTime: Double
  var avInBufferTime: Double
  var rejectCount: Int

  var rejectPercent: Double {
    guard OrderContent.totalOrdersCount != 0 else { return 0.0 }
    return Double(rejectCount) / Double(OrderContent.totalOrdersCount) * 100
  }
}

struct TableView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack {
      Table(appState.simulation.tableResults) {
        TableColumn("Generators") {
          Text("№\($0.generator + 1)")
        }
        TableColumn("Handled orders") {
          Text($0.handledOrdersCount, format: .number)
        }
        TableColumn("Processing time (average)") {
          Text($0.avProcessingTime, format: .number)
        }
        TableColumn("In-buffer time (average)") {
          Text($0.avInBufferTime, format: .number)
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
