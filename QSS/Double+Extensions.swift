import Foundation

public var timeGenerationRange = 0.2 ... 1

// used for generating time with normal and logarithmic distribution
extension Double {
  static func generateTimeForAction(
    for actor: Actor,
    in range: ClosedRange<Double> = timeGenerationRange
  ) -> Double {
    let num = Double.random(in: range)
    switch actor {
      case .generator: return num
      default: return -log(1 - num)
    }
  }
}

// used for convenient calculating of average and "dispersion" values of elements
extension [Double] {
  var average: Double {
    guard !self.isEmpty else { return 0.0 }
    return self.reduce(0, +) / Double(self.count)
  }

  var dispersion: Double {
    guard let max = self.max(), let min = self.min() else { return 0.0 }
    return max - min
  }
}
