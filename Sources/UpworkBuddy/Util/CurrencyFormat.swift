import Foundation

struct CurrencyFormat: Sendable {
    let code: String
    var masked: Bool = false

    static let maskGlyph = "••••"

    private func formatter(fractionDigits: Int) -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = code
        f.maximumFractionDigits = fractionDigits
        f.minimumFractionDigits = fractionDigits
        return f
    }

    private func maskedString() -> String {
        let symbol = formatter(fractionDigits: 0).currencySymbol ?? ""
        return symbol + Self.maskGlyph
    }

    func string(_ amount: Double) -> String {
        if masked { return maskedString() }
        return formatter(fractionDigits: 2).string(from: NSNumber(value: amount)) ?? "—"
    }

    func compact(_ amount: Double) -> String {
        if masked { return maskedString() }
        let digits = abs(amount) < 1 ? 2 : (abs(amount) < 100 ? 2 : 0)
        return formatter(fractionDigits: digits).string(from: NSNumber(value: amount)) ?? "—"
    }
}

extension Double {
    func asHours() -> String {
        if self < 0.05 { return "0h" }
        let hours = Int(self)
        let minutes = Int((self - Double(hours)) * 60)
        if hours == 0 { return "\(minutes)m" }
        if minutes == 0 { return "\(hours)h" }
        return "\(hours)h \(minutes)m"
    }
}
