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
      Chart {
        ForEach(appState.simulation.generators) { gen in
          ForEach(gen.chartData) {
            LineMark($0, str: num(gen))
              .foregroundStyle(by: .value("Actor", "Generators"))
          }
        }
        ForEach(appState.simulation.handlers) { han in
          ForEach(han.chartData) {
            LineMark($0, str: num(han))
              .foregroundStyle(by: .value("Actor", "Handlers"))
          }
        }
        ForEach(appState.simulation.buffers) { buf in
          ForEach(buf.chartData) {
            LineMark($0, str: num(buf))
              .foregroundStyle(by: .value("Actor", "Buffers"))
          }
        }
        ForEach(appState.simulation.rejector.chartData) {
          LineMark($0, str: "Rejector")
            .foregroundStyle(by: .value("Actor", "Rejector"))
        }
      }
      .chartYAxisLabel("Time passed")
      
      ControlView()
    }
    .padding()
    .frame(minWidth: 500,
           idealWidth: 750,
           maxWidth: .infinity,
           minHeight: 500,
           idealHeight: 600,
           maxHeight: .infinity)
  }

  private func num(_ actor: any WaveformConvertible) -> String {
    switch actor {
    case is Generator:
      return "Generator\(String(describing: appState.simulation.generators.firstIndex { $0 === actor as! Generator }))"
    case is Handler:
      return "Handler\(String(describing: appState.simulation.handlers.firstIndex { $0 === actor as! Handler }))"
    case is Buffer:
      return "Buffer\(String(describing: appState.simulation.buffers.firstIndex { $0 === actor as! Buffer }))"
    default: return ""
    }
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

  init(_ wPoint: WaveformPoint) {
    self.init(x: .value("x", wPoint.x),
              y: .value("y", wPoint.y),
              series: .value("Actor", wPoint.actor))
  }

  init(_ wPoint: WaveformPoint, str: String) {
    self.init(x: .value("x", wPoint.x),
              y: .value("y", wPoint.y),
              series: .value("Actor", str))
  }
}
