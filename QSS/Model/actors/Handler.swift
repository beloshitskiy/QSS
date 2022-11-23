import Foundation

final class Handler: WaveformConvertible {
  let id = UUID()
  
  var isBusy: Bool
  var usageTime: Double
  var handledOrdersCount: Int
  
  init(baseLine: Double) {
    isBusy = false
    usageTime = 0.0
    handledOrdersCount = 0
    self.baseLine = baseLine
    chartData = []
  }
  
  // WaveformConvertible conformance
  let baseLine: Double
  private(set) var chartData: [WaveformPoint]
  
  func makeStep(_ step: Step = .straight, stepWidth: Double, stepHeight: Double = 1.0) {
    let up = WaveformPoint(.handler, (x: stepWidth, y: baseLine + stepHeight))
    let down = WaveformPoint(.handler, (x: stepWidth, y: baseLine))
    
    guard let lastPoint = chartData.last else {
      chartData.append(down)
      return
    }
    
    let newPoint: WaveformPoint
    switch step {
      case .straight: newPoint = lastPoint.y == up.y ? up : down
      case .up: newPoint = up
      case .down:
        newPoint = down
        handledOrdersCount += 1
    }
    
    chartData.append(newPoint)
  }
}
