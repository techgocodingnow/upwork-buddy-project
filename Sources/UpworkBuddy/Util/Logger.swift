import Foundation
import os

enum Log {
    static let auth = Logger(subsystem: "com.upworkbuddy.app", category: "auth")
    static let net = Logger(subsystem: "com.upworkbuddy.app", category: "net")
    static let app = Logger(subsystem: "com.upworkbuddy.app", category: "app")
    static let api = Logger(subsystem: "com.upworkbuddy.app", category: "api")
}
