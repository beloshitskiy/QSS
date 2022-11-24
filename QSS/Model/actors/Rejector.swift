import Foundation

final class Rejector: WaveformConvertible {
  let id = UUID()

  // WaveformConvertible conformance
  let baseLine = 0.0
  private(set) var chartData = [WaveformPoint]()

  func makeStep(_ step: Step = .straight, stepWidth: Double, stepHeight: Double = 1.0) {
    let up = WaveformPoint(.rejector, (x: stepWidth, y: baseLine + stepHeight))
    let down = WaveformPoint(.rejector, (x: stepWidth, y: baseLine))

    guard let lastPoint = chartData.last else {
      chartData.append(down)
      return
    }

    let newPoint: WaveformPoint
    switch step {
      case .straight: newPoint = lastPoint.y == up.y ? up : down
      case .up: newPoint = up
      case .down: newPoint = down
    }

    chartData.append(newPoint)
  }
}
