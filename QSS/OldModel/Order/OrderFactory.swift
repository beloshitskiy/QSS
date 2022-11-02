//
//  OrderFactory.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import DequeModule
import Foundation

class OrderFactory {
  private let ordersCount: Int
  private let sourcesCount: Int

  init(ordersCount: Int, sourcesCount: Int) {
    self.ordersCount = ordersCount
    self.sourcesCount = sourcesCount
  }

  private func makeOrder(withSource priority: Int) -> Order {
    return Order(priority: priority)
  }

  public func makeOrders() -> Deque<Order> {
    var orders = Deque<Order>()
    orders.reserveCapacity(ordersCount)
    for _ in 0 ..< ordersCount {
      let source = Int.random(in: 0 ..< sourcesCount) // выбираем источник
      orders.append(makeOrder(withSource: source))
    }
    return orders
  }
}
