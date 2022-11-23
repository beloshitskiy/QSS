import SwiftUI

struct Menus: Commands {
  var body: some Commands {
    SidebarCommands()
    ToolbarCommands()
  }
}
