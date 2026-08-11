import SwiftUI
import Shared

struct OrdersView: View {
    @EnvironmentObject var state: AppState
    @State private var orders: [Order] = []
    @State private var loading = true

    var body: some View {
        NavigationStack {
            Group {
                if loading && orders.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else if orders.isEmpty {
                    VStack {
                        Text("No orders yet")
                            .foregroundColor(Theme.muted)
                            .padding(.top, 32)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(orders, id: \.id) { order in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(formatDate(order.createdAt)) - R$ " + String(format: "%.2f", order.total))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Theme.text)
                                    Text(order.status.label)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Theme.primary)
                                    Text("\(order.items.count) item(s) to \(order.address)")
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.muted)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .modifier(CardStyle())
                            }
                        }
                    }
                }
            }
            .padding(16)
            .background(Theme.bg)
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear { load() }
    }

    private func load() {
        loading = true
        Task {
            orders = (try? await state.orders.history()) ?? []
            loading = false
        }
    }

}
