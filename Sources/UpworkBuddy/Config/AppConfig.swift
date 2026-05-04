import Foundation

/// Type-safe accessor for values in `Resources/Config.plist`. The plist is bundled
/// into the executable at build time via SwiftPM's `Bundle.module`. The committed
/// `Config.example.plist` documents required keys; copy it to `Config.plist` and
/// fill in real values before building.
enum AppConfig {
    enum Key: String {
        case clientId       = "UpworkClientId"
        case clientSecret   = "UpworkClientSecret"
        case apiBaseURL     = "UpworkAPIBaseURL"
        case authorizeURL   = "UpworkAuthorizeURL"
        case tokenURL       = "UpworkTokenURL"
        case redirectURI    = "UpworkRedirectURI"
    }

    /// Lazily-loaded plist contents. Crashes at first access if `Config.plist` is
    /// missing — this is intentional: the app is unusable without it.
    /// `nonisolated(unsafe)` is safe because the dictionary is fully initialized
    /// inside the closure and never mutated afterward.
    private nonisolated(unsafe) static let values: [String: Any] = {
        guard let url = Bundle.module.url(forResource: "Config", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(
                from: data, options: [], format: nil
              ) as? [String: Any] else {
            fatalError("Config.plist missing or unreadable. Copy Resources/Config.example.plist to Resources/Config.plist and fill in values.")
        }
        return dict
    }()

    static func string(_ key: Key) -> String? {
        let v = values[key.rawValue] as? String
        return (v?.isEmpty == false) ? v : nil
    }

    static func require(_ key: Key) throws -> String {
        guard let v = string(key) else {
            throw UpworkError.transport("Missing Config.plist key: \(key.rawValue)")
        }
        return v
    }

    static func url(_ key: Key) throws -> URL {
        let s = try require(key)
        guard let u = URL(string: s) else {
            throw UpworkError.transport("Config.plist key \(key.rawValue) is not a valid URL: \(s)")
        }
        return u
    }
}
