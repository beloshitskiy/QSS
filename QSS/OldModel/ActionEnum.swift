//
//  Action.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

enum ActionEnum {
  case generateOrder
  case performOrder(with: Processor)
  case placeOrder(to: OldBuffer)
  case takeOrder(from: OldBuffer)
  case reject
}
