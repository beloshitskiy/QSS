//
//  Order.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

struct Order {
  init(priority: Int) {
    self.priority = priority
  }

  init() {
    self.priority = 0
  }

  let priority: Int
}
