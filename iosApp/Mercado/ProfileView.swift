import SwiftUI
import Shared

struct ProfileView: View {
    @EnvironmentObject var state: AppState
    @State private var goFavourites = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                if let user = state.user {
                    Text(user.name)
                        .accessibilityIdentifier("profile-name")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Theme.text)
                    Text(user.email)
                        .accessibilityIdentifier("profile-email")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.muted)
                        .padding(.bottom, 8)
                    Button("My Favourites") { goFavourites = true }
                        .buttonStyle(OutlineButtonStyle())
                    Button("Log Out") { state.logout() }
                        .buttonStyle(PrimaryButtonStyle(background: Theme.danger))
                }
                Spacer()
            }
            .padding(16)
            .background(Theme.bg)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $goFavourites) {
                FavouritesView()
            }
        }
    }
}
