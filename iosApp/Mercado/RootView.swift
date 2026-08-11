import SwiftUI

// The whole app is gated behind login, same as the RN RootNavigator.
struct RootView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        if state.user == nil {
            LoginView()
        } else {
            MainTabs()
        }
    }
}

struct MainTabs: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            CartView()
                .tabItem { Label("Cart", systemImage: "cart") }
                .badge(state.cartCount > 0 ? "\(state.cartCount)" : nil)
            OrdersView()
                .tabItem { Label("Orders", systemImage: "shippingbox") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
        .tint(Theme.primary)
    }
}
