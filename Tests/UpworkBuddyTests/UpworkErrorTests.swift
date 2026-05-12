import Testing
@testable import UpworkBuddy

@Suite("UpworkError")
struct UpworkErrorTests {

    @Test func allCasesProduceNonEmptyDescription() {
        let cases: [UpworkError] = [
            .notAuthenticated,
            .unauthorized,
            .rateLimited(retryAfter: 30),
            .rateLimited(retryAfter: nil),
            .missingClientId,
            .oauthState("state mismatch"),
            .http(status: 500, body: "boom"),
            .graphqlErrors(["one", "two"]),
            .decoding("bad json"),
            .noTenant,
            .transport("dns")
        ]
        for c in cases {
            #expect(c.errorDescription?.isEmpty == false)
        }
    }

    @Test func rateLimitedIncludesRetrySeconds() {
        let e = UpworkError.rateLimited(retryAfter: 42)
        #expect(e.errorDescription?.contains("42") == true)
    }

    @Test func rateLimitedNilFallsBackTo60() {
        let e = UpworkError.rateLimited(retryAfter: nil)
        #expect(e.errorDescription?.contains("60") == true)
    }

    @Test func httpIncludesStatusCode() {
        let e = UpworkError.http(status: 503, body: "")
        #expect(e.errorDescription?.contains("503") == true)
    }

    @Test func graphqlErrorsJoinAllMessages() {
        let e = UpworkError.graphqlErrors(["foo", "bar"])
        let d = e.errorDescription ?? ""
        #expect(d.contains("foo"))
        #expect(d.contains("bar"))
    }

    @Test func oauthStateIncludesMessage() {
        let e = UpworkError.oauthState("nonce mismatch")
        #expect(e.errorDescription?.contains("nonce mismatch") == true)
    }

    @Test func transportIncludesUnderlyingMessage() {
        let e = UpworkError.transport("connection refused")
        #expect(e.errorDescription?.contains("connection refused") == true)
    }
}
