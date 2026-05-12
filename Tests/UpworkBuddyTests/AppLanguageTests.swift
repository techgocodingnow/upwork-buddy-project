import Testing
@testable import UpworkBuddy

@Suite("AppLanguage.resolve")
struct AppLanguageTests {

    @Test func nilFallsBackToEnglish() {
        #expect(AppLanguage.resolve(from: nil) == .english)
    }

    @Test func emptyFallsBackToEnglish() {
        #expect(AppLanguage.resolve(from: "") == .english)
    }

    @Test func exactMatchesEachCase() {
        for lang in AppLanguage.allCases {
            #expect(AppLanguage.resolve(from: lang.rawValue) == lang)
        }
    }

    @Test func zhHansVariants() {
        #expect(AppLanguage.resolve(from: "zh-Hans") == .simplifiedChinese)
        #expect(AppLanguage.resolve(from: "zh-Hans-CN") == .simplifiedChinese)
        #expect(AppLanguage.resolve(from: "zh-CN") == .simplifiedChinese)
        #expect(AppLanguage.resolve(from: "ZH-cn") == .simplifiedChinese)
    }

    @Test func zhHantVariants() {
        #expect(AppLanguage.resolve(from: "zh-Hant") == .traditionalChinese)
        #expect(AppLanguage.resolve(from: "zh-Hant-TW") == .traditionalChinese)
        #expect(AppLanguage.resolve(from: "zh-TW") == .traditionalChinese)
        #expect(AppLanguage.resolve(from: "zh-HK") == .traditionalChinese)
    }

    @Test func portugueseVariants() {
        #expect(AppLanguage.resolve(from: "pt-BR") == .brazilianPortuguese)
        #expect(AppLanguage.resolve(from: "pt-br") == .brazilianPortuguese)
        #expect(AppLanguage.resolve(from: "pt") == .portuguese)
        #expect(AppLanguage.resolve(from: "pt-PT") == .portuguese)
    }

    @Test func vietnameseByPrefix() {
        #expect(AppLanguage.resolve(from: "vi-VN") == .vietnamese)
        #expect(AppLanguage.resolve(from: "vi") == .vietnamese)
    }

    @Test func prefixMatchForSimpleLanguages() {
        #expect(AppLanguage.resolve(from: "es-419") == .spanish)
        #expect(AppLanguage.resolve(from: "fr-CA") == .french)
        #expect(AppLanguage.resolve(from: "de-AT") == .german)
    }

    @Test func unknownFallsBackToEnglish() {
        #expect(AppLanguage.resolve(from: "xx-YZ") == .english)
        #expect(AppLanguage.resolve(from: "klingon") == .english)
    }

    @Test func nativeNameAndFlagPopulatedForEveryCase() {
        for lang in AppLanguage.allCases {
            #expect(!lang.nativeName.isEmpty)
            #expect(!lang.englishName.isEmpty)
            #expect(!lang.flag.isEmpty)
            #expect(lang.code == lang.rawValue)
            #expect(lang.id == lang.rawValue)
        }
    }
}
