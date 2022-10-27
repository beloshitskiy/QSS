//
//  Simulation.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import DequeModule
import Foundation

class SimulationPerformer {
  init(proccesorsCount: Int, buffersCount: Int) {
    
    var pr = [Processor]()
    var bf = [Buffer]()
    
    for _ in 0 ..< proccesorsCount {
      pr.append(Processor())
    }
    
    for _ in 0 ..< buffersCount {
      bf.append(Buffer())
    }
    
    self.proccesors = pr
    self.buffers = bf
  }
  
  var ordersCount = 0
  
  private var currentCount = 0
 
  var deque = Deque<Action>()
  
  private let proccesors: [Processor]
  private var circlePointer = 0
  
  private let buffers: [Buffer]
  
  private let orderBin = OrderBin()
  
  func start() {
    currentCount = ordersCount
    deque.append(.generateOrder)
    
    while !deque.isEmpty {
      let action = deque.popLast()!
      
      if currentCount > 0 {
        deque.append(.generateOrder)
      }
      
      switch action {
        case .generateOrder: generateOrder()
        case .performOrder(let pr): performOrder(with: pr)
        case .placeOrder(let buf): placeOrder(to: buf)
        case .takeOrder(let buf): takeOrder(from: buf)
        case .reject: reject()
      }
    }
  }
  
  func stepStart() {
    currentCount = ordersCount
    deque.append(.generateOrder)
    
    let action = deque.popLast()!
    
    if currentCount > 0 {
      deque.append(.generateOrder)
    }
    
    switch action {
      case .generateOrder: generateOrder()
      case .performOrder(let pr): performOrder(with: pr)
      case .placeOrder(let buf): placeOrder(to: buf)
      case .takeOrder(let buf): takeOrder(from: buf)
      case .reject: reject()
    }
  }
  
  func step() {
    guard !deque.isEmpty else {
      print("DEBUG - no more actions")
      return
    }
    let action = deque.popLast()!
    
    if currentCount > 0 {
      deque.append(.generateOrder)
    }
    
    switch action {
      case .generateOrder: generateOrder()
      case .performOrder(let pr): performOrder(with: pr)
      case .placeOrder(let buf): placeOrder(to: buf)
      case .takeOrder(let buf): takeOrder(from: buf)
      case .reject: reject()
    }
  }
  
  private func generateOrder() {
    guard currentCount > 0 else { return }
    print("DEBUG - generateOrder")
    currentCount -= 1
    if let pr = optProcessor {
      deque.append(.performOrder(with: pr))
    } else {
      if let bf = optFreeBuffer {
        deque.append(.placeOrder(to: bf))
      } else {
        reject()
      }
    }
  }
  
  private func performOrder(with pr: Processor) {
    print("DEBUG - performOrder")
    pr.isBusy = true
  
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
      pr.isBusy = false

      if let buf = self?.buffers.first(where: { $0.isBusy }) {
        self?.deque.append(.takeOrder(from: buf))
      }
      
      print("no more busy")
    }
  }
  
  private func placeOrder(to buf: Buffer) {
    print("DEBUG - placeOrder")
    buf.isBusy = true
  }
  
  private func takeOrder(from buf: Buffer) {
    print("DEBUG - takeOrder")
    buf.isBusy = false
    
    if let pr = optProcessor {
      deque.append(.performOrder(with: pr))
    }
  }
  
  private func reject() {
    print("DEBUG - reject")
    orderBin.reject()
  }
  
  // MARK: - optional variables
  
  private var optProcessor: Processor? {
    guard !proccesors.allSatisfy({ $0.isBusy }) else { return nil }
    
    for i in circlePointer ..< proccesors.count where !proccesors[i].isBusy {
      circlePointer = i
      return proccesors[i]
    }
    
    for i in 0 ..< proccesors.count where !proccesors[i].isBusy {
      circlePointer = i
      return proccesors[i]
    }
    
    return nil
  }
  
  private var optFreeBuffer: Buffer? {
    guard !buffers.allSatisfy({ $0.isBusy }) else { return nil }
    
    for buf in buffers where !buf.isBusy {
      return buf
    }
    
    return nil
  }
}
