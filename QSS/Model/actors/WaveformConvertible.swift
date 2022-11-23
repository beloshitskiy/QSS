import Charts
import Foundation

protocol WaveformConvertible: Identifiable, Equatable {
  var chartData: [WaveformPoint] { get }

  var baseLine: Double { get }

  func makeStep(_ step: Step, stepWidth: Double, stepHeight: Double)

  static func == (lhs: Self, rhs: Self) -> Bool
}

// default realization of Equatable
extension WaveformConvertible {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}

// type of Waveform steps
enum Step: CaseIterable {
  case straight
  case up
  case down
}

// type of Waveform actors
enum Actor: String, Plottable {
  case generator = "Generators"
  case handler = "Handlers"
  case buffer = "Buffers"
  case rejector = "Rejector"
}

struct WaveformPoint: Identifiable {
  let id = UUID()
  var actor: Actor
  var coordinates: (x: Double, y: Double)

  var x: Double { coordinates.x }
  var y: Double { coordinates.y }

  init(_ actor: Actor, _ coordinates: (Double, Double)) {
    self.actor = actor
    self.coordinates = coordinates
  }
}
