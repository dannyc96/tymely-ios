import SwiftUI

struct TabBarView: View {
    @State private var isMenuOpen = false
    
    var body: some View {
        TabView {
            DashboardView(isMenuOpen: $isMenuOpen)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.accent)
        .preferredColorScheme(.dark)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
} 