//
//  WaveformView.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import SwiftUI

struct WaveformView: View {
  @EnvironmentObject var appState: AppState
    var body: some View {
      VStack {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        ControlView(mode: .manual)
      }
    }
}

struct WaveformView_Previews: PreviewProvider {
    static var previews: some View {
        WaveformView()
    }
}
