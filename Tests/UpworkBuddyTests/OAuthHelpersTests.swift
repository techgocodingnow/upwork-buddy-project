import Testing
import Foundation
import CryptoKit
@testable import UpworkBuddy

@Suite("OAuthClient helpers")
struct OAuthHelpersTests {

    // MARK: - formEncode

    @Test func formEncodeBasicPair() {
        let out = OAuthClient.formEncode(["a": "1"])
        #expect(out == "a=1")
    }

    @Test func formEncodeJoinsWithAmpersand() {
        let out = OAuthClient.formEncode(["a": "1", "b": "2"])
        // Dictionary order non-deterministic; check both halves present.
        #expect(out.split(separator: "&").count == 2)
        #expect(out.contains("a=1"))
        #expect(out.contains("b=2"))
    }

    @Test func formEncodePercentEncodesReservedChars() {
        // form-urlencoded must escape every byte outside RFC 3986 unreserved
        // [A-Za-z0-9-._~]. `&`, `=`, `+`, `:`, `/` all encode.
        let out = OAuthClient.formEncode(["k": "a b&c"])
        #expect(out.contains("a%20b%26c"))
    }

    @Test func formEncodeEscapesUrlInValue() {
        let out = OAuthClient.formEncode(["redirect_uri": "upworkbuddy://callback"])
        #expect(out.contains("upworkbuddy%3A%2F%2Fcallback"))
    }

    @Test func formEncodePreservesUnreserved() {
        let out = OAuthClient.formEncode(["k": "Abc-123._~"])
        #expect(out == "k=Abc-123._~")
    }

    @Test func formEncodeHandlesEmpty() {
        #expect(OAuthClient.formEncode([:]) == "")
    }

    // MARK: - base64URL

    @Test func base64URLReplacesPlusSlashEqual() {
        // Pick bytes that produce +, /, and trailing = in standard base64.
        let raw = Data([0xfb, 0xff, 0xbf]) // base64 → "+/+/" (no =)
        let std = raw.base64EncodedString()
        let url = OAuthClient.base64URL(raw)
        // `+` and `/` removed in url-safe form.
        #expect(!url.contains("+"))
        #expect(!url.contains("/"))
        #expect(!url.contains("="))
        // Same length minus padding.
        let stdNoPad = std.replacingOccurrences(of: "=", with: "")
        #expect(url.count == stdNoPad.count)
    }

    @Test func base64URLStripsAllEqualsPadding() {
        // "f" → "Zg==" (2 padding chars)
        let url = OAuthClient.base64URL(Data("f".utf8))
        #expect(url == "Zg")
    }

    // MARK: - randomBase64URL

    @Test func randomBase64URLReturnsExpectedLength() {
        // 32 raw bytes → 43 chars after stripping padding.
        let s = OAuthClient.randomBase64URL(bytes: 32)
        #expect(s.count == 43)
    }

    @Test func randomBase64URLCharsetSafe() {
        let s = OAuthClient.randomBase64URL(bytes: 32)
        let allowed = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")
        #expect(s.unicodeScalars.allSatisfy(allowed.contains))
    }

    @Test func randomBase64URLProducesDistinctValues() {
        let a = OAuthClient.randomBase64URL(bytes: 32)
        let b = OAuthClient.randomBase64URL(bytes: 32)
        #expect(a != b)
    }

    // MARK: - codeChallenge (PKCE)

    @Test func codeChallengeMatchesRFC7636Vector() {
        // RFC 7636 Appendix B: verifier "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
        // → challenge "E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM"
        let verifier = "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
        let challenge = OAuthClient.codeChallenge(for: verifier)
        #expect(challenge == "E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM")
    }

    @Test func codeChallengeIsDeterministic() {
        let v = "test-verifier-string"
        #expect(OAuthClient.codeChallenge(for: v) == OAuthClient.codeChallenge(for: v))
    }

    @Test func codeChallengeProducesUrlSafeOutput() {
        let c = OAuthClient.codeChallenge(for: "some-verifier")
        #expect(!c.contains("+"))
        #expect(!c.contains("/"))
        #expect(!c.contains("="))
    }

    @Test func codeChallengeIsSHA256Length() {
        // SHA-256 → 32 bytes → 43 chars base64url (no padding).
        let c = OAuthClient.codeChallenge(for: "x")
        #expect(c.count == 43)
    }
}
