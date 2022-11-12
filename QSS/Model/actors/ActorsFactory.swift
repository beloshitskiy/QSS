//
//  ActorsFactory.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation

final class ActorsFactory {
  public static func makeActors(generatorsCount: Int,
                                handlersCount: Int,
                                buffersCount: Int,
                                baseLine: Double = 0.0,
                                inset: Double = 1.5)
    -> (generators: [Generator], handlers: [Handler], buffers: [Buffer], rejector: Rejector)
  {
    var generators = [Generator]()
    var handlers = [Handler]()
    var buffers = [Buffer]()

    var baseLine = baseLine
    let step = 0.0

    for _ in 0 ..< buffersCount {
      baseLine += inset
      let buffer = Buffer(baseLine: baseLine)
      buffers.append(buffer)
      buffer.makeStep(stepWidth: step)
    }

    for _ in 0 ..< handlersCount {
      baseLine += inset
      let handler = Handler(baseLine: baseLine)
      handlers.append(handler)
      handler.makeStep(stepWidth: step)
    }

    for _ in 0 ..< generatorsCount {
      baseLine += inset
      let generator = Generator(baseLine: baseLine)
      generators.append(generator)
      generator.makeStep(stepWidth: step)
    }

    return (generators, handlers, buffers, Rejector())
  }
}
