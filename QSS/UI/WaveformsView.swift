//
//  WaveformView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI
import SwiftUICharts

struct WaveformsView: View {
  @EnvironmentObject var appState: AppState
  var body: some View {
    VStack {
      ForEach(appState.simulation.generators) { gen in
        let data = LineChartData(dataSets:
          LineDataSet(dataPoints: gen.chartPoints,
                      style: LineStyle(lineColour: generatorColor)))
        WaveformView(data: data)
      }
      ForEach(appState.simulation.handlers) { han in
        let data = LineChartData(dataSets:
          LineDataSet(dataPoints: han.chartPoints,
                      style: LineStyle(lineColour: handlerColor)))
        WaveformView(data: data)
      }
      ForEach(appState.simulation.buffers) { buf in
        let data = LineChartData(dataSets:
          LineDataSet(dataPoints: buf.chartPoints,
                      style: LineStyle(lineColour: bufferColor)))
        WaveformView(data: data)
      }

      let data = LineChartData(dataSets:
        LineDataSet(dataPoints: appState.simulation.rejector.chartPoints,
                    style: LineStyle(lineColour: rejectorColor)))
      WaveformView(data: data)

      ControlView()
    }
  }
}

struct WaveformView_Previews: PreviewProvider {
  static var previews: some View {
    WaveformsView()
  }
}

private let generatorColor = ColourStyle(colour: Color.red)
private let handlerColor = ColourStyle(colour: Color.green)
private let bufferColor = ColourStyle(colour: Color.blue)
private let rejectorColor = ColourStyle(colour: Color.orange)
