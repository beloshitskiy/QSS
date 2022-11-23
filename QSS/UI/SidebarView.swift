import SwiftUI

struct SidebarView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    List(selection: $appState.appMode) {
      Section {
        ForEach(AppMode.allCases, id: \.self) {
          Text($0.rawValue)
        }
      } header: {
        Text("Mode")
      }
    }
    .disabled(appState.ordersCount > 500)
    .listStyle(.sidebar)
  }
}

struct SidebarView_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView()
      .environmentObject(AppState())
      .preferredColorScheme(.dark)
      .frame(width: 200)
  }
}
