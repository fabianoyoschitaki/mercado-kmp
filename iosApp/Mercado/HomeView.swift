import SwiftUI
import Shared

struct HomeView: View {
    @EnvironmentObject var state: AppState
    @State private var query = ""
    @State private var category: Shared.Category?
    @State private var products: [Product] = []
    @State private var loading = true
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Free delivery this week!")
                    .accessibilityIdentifier("promo-banner")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0x92 / 255, green: 0x40 / 255, blue: 0x0E / 255))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(Color(red: 0xFE / 255, green: 0xF3 / 255, blue: 0xC7 / 255))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radius))

                TextField("Search products", text: $query)
                    .accessibilityIdentifier("search-input")
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(12)
                    .background(Theme.card)
                    .overlay(RoundedRectangle(cornerRadius: Theme.radius).stroke(Theme.border))

                HStack(spacing: 8) {
                    ForEach(state.catalog.categories, id: \.self) { c in
                        let selected = category == c
                        Button(selected ? "[\(c.name)]" : c.name) {
                            category = selected ? nil : c
                            search()
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(selected ? .white : Theme.muted)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selected ? Theme.primary : Theme.card)
                        .overlay(Capsule().stroke(Theme.border))
                        .clipShape(Capsule())
                    }
                }

                if loading && products.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else if products.isEmpty {
                    Text("No products found")
                        .foregroundColor(Theme.muted)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(products, id: \.id) { product in
                                NavigationLink(value: product.id) {
                                    ProductRow(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(16)
            .background(Theme.bg)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("🛒 Mercado")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Theme.primary)
                }
            }
            .navigationDestination(for: String.self) { productId in
                ProductDetailView(productId: productId)
            }
        }
        .onAppear { search() }
        .onChange(of: query) { _, _ in search() }
    }

    private func search() {
        searchTask?.cancel()
        loading = true
        searchTask = Task {
            // latency lives in the Kotlin repository, like a real client
            let result = (try? await state.catalog.search(query: query, category: category)) ?? []
            if Task.isCancelled { return }
            products = result
            loading = false
        }
    }
}

struct ProductRow: View {
    @EnvironmentObject var state: AppState
    let product: Product
    @State private var fav = false

    var body: some View {
        HStack(spacing: 12) {
            Text(product.icon)
                .font(.system(size: 28))
                .frame(width: 52, height: 52)
                .background(Theme.bg)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.text)
                Text(formatPrice(product.price))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.primary)
            }
            Spacer()
            Button {
                fav = state.favourites.toggle(productId: product.id)
            } label: {
                Text(fav ? "★" : "☆")
                    .font(.system(size: 22))
                    .foregroundColor(fav ? .orange : Theme.muted)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("favourite")
        }
        .modifier(CardStyle())
        .onAppear { fav = state.favourites.contains(productId: product.id) }
    }
}
