import Foundation
import Security

/// Generic-password Keychain wrapper. Service: `com.upworkbuddy.tokens`.
enum KeychainStore {
    static let service = "com.upworkbuddy.tokens"

    enum Account: String {
        case access
        case refresh
        case expiresAt
        case codeVerifier
        case oauthState
    }

    static func save(_ value: String, for account: Account) throws {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account.rawValue
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
            var add = query
            add[kSecValueData as String] = data
            add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            let addStatus = SecItemAdd(add as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw UpworkError.transport("Keychain add failed: \(addStatus)")
            }
            return
        }
        guard status == errSecSuccess else {
            throw UpworkError.transport("Keychain update failed: \(status)")
        }
    }

    static func read(_ account: Account) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func delete(_ account: Account) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }

    static func wipeAll() {
        for account in [Account.access, .refresh, .expiresAt, .codeVerifier, .oauthState] {
            delete(account)
        }
    }
}
