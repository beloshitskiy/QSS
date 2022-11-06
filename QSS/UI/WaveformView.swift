//
//  LineChartView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI
import SwiftUICharts

struct WaveformView: View {
  @EnvironmentObject var appState: AppState
  var data: LineChartData

  var body: some View {
    VStack {
      LineChart(chartData: data)
        .xAxisLabels(chartData: data)
        .headerBox(chartData: data)
        .id(data.id)
        .frame(minWidth: 150,
               maxWidth: 900,
               minHeight: 25,
               idealHeight: 50,
               maxHeight: 50,
               alignment: .center)
        .padding(.horizontal)
    }
  }
}
