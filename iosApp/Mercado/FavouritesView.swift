import SwiftUI
import Shared

struct FavouritesView: View {
    @EnvironmentObject var state: AppState
    @State private var favourites: [Product] = []

    var body: some View {
        Group {
            if favourites.isEmpty {
                VStack {
                    Text("No favourites yet")
                        .foregroundColor(Theme.muted)
                        .padding(.top, 32)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(favourites, id: \.id) { product in
                            ProductRow(product: product)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.bg)
        .navigationTitle("My Favourites")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let ids = state.favourites.ids()
            favourites = state.catalog.active().filter { ids.contains($0.id) }
        }
    }
}
