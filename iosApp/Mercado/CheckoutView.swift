import SwiftUI
import Shared

struct CheckoutView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) private var dismiss
    var onPlaced: () -> Void = {}

    @State private var address = ""
    @State private var error = ""
    @State private var placing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Items: \(MercadoStore.shared.cartItems().count)")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.muted)
                Text("Order total: R$ " + String(format: "%.2f", MercadoStore.shared.cartTotal()))
                    .accessibilityIdentifier("checkout-total")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.text)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .modifier(CardStyle())

            Text("Delivery address")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.muted)
            TextField("Street, number", text: $address)
                .accessibilityIdentifier("address-input")
                .padding(12)
                .background(Theme.card)
                .overlay(RoundedRectangle(cornerRadius: Theme.radius).stroke(Theme.border))

            if !error.isEmpty {
                Text(error)
                    .accessibilityIdentifier("checkout-error")
                    .foregroundColor(Theme.danger)
            }

            Button("Place Order") { onPlaceOrder() }
                .buttonStyle(PrimaryButtonStyle())

            if placing {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
            }
            Spacer()
        }
        .padding(16)
        .background(Theme.bg)
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func onPlaceOrder() {
        if placing { return }
        if address.trimmingCharacters(in: .whitespaces).isEmpty {
            error = "Delivery address is required"
            return
        }
        placing = true
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            _ = MercadoStore.shared.placeOrder(
                address: address.trimmingCharacters(in: .whitespaces),
                nowMillis: Int64(Date().timeIntervalSince1970 * 1000))
            state.refreshCart()
            placing = false
            onPlaced()
            dismiss()
        }
    }
}
