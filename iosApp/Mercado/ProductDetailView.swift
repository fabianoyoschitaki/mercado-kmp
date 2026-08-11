import SwiftUI
import Shared

struct ProductDetailView: View {
    @EnvironmentObject var state: AppState
    let productId: String
    @State private var qty = 1
    @State private var added = false
    @State private var fav = false

    private var product: Product? { Catalog.shared.product(id: productId) }

    var body: some View {
        ScrollView {
            if let product {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.icon)
                            .font(.system(size: 64))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Theme.bg)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        HStack {
                            Text(product.name)
                                .accessibilityIdentifier("detail-name")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Theme.text)
                            Spacer()
                            Button {
                                fav = MercadoStore.shared.toggleFavourite(productId: product.id)
                            } label: {
                                Text(fav ? "★" : "☆")
                                    .font(.system(size: 26))
                                    .foregroundColor(fav ? .orange : Theme.muted)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("detail-fav-star")
                            .accessibilityLabel(fav ? "favourited" : "favourite")
                        }
                        Text(formatPrice(product.price))
                            .accessibilityIdentifier("detail-price")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Theme.primary)
                        Text(product.description_)
                            .font(.system(size: 15))
                            .foregroundColor(Theme.text)
                        HStack {
                            Text(product.category)
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Theme.bg)
                                .clipShape(Capsule())
                            Text("Sold by \(product.sellerId == "s1" ? "Sunny Farms" : "Village Market")")
                                .font(.system(size: 13))
                                .foregroundColor(Theme.muted)
                        }
                    }
                    .modifier(CardStyle())

                    HStack(spacing: 10) {
                        Text("Quantity")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.muted)
                        Button("-") { qty = max(1, qty - 1) }
                            .accessibilityIdentifier("qty-minus")
                            .frame(width: 30, height: 30)
                            .background(Theme.card)
                            .overlay(Circle().stroke(Theme.border))
                            .clipShape(Circle())
                            .foregroundColor(Theme.text)
                        Text("\(qty)")
                            .accessibilityIdentifier("qty-value")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.text)
                        Button("+") { qty += 1 }
                            .accessibilityIdentifier("qty-plus")
                            .frame(width: 30, height: 30)
                            .background(Theme.card)
                            .overlay(Circle().stroke(Theme.border))
                            .clipShape(Circle())
                            .foregroundColor(Theme.text)
                        Spacer()
                        Text("Subtotal: \(formatPrice(product.price * Double(qty)))")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.text)
                    }

                    Button("Add to Cart") {
                        MercadoStore.shared.addToCart(productId: product.id, qty: Int32(qty))
                        state.refreshCart()
                        added = true
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    if added {
                        Text("Added to cart")
                            .accessibilityIdentifier("added-msg")
                            .foregroundColor(Theme.primary)
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .padding(16)
            } else {
                Text("Loading...")
                    .foregroundColor(Theme.muted)
                    .padding(.top, 48)
            }
        }
        .background(Theme.bg)
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fav = MercadoStore.shared.favouriteIds().contains(productId)
        }
    }
}
