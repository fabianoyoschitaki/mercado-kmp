import SwiftUI
import Shared

// App-wide observable state over the shared Kotlin core (MercadoStore).
// The Kotlin side owns the business rules; this class owns async + publishing.
@MainActor
final class AppState: ObservableObject {
    @Published var user: User?
    @Published var cartCount: Int = 0

    init() {
        user = MercadoStore.shared.sessionUser()
        refreshCart()
    }

    func login(email: String, password: String) async throws {
        // auth roundtrip is the slowest call in the app, like in production
        try await Task.sleep(nanoseconds: 700_000_000)
        user = try MercadoStore.shared.login(email: email, password: password)
    }

    func logout() {
        MercadoStore.shared.logout()
        user = nil
    }

    func refreshCart() {
        cartCount = Int(MercadoStore.shared.cartCount())
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
