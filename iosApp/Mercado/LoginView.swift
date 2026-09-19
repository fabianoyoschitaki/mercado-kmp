import SwiftUI

struct LoginView: View {
    @EnvironmentObject var state: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var error = ""
    @State private var busy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 4) {
                Text("🛒 Mercado")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.primary)
                Text("Fresh groceries, delivered")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.muted)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 32)

            Text("Email")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.muted)
                .padding(.bottom, 4)
            TextField("", text: $email)
                .accessibilityIdentifier("email-input")
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .padding(12)
                .background(Theme.card)
                .overlay(RoundedRectangle(cornerRadius: Theme.radius).stroke(Theme.border))
                .padding(.bottom, 12)

            Text("Password")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.muted)
                .padding(.bottom, 4)
            SecureField("", text: $password)
                .accessibilityIdentifier("password-input")
                .padding(12)
                .background(Theme.card)
                .overlay(RoundedRectangle(cornerRadius: Theme.radius).stroke(Theme.border))
                .padding(.bottom, 12)

            if !error.isEmpty {
                Text(error)
                    .accessibilityIdentifier("login-error")
                    .foregroundColor(Theme.danger)
                    .padding(.bottom, 8)
            }

            Button("Log In") { onLogin() }
                .buttonStyle(PrimaryButtonStyle())
                .accessibilityIdentifier("login-button")

            if busy {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
            }
            Spacer()
        }
        .padding(16)
        .padding(.top, 32)
        .background(Theme.bg)
    }

    private func onLogin() {
        if busy { return }
        busy = true
        error = ""
        Task {
            do {
                try await state.login(email: email, password: password)
            } catch {
                self.error = "Email or password is incorrect. Please try again."
            }
            busy = false
        }
    }
}

// impact@1 proof: a touch on the login screen (2026-09-19)
// impact-v2 prompt cache proof: a second touch on the login screen (2026-09-19)
