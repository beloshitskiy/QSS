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
    let sim = appState.simulation
    return VStack {
      Chart {
        ForEach(sim.generators) { generator in
          ForEach(generator.chartData) {
            LineMark($0, of: num(generator))
              .foregroundStyle(by: .value("Actor", "Generators"))
          }
        }
        ForEach(sim.handlers) { handler in
          ForEach(handler.chartData) {
            LineMark($0, of: num(handler))
              .foregroundStyle(by: .value("Actor", "Handlers"))
          }
        }
        ForEach(sim.buffers) { buffer in
          ForEach(buffer.chartData) {
            LineMark($0, of: num(buffer))
              .foregroundStyle(by: .value("Actor", "Buffers"))
          }
        }
        ForEach(sim.rejector.chartData) {
          LineMark($0, of: "Rejector")
            .foregroundStyle(by: .value("Actor", "Rejector"))
        }
      }
      .chartYAxisLabel("Time passed")
      .chartYAxis {
        AxisMarks(values: .stride(by: sim.inset)) {
          let value = $0.as(Double.self) ?? 0.0
          AxisGridLine()
          AxisValueLabel {
            Text(getHandler(by: value))
          }
        }
      }

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
    let sim = appState.simulation
    switch actor {
    case is Generator:
      return "Generator\(sim.generators.firstIndex { $0 === actor as? Generator } ?? 0)"
    case is Handler:
      return "Handler\(sim.handlers.firstIndex { $0 === actor as? Handler } ?? 0)"
    case is Buffer:
      return "Buffer\(sim.buffers.firstIndex { $0 === actor as? Buffer } ?? 0)"
    default: return ""
    }
  }

  private func getHandler(by inset: Double, defaultInset: Double = 1.5) -> String {
    let sim = appState.simulation

    switch inset {
    case 0: return "Rejector"

    // Buffers
    case sim.buffers[0].baseLine ..< sim.handlers[0].baseLine:
      let cur = sim.buffers[0].baseLine
      for i in 0 ..< sim.buffersCount where cur + (defaultInset * Double(i)) == inset {
        return "Buffer №\(i + 1)"
      }

    // Handlers
    case sim.handlers[0].baseLine ..< sim.generators[0].baseLine:
      let cur = sim.handlers[0].baseLine
      for i in 0 ..< sim.handlersCount where cur + (defaultInset * Double(i)) == inset {
        return "Handler №\(i + 1)"
      }

    // Generators
    case sim.generators[0].baseLine ..< sim.generators[0].baseLine + Double(sim.generatorsCount) * defaultInset:
      let cur = sim.generators[0].baseLine
      for i in 0 ..< sim.generatorsCount where cur + (defaultInset * Double(i)) == inset {
        return "Generator №\(i + 1)"
      }
    default:
      return ""
    }
    return ""
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
