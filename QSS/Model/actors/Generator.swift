import Foundation

final class Generator: WaveformConvertible {
  let id = UUID()
  let priority: Int

  // for correct time usage
  var remainingActions: Int
  var lastActionTimestamp: Double

  // for choosing buffer
  var circlePointer: Array.Index

  var isEmpty: Bool { remainingActions == 0 }

  // for TableView report
  var acceptedOrders: Int
  var rejectedRequests: Int
  var totalOrders: Int

  var inBufferTimes: [Double]
  var handlingTimes: [Double]

  init(priority: Int, baseLine: Double) {
    self.priority = priority
    remainingActions = 0
    lastActionTimestamp = 0.0
    circlePointer = 0
    rejectedRequests = 0
    acceptedOrders = 0
    totalOrders = 0
    inBufferTimes = []
    handlingTimes = []
    self.baseLine = baseLine
    chartData = []
  }

  // WaveformConvertible conformance
  let baseLine: Double
  private(set) var chartData: [WaveformPoint]

  func makeStep(_ step: Step = .straight, stepWidth: Double, stepHeight: Double = 1.0) {
    let up = WaveformPoint(.generator, (x: stepWidth, y: baseLine + stepHeight))
    let down = WaveformPoint(.generator, (x: stepWidth, y: baseLine))

    guard let lastPoint = chartData.last else {
      chartData.append(down)
      return
    }

    let newPoint: WaveformPoint
    switch step {
      case .straight: newPoint = lastPoint.y == up.y ? up : down
      case .up:
        newPoint = up
        remainingActions -= 1
      case .down: newPoint = down
    }

    chartData.append(newPoint)
  }
}
