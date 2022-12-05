import Foundation
import SwiftCSVExport

final class SimulationExportResult {
  private let numberOfDevices: Int
  private let range: ClosedRange<Double>
  private let lambda: Double
  private let numberOfBuffers: Int
  private let averageRejectProbability: Double
  private let averageProcessingTime: Double
  private let averageUsageCoefficient: Double
  private let price: Double

  init(
    numberOfDevices: Int,
    range: ClosedRange<Double>,
    lambda: Double,
    numberOfBuffers: Int,
    averageRejectProbability: Double,
    totalTime: Double,
    averageUsageCoefficient: Double,
    price: Double
  ) {
    self.numberOfDevices = numberOfDevices
    self.range = range
    self.lambda = lambda
    self.numberOfBuffers = numberOfBuffers
    self.averageRejectProbability = averageRejectProbability
    self.averageProcessingTime = totalTime
    self.averageUsageCoefficient = averageUsageCoefficient
    self.price = price
  }
}

fileprivate let configurations = [
  982.94,
  1310.64,
  2621.27,
  3932.05,
]

enum SimulationExportResultFactory {
  public static func makeResult(
    numberOfDevices: Int,
    range: ClosedRange<Double>,
    lambda: Double,
    numberOfBuffers: Int,
    simulationResult: SimulationResult,
    configurationNumber: Int
  ) -> SimulationExportResult {
    SimulationExportResult(
      numberOfDevices: numberOfDevices,
      range: range,
      lambda: lambda,
      numberOfBuffers: numberOfBuffers,
      averageRejectProbability: simulationResult.generatorResults.map { $0.rejectProbability }
        .average,
      totalTime: simulationResult.generatorResults.map { $0.avProcessingTime }.average,
      averageUsageCoefficient: simulationResult.handlerResults.map { $0.usageCoefficient }
        .average,
      price: configurations[configurationNumber] * Double(numberOfDevices)
    )
  }
}

fileprivate let headers = [
  "Number of devices",
  "Range",
  "Lambda",
  "Buffer capacity",
  "Reject probability",
  "Average processing time",
  "Usage Coefficient",
  "Price",
]

extension SimulationExportResult {
  func convertToDict() -> NSMutableDictionary {
    let res = NSMutableDictionary()

    res.setObject(numberOfDevices, forKey: headers[0] as NSCopying)
    res.setObject(range.myDescription, forKey: headers[1] as NSCopying)
    res.setObject(lambda, forKey: headers[2] as NSCopying)
    res.setObject(numberOfBuffers, forKey: headers[3] as NSCopying)
    res.setObject(averageRejectProbability, forKey: headers[4] as NSCopying)
    res.setObject(averageProcessingTime, forKey: headers[5] as NSCopying)
    res.setObject(averageUsageCoefficient, forKey: headers[6] as NSCopying)
    res.setObject(price, forKey: headers[7] as NSCopying)

    return res
  }
}

extension [SimulationExportResult] {
  func export() {
    CSVExport.export.fileName = "SimulationResult"
    CSVExport.export.directory = "/Users/meinkognito/Downloads"
    CSVExport.export.enableStrictValidation = true

    let data = NSMutableArray()
    forEach { data.add($0.convertToDict()) }

    let writeCSVObj = CSV()
    writeCSVObj.rows = data
    writeCSVObj.delimiter = DividerType.comma.rawValue
    writeCSVObj.fields = headers as NSArray
    writeCSVObj.name = "SimulationResult"

    _ = CSVExport.export(writeCSVObj)
  }
}

fileprivate extension ClosedRange {
  var myDescription: String {
    "(\(lowerBound); \(upperBound))"
  }
}
