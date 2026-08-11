import SwiftUI
import Shared

struct CartView: View {
    @EnvironmentObject var state: AppState
    @State private var items: [CartItem] = []
    @State private var goCheckout = false

    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    VStack {
                        Text("Your cart is empty")
                            .foregroundColor(Theme.muted)
                            .padding(.top, 32)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(items, id: \.product.id) { item in
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("\(item.product.icon) \(item.product.name)")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Theme.text)
                                        Text("\(formatPrice(item.product.price)) x \(item.qty)")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Theme.primary)
                                        Button("Remove") {
                                            MercadoStore.shared.removeFromCart(productId: item.product.id)
                                            refresh()
                                        }
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.muted)
                                        .buttonStyle(.plain)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .modifier(CardStyle())
                                }
                            }
                        }
                        Text("Total: R$ " + String(format: "%.2f", MercadoStore.shared.cartTotal()))
                            .accessibilityIdentifier("cart-total")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.text)
                            .padding(.vertical, 8)
                        Button("Checkout") { goCheckout = true }
                            .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
            .padding(16)
            .background(Theme.bg)
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $goCheckout) {
                CheckoutView(onPlaced: { refresh() })
            }
        }
        .onAppear { refresh() }
    }

    private func refresh() {
        items = MercadoStore.shared.cartItems()
        state.refreshCart()
    }
}
