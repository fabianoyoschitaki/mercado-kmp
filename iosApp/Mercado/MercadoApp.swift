import SwiftUI
import Shared

// App-wide observable state over the shared Kotlin repositories. Kotlin owns
// the business rules (and the fake-network latency); this layer owns
// publishing state to SwiftUI.
@MainActor
final class AppState: ObservableObject {
    @Published var user: User?
    @Published var cartCount: Int = 0

    let catalog = AppContainer.shared.catalog
    let auth = AppContainer.shared.auth
    let cart = AppContainer.shared.cart
    let orders = AppContainer.shared.orders
    let favourites = AppContainer.shared.favourites

    init() {
        user = auth.currentSession()
        refreshCart()
    }

    func login(email: String, password: String) async throws {
        user = try await auth.login(email: email, password: password)
    }

    func logout() {
        auth.logout()
        user = nil
    }

    func refreshCart() {
        cartCount = Int(cart.itemCount())
    }
}

@main
struct MercadoApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
        }
    }
}
