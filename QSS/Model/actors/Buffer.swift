import Foundation

final class Buffer: WaveformConvertible {
  let id = UUID()
  
  var waitingFrom: Double
  var currentGenerator: Generator?
  var isBusy: Bool { currentGenerator != nil }
  
  init(baseLine: Double) {
    currentGenerator = nil
    waitingFrom = 0.0
    self.baseLine = baseLine
    chartData = []
  }
  
  // WaveformConvertible conformance
  let baseLine: Double
  private(set) var chartData: [WaveformPoint]
  
  func makeStep(_ step: Step = .straight, stepWidth: Double, stepHeight: Double = 1.0) {
    let up = WaveformPoint(.buffer, (x: stepWidth, y: baseLine + stepHeight))
    let down = WaveformPoint(.buffer, (x: stepWidth, y: baseLine))
    
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
