import Foundation

/// Languages exposed in Settings → Language. The `code` is the bundle/.lproj
/// directory name and the value written into AppleLanguages so Foundation's
/// localization machinery resolves Bundle.module strings against it.
enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case english   = "en"
    case spanish   = "es"
    case french    = "fr"
    case german    = "de"
    case italian   = "it"
    case portuguese = "pt-PT"
    case brazilianPortuguese = "pt-BR"
    case japanese  = "ja"
    case korean    = "ko"
    case simplifiedChinese  = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case ukrainian = "uk"
    case turkish   = "tr"
    case vietnamese = "vi"

    var id: String { rawValue }

    /// Bundle/.lproj identifier and AppleLanguages value.
    var code: String { rawValue }

    /// Native display name shown in the picker (e.g. "Español").
    var nativeName: String {
        switch self {
        case .english:              return "English"
        case .spanish:              return "Español"
        case .french:               return "Français"
        case .german:               return "Deutsch"
        case .italian:              return "Italiano"
        case .portuguese:           return "Português"
        case .brazilianPortuguese:  return "Português (Brasil)"
        case .japanese:             return "日本語"
        case .korean:               return "한국어"
        case .simplifiedChinese:    return "简体中文"
        case .traditionalChinese:   return "繁體中文"
        case .ukrainian:            return "Українська"
        case .turkish:              return "Türkçe"
        case .vietnamese:           return "Tiếng Việt"
        }
    }

    /// English name shown as a secondary label (e.g. "Spanish").
    var englishName: String {
        switch self {
        case .english:              return "English"
        case .spanish:              return "Spanish"
        case .french:               return "French"
        case .german:               return "German"
        case .italian:              return "Italian"
        case .portuguese:           return "Portuguese"
        case .brazilianPortuguese:  return "Brazilian Portuguese"
        case .japanese:             return "Japanese"
        case .korean:               return "Korean"
        case .simplifiedChinese:    return "Simplified Chinese"
        case .traditionalChinese:   return "Traditional Chinese"
        case .ukrainian:            return "Ukrainian"
        case .turkish:              return "Turkish"
        case .vietnamese:           return "Vietnamese"
        }
    }

    /// Flag emoji for the picker row.
    var flag: String {
        switch self {
        case .english:              return "🇬🇧"
        case .spanish:              return "🇪🇸"
        case .french:               return "🇫🇷"
        case .german:               return "🇩🇪"
        case .italian:              return "🇮🇹"
        case .portuguese:           return "🇵🇹"
        case .brazilianPortuguese:  return "🇧🇷"
        case .japanese:             return "🇯🇵"
        case .korean:               return "🇰🇷"
        case .simplifiedChinese:    return "🇨🇳"
        case .traditionalChinese:   return "🇹🇼"
        case .ukrainian:            return "🇺🇦"
        case .turkish:              return "🇹🇷"
        case .vietnamese:           return "🇻🇳"
        }
    }

    /// Resolve a stored AppleLanguages value or system locale to a known case,
    /// falling back to English when no mapping exists.
    static func resolve(from rawCode: String?) -> AppLanguage {
        guard let raw = rawCode, !raw.isEmpty else { return .english }
        if let exact = AppLanguage(rawValue: raw) { return exact }
        let lower = raw.lowercased()
        if lower.hasPrefix("zh-hans") || lower.hasPrefix("zh-cn") { return .simplifiedChinese }
        if lower.hasPrefix("zh-hant") || lower.hasPrefix("zh-tw") || lower.hasPrefix("zh-hk") { return .traditionalChinese }
        if lower.hasPrefix("pt-br") { return .brazilianPortuguese }
        if lower.hasPrefix("pt") { return .portuguese }
        if lower.hasPrefix("vi") { return .vietnamese }
        let prefix = String(lower.prefix(2))
        return AppLanguage.allCases.first { $0.code.lowercased().hasPrefix(prefix) } ?? .english
    }
}
