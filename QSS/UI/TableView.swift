//
//  TableView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct OrderContent: Identifiable {
  let id = UUID()

  let generator: Int
  let ordersCount: Int
  let avProcessingTime: Double
  let avInBufferTime: Double
  let rejectCount: Int

  var rejectPercent: Double { Double(rejectCount) / Double(ordersCount) }
}

struct TableView: View {
  var orderContents: [OrderContent] = [OrderContent(generator: 0,
                                                    ordersCount: 100,
                                                    avProcessingTime: 23.5,
                                                    avInBufferTime: 0.4,
                                                    rejectCount: 15)]
  var body: some View {
    VStack {
      Table(orderContents) {
        TableColumn("Generators") { content in
          Text("№\(content.generator + 1)")
        }
        TableColumn("Orders") { content in
          Text(content.ordersCount, format: .number)
        }
        TableColumn("Processing time (average)") { content in
          Text(content.avProcessingTime, format: .number)
        }
        TableColumn("In-buffer time (average)") { content in
          Text(content.avInBufferTime, format: .number)
        }
        TableColumn("Reject %") { content in
          Text(content.rejectPercent, format: .number)
        }
      }
      
      ControlView(mode: .auto)
    }
  }
}

struct TableView_Previews: PreviewProvider {
  static var previews: some View {
    TableView(orderContents: [OrderContent(generator: 0,
                                           ordersCount: 100,
                                           avProcessingTime: 23.5,
                                           avInBufferTime: 0.4,
                                           rejectCount: 15)])
  }
}
