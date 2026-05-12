# i18n Translations — Design Spec

**Date:** 2026-05-12
**Status:** Approved

## Goal

Add AI-generated translations for all 14 languages in `AppLanguage` (13 existing + Vietnamese) so every user-facing string in `Localizable.strings` resolves in the user's chosen language.

## Context

- `en.lproj/Localizable.strings` is the single source of truth (~120+ keys).
- `AppLanguage` enum already defines 13 languages; none have `.lproj` translation files yet.
- `Package.swift` uses `.process("Resources")` — new `.lproj` folders are auto-included at build time.
- `L10n.t()` and `Text(loc:)` resolve against `Bundle.module`, so no call-site changes needed.

## Changes

### 1. `AppLanguage.swift`

Add Vietnamese:

```swift
case vietnamese = "vi"
```

Add to `nativeName`: `"Tiếng Việt"`
Add to `englishName`: `"Vietnamese"`
Add to `flag`: `"🇻🇳"`
Add to `resolve()`: prefix match for `"vi"`

### 2. New translation files

Create `Resources/<code>.lproj/Localizable.strings` for all 14 languages:

| Language | Code |
|----------|------|
| Vietnamese (new) | `vi` |
| Spanish | `es` |
| French | `fr` |
| German | `de` |
| Italian | `it` |
| Portuguese | `pt-PT` |
| Brazilian Portuguese | `pt-BR` |
| Japanese | `ja` |
| Korean | `ko` |
| Simplified Chinese | `zh-Hans` |
| Traditional Chinese | `zh-Hant` |
| Ukrainian | `uk` |
| Turkish | `tr` |

Each file translates all keys from `en.lproj/Localizable.strings`. Keys are kept verbatim (they double as English fallback). Only right-hand values are translated.

### 3. Build system

No changes. `.process("Resources")` in `Package.swift` picks up new `.lproj` folders automatically.

## Constraints

- Keys must remain identical to English (`en.lproj`) — they are the fallback.
- Printf format specifiers (`%@`, `%d`, `%1$@`, etc.) must be preserved exactly.
- Brand strings (`Upwork`, `Buddy`, `UpworkBuddy`) stay untranslated.
- URLs, version strings, and technical identifiers stay untranslated.

## Delivery

Parallel agent dispatch: 14 subagents write one `.lproj` file each simultaneously.

## Out of Scope

- Human native-speaker review (post-launch community contribution).
- RTL layout support (Arabic, Hebrew).
- Pluralization rules (`.stringsdict`).
- Dynamic language switching without restart.
