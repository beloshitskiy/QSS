//
//  ContentView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct OldContentView: View {
  private static let buffers = 2
  private static let generators = 5
  private static let processors = 2
  @State private var flag = false

  let simulation = SimulationPerformer(proccesorsCount: processors,
                                       buffersCount: buffers)
  @State private var count = 0
  var body: some View {
    VStack {
      TextField("Order count",
                value: $count,
                format: .number)

      HStack {
        Button {
          simulation.ordersCount = count
          simulation.stepStart()
          flag = true
        } label: {
          Text("Start")
        }

        Button {
          simulation.step()
        } label: {
          Text("Step")
        }
        .disabled(!flag)
      }
    }
    .padding()
  }
}

struct OldContentView_Previews: PreviewProvider {
  static var previews: some View {
    OldContentView()
  }
}
