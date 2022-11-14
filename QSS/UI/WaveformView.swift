//
//  WaveformView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Charts
import SwiftUI

struct WaveformView: View {
  @EnvironmentObject var appState: AppState
  var body: some View {
    VStack {
      Chart {
        ForEach(appState.simulation.generators) { generator in
          ForEach(generator.chartData) {
            LineMark($0, of: num(generator))
              .foregroundStyle(by: .value("Actor", "Generators"))
          }
        }
        ForEach(appState.simulation.handlers) { handler in
          ForEach(handler.chartData) {
            LineMark($0, of: num(handler))
              .foregroundStyle(by: .value("Actor", "Handlers"))
          }
        }
        ForEach(appState.simulation.buffers) { buffer in
          ForEach(buffer.chartData) {
            LineMark($0, of: num(buffer))
              .foregroundStyle(by: .value("Actor", "Buffers"))
          }
        }
        ForEach(appState.simulation.rejector.chartData) {
          LineMark($0, of: "Rejector")
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
      return "Generator\(appState.simulation.generators.firstIndex { $0 === actor as? Generator } ?? 0)"
    case is Handler:
      return "Handler\(appState.simulation.handlers.firstIndex { $0 === actor as? Handler } ?? 0)"
    case is Buffer:
      return "Buffer\(appState.simulation.buffers.firstIndex { $0 === actor as? Buffer } ?? 0)"
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
  init(_ point: WaveformPoint, of actor: String) {
    self.init(x: .value("x", point.x),
              y: .value("y", point.y),
              series: .value("Actor", actor))
  }
}
