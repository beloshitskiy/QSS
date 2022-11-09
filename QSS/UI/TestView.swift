//
//  TestView.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 11/9/22.
//

import Charts
import SwiftUI

public class MyClass: ObservableObject {
  @Published var data = [WaveformPoint(.generator, .init(x: 0.0, y: 0.0))]
}

private let tick = [
  (Actor.generator, Point(x: 0.0, y: 0.0)),
  (Actor.generator, Point(x: 1.0, y: 0.0)),
  (Actor.generator, Point(x: 1.0, y: 1.0)),
  (Actor.generator, Point(x: 2.0, y: 1.0)),
  (Actor.generator, Point(x: 2.0, y: 0.0)),
  (Actor.generator, Point(x: 3.0, y: 0.0)),
].map { WaveformPoint($0.0, $0.1) }

struct TestView: View {
//  @EnvironmentObject var appState: AppState
  @EnvironmentObject var myClass: MyClass
  @State private var counter = 0
//  @State private var data = [WaveformPoint(.generator, .init(x: 0.0, y: 0.0))]
  var body: some View {
    VStack {
      Chart(myClass.data) {
        LineMark($0.coordinates)
      }

      Button {
        withAnimation {
          if counter > 5 {
            counter %= 5
          }
          myClass.data.append(tick[counter])
          counter += 1
        }
      } label: {
        Text("press")
      }
    }
  }
}

struct TestView_Previews: PreviewProvider {
  static var previews: some View {
    TestView()
      .environmentObject(MyClass())
  }
}
