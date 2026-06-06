import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            CatalogueView()
                .tabItem {
                    Label("Browse", systemImage: "books.vertical.fill")
                }
                .tag(1)
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
                .badge(cartViewModel.itemCount > 0 ? "\(cartViewModel.itemCount)" : nil)
                .tag(2)
            
            OrderHistoryView()
                .tabItem {
                    Label("Orders", systemImage: "list.bullet.rectangle.fill")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(Color(hex: "e94560"))
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartViewModel())
}
