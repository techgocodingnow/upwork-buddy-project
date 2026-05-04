import Foundation

struct CurrencyFormat: Sendable {
    let code: String

    private func formatter(fractionDigits: Int) -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = code
        f.maximumFractionDigits = fractionDigits
        f.minimumFractionDigits = fractionDigits
        return f
    }

    func string(_ amount: Double) -> String {
        formatter(fractionDigits: 2).string(from: NSNumber(value: amount)) ?? "—"
    }

    func compact(_ amount: Double) -> String {
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
