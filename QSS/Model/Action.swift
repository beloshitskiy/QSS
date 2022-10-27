//
//  Action.swift
//  QSS
//
//  Created by Denis Beloshitskiy on 10/25/22.
//

import Foundation

enum Action {
  case generateOrder
  case performOrder(with: Processor)
  case placeOrder(to: Buffer)
  case takeOrder(from: Buffer)
  case reject
}
