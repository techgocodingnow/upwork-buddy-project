import Testing
import Foundation
@testable import UpworkBuddy

@Suite("CurrencyFormat")
struct CurrencyFormatTests {

    /// Decimal separator from a USD NumberFormatter — host locale may use "," or ".".
    private static let dec: String = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "USD"
        return f.decimalSeparator ?? "."
    }()

    @Test func stringRendersTwoFractionDigits() {
        let f = CurrencyFormat(code: "USD")
        let out = f.string(1234.5)
        #expect(out.contains("1234") || out.contains("1,234") || out.contains("1.234"))
        #expect(out.contains("50"))
        // Some locales use "US$" for USD code — still contains "$".
        #expect(out.contains("$"))
    }

    @Test func stringMaskedContainsMaskGlyph() {
        let f = CurrencyFormat(code: "USD", masked: true)
        let out = f.string(9999)
        #expect(out.contains(CurrencyFormat.maskGlyph))
        #expect(out.contains("$"))
    }

    @Test func compactUsesTwoDigitsBelow100() {
        let f = CurrencyFormat(code: "USD")
        let out = f.compact(42.5)
        #expect(out.contains("42" + Self.dec + "50"))
    }

    @Test func compactUsesTwoDigitsForSubDollar() {
        let f = CurrencyFormat(code: "USD")
        let out = f.compact(0.42)
        #expect(out.contains("42"))
        // Sub-dollar has 2 fraction digits — must contain a decimal separator.
        #expect(out.contains(Self.dec))
    }

    @Test func compactDropsDigitsAtOrAbove100() {
        let f = CurrencyFormat(code: "USD")
        let out = f.compact(150.99)
        // 0 fraction digits => no decimal-separator-followed-by-digits
        #expect(!out.contains(Self.dec + "99"))
        #expect(out.contains("151") || out.contains("150"))
    }

    @Test func compactNegativeRespectsAbsValue() {
        let f = CurrencyFormat(code: "USD")
        let out = f.compact(-150)
        // |x| >= 100 → 0 fraction digits
        #expect(!out.contains(Self.dec + "00"))
    }

    @Test func nonUSDCurrencyRespectsCode() {
        let f = CurrencyFormat(code: "EUR")
        let out = f.string(10)
        #expect(out.contains("€") || out.contains("EUR"))
    }

    @Test func maskedCompactMatchesMaskedString() {
        let f = CurrencyFormat(code: "USD", masked: true)
        #expect(f.compact(123_456) == f.string(123_456))
    }

    // MARK: - Double.asHours()

    @Test func asHoursBelowThresholdIsZero() {
        #expect((0.0).asHours() == "0h")
        #expect((0.04).asHours() == "0h")
    }

    @Test func asHoursMinutesOnly() {
        // 0.5h == 30m, hours==0 path
        #expect((0.5).asHours() == "30m")
    }

    @Test func asHoursWholeHours() {
        // minutes==0 path
        #expect((3.0).asHours() == "3h")
    }

    @Test func asHoursCombined() {
        // 2.5h == 2h 30m
        #expect((2.5).asHours() == "2h 30m")
    }

    @Test func asHoursTruncatesPartialMinutes() {
        // 1.99h == 1h 59m (Int truncation)
        let s = (1.99).asHours()
        #expect(s == "1h 59m")
    }
}
