//
//  OrderBin.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

final class OrderBin {
  private(set) var rejectedCount = 0

  func reject() {
    rejectedCount += 1
  }
}
