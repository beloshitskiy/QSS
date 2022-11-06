//
//  Menus.swift
//  QSS
//
//  Created by Denis Beloshitskiy
//

import Foundation
import SwiftUI

struct Menus: Commands {
  var body: some Commands {
    SidebarCommands()
    ToolbarCommands()
  }
}
