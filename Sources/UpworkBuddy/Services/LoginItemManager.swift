import Foundation
import ServiceManagement

enum LoginItemManager {
    static var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    @discardableResult
    static func apply(enabled: Bool) -> Bool {
        let service = SMAppService.mainApp
        do {
            if enabled {
                if service.status != .enabled {
                    try service.register()
                }
            } else {
                if service.status == .enabled {
                    try service.unregister()
                }
            }
            return true
        } catch {
            Log.app.error("LoginItem toggle failed: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }
}
