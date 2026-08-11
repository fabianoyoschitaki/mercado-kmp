import SwiftUI

// Mirror of the RN app's theme.ts
enum Theme {
    static let primary = Color(red: 0x2E / 255, green: 0x7D / 255, blue: 0x32 / 255)
    static let bg = Color(red: 0xF6 / 255, green: 0xF7 / 255, blue: 0xF9 / 255)
    static let card = Color.white
    static let text = Color(red: 0x11 / 255, green: 0x18 / 255, blue: 0x27 / 255)
    static let muted = Color(red: 0x6B / 255, green: 0x72 / 255, blue: 0x80 / 255)
    static let border = Color(red: 0xE5 / 255, green: 0xE7 / 255, blue: 0xEB / 255)
    static let danger = Color(red: 0xDC / 255, green: 0x26 / 255, blue: 0x26 / 255)
    static let radius: CGFloat = 12
}

func formatPrice(_ value: Double) -> String {
    "R$ " + String(format: "%.2f", value)
}

func formatDate(_ ts: Int64) -> String {
    let d = Date(timeIntervalSince1970: Double(ts) / 1000)
    let c = Calendar.current.dateComponents([.day, .month, .year], from: d)
    return "\(c.day ?? 0)/\(c.month ?? 0)/\(c.year ?? 0)"
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(Theme.card)
            .overlay(RoundedRectangle(cornerRadius: Theme.radius).stroke(Theme.border))
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var background: Color = Theme.primary
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(background.opacity(configuration.isPressed ? 0.85 : 1))
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(Theme.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.card.opacity(configuration.isPressed ? 0.7 : 1))
            .overlay(RoundedRectangle(cornerRadius: Theme.radius).stroke(Theme.primary))
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius))
    }
}
