//
//  WaveformView.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/9/22.
//

import Charts
import SwiftUI

enum Actor: String, Plottable {
  case generator = "Generators"
  case handler = "Handlers"
  case buffer = "Buffers"
  case rejector = "Rejector"
}

struct WaveformPoint: Identifiable {
  let id = UUID()
  var actor: Actor
  var coordinates: Point

  var x: Double { coordinates.x }
  var y: Double { coordinates.y }

  init(_ actor: Actor, _ coordinates: Point) {
    self.actor = actor
    self.coordinates = coordinates
  }
}

struct WaveformView: View {
  @EnvironmentObject var appState: AppState
  var body: some View {
    VStack {
      Chart(appState.simulation.chartData) {
        LineMark($0.coordinates)
          .foregroundStyle(by: .value("Actor type", $0.actor))
      }
      ControlView()
    }
    .frame(minWidth: 500,
           idealWidth: 750,
           maxWidth: .infinity,
           minHeight: 500,
           idealHeight: 600,
           maxHeight: .infinity)
  }
}

struct WaveformView_Previews: PreviewProvider {
  static var previews: some View {
    WaveformView()
      .environmentObject(AppState())
  }
}

extension LineMark {
  init(_ point: Point) {
    self.init(x: .value("x", point.x), y: .value("y", point.y))
  }
}
