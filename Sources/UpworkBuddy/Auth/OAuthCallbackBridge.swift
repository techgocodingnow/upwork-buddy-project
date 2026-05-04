import Foundation
import Network
import AppKit

/// RFC 8252 §7.3 loopback IP redirect for desktop OAuth.
///
/// Boots a one-shot HTTP listener on `127.0.0.1:<port>` for the duration of the
/// authorization flow, accepts the single redirect from the system browser,
/// hands the URL to `OAuthClient.handleCallback`, then tears down.
///
/// `127.0.0.1` is preferred over `localhost` per RFC 8252 to avoid hostname
/// resolution edge cases. The port must match the redirect_uri whitelisted in
/// the Upwork developer dashboard exactly.
@MainActor
final class OAuthCallbackBridge: NSObject {
    static let shared = OAuthCallbackBridge()

    /// Must match `UpworkRedirectURI` port in Config.plist and Upwork dashboard.
    nonisolated static let port: NWEndpoint.Port = 7421

    private var listener: NWListener?
    private var didExchange: (@Sendable (Result<Void, Error>) -> Void)?
    private var handled = false

    func register(onExchange: @escaping @Sendable (Result<Void, Error>) -> Void) {
        self.didExchange = onExchange
    }

    /// Start the loopback listener. Call before opening the system browser.
    /// Throws if the port is already in use.
    func startListening() throws {
        stopListening()
        handled = false

        let listener = try NWListener(using: .tcp, on: Self.port)
        listener.newConnectionHandler = { [weak self] connection in
            Task { @MainActor in self?.accept(connection) }
        }
        listener.stateUpdateHandler = { state in
            switch state {
            case .failed(let error):
                Log.auth.error("OAuth listener failed: \(error.localizedDescription, privacy: .public)")
            case .ready:
                Log.auth.debug("OAuth listener ready on 127.0.0.1:\(Self.port.rawValue)")
            default:
                break
            }
        }
        listener.start(queue: .main)
        self.listener = listener
    }

    func stopListening() {
        listener?.cancel()
        listener = nil
    }

    // MARK: - Connection handling

    private func accept(_ connection: NWConnection) {
        connection.start(queue: .main)
        connection.receive(minimumIncompleteLength: 1, maximumLength: 16 * 1024) { [weak self] data, _, _, error in
            Task { @MainActor in
                guard let self else { return }
                if let error {
                    self.respondAndClose(connection, status: 500, body: "OAuth error")
                    self.finish(.failure(UpworkError.transport(error.localizedDescription)))
                    return
                }
                guard let data, let request = String(data: data, encoding: .utf8) else {
                    self.respondAndClose(connection, status: 400, body: "Bad request")
                    self.finish(.failure(UpworkError.oauthState("Empty callback request")))
                    return
                }
                self.handleRequest(request, on: connection)
            }
        }
    }

    private func handleRequest(_ request: String, on connection: NWConnection) {
        guard !handled else {
            respondAndClose(connection, status: 404, body: "")
            return
        }

        // Parse: "GET /callback?code=...&state=... HTTP/1.1"
        guard let firstLine = request.split(separator: "\r\n", maxSplits: 1, omittingEmptySubsequences: true).first else {
            respondAndClose(connection, status: 400, body: "Bad request")
            finish(.failure(UpworkError.oauthState("Malformed HTTP request")))
            return
        }
        let parts = firstLine.split(separator: " ")
        guard parts.count >= 2, parts[0] == "GET" else {
            respondAndClose(connection, status: 405, body: "Method not allowed")
            finish(.failure(UpworkError.oauthState("Unexpected HTTP method")))
            return
        }

        let path = String(parts[1])
        // Browsers may probe /favicon.ico — ignore those, keep listener alive.
        if path.hasPrefix("/favicon") {
            respondAndClose(connection, status: 404, body: "")
            return
        }

        let urlString = "http://127.0.0.1:\(Self.port.rawValue)\(path)"
        guard let url = URL(string: urlString) else {
            respondAndClose(connection, status: 400, body: "Bad path")
            finish(.failure(UpworkError.oauthState("Bad callback path")))
            return
        }

        handled = true
        respondAndClose(connection, status: 200, body: Self.successHTML)

        let callback = didExchange
        Task { [url] in
            do {
                try await OAuthClient.shared.handleCallback(url: url)
                callback?(.success(()))
            } catch {
                Log.auth.error("OAuth exchange failed: \(error.localizedDescription, privacy: .public)")
                callback?(.failure(error))
            }
            await MainActor.run { OAuthCallbackBridge.shared.stopListening() }
        }
    }

    private func respondAndClose(_ connection: NWConnection, status: Int, body: String) {
        let reason: String = {
            switch status {
            case 200: return "OK"
            case 400: return "Bad Request"
            case 404: return "Not Found"
            case 405: return "Method Not Allowed"
            case 500: return "Internal Server Error"
            default:  return "OK"
            }
        }()
        let payload = """
        HTTP/1.1 \(status) \(reason)\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: \(body.utf8.count)\r
        Connection: close\r
        Cache-Control: no-store\r
        \r
        \(body)
        """
        connection.send(content: payload.data(using: .utf8), completion: .contentProcessed { _ in
            connection.cancel()
        })
    }

    private func finish(_ result: Result<Void, Error>) {
        handled = true
        didExchange?(result)
        stopListening()
    }

    private static let successHTML = """
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>UpworkBuddy connected</title>
        <style>
          body { font-family: -apple-system, system-ui, sans-serif; background: #0e1116; color: #e6edf3; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
          .card { text-align: center; padding: 32px 40px; border-radius: 16px; background: #161b22; box-shadow: 0 24px 60px rgba(0,0,0,0.4); }
          h1 { margin: 0 0 8px; font-size: 22px; font-weight: 600; }
          p { margin: 0; color: #8b949e; font-size: 14px; }
          .check { font-size: 40px; margin-bottom: 8px; }
        </style>
      </head>
      <body>
        <div class="card">
          <div class="check">✓</div>
          <h1>UpworkBuddy connected</h1>
          <p id="msg">Closing this tab…</p>
        </div>
        <script>
          // Browsers only allow window.close() on tabs/windows opened via script.
          // The system browser opened this tab from NSWorkspace, so close() is
          // typically blocked. Attempt it anyway; fall back to a hint.
          setTimeout(function () {
            try { window.close(); } catch (e) {}
            setTimeout(function () {
              var el = document.getElementById('msg');
              if (el) el.textContent = 'You can close this tab and return to the app.';
            }, 400);
          }, 250);
        </script>
      </body>
    </html>
    """
}
