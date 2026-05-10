# UpworkBuddy

Menu-bar macOS app that surfaces your active Upwork freelance work — total hours,
total earnings, and per-project breakdowns rolled up by **today / week / month / year**.
Built as a SwiftPM executable; no dependencies; lives in the menu bar (no Dock icon).

## Requirements

- macOS 14 (Sonoma) or newer
- Swift 6 toolchain (`swift --version` ≥ 6.0)
- An Upwork developer API key — register at <https://www.upwork.com/developer/keys/apply>
  - **Redirect URI must be set to** `upworkbuddy://callback`
  - Note your `client_id` (and `client_secret` if your app type requires it)

## Build & install

### Scripts

| Script | Purpose |
|--------|---------|
| `Scripts/package-app.sh [version]` | Build universal `.app` bundle (arm64 + x86_64), ad-hoc sign, zip for distribution |
| `Scripts/introspect-schema.sh <Type>` | GraphQL schema introspection helper (dev) |

### Quick start

```bash
# 1. Config
cp Sources/UpworkBuddy/Resources/Config.example.plist \
   Sources/UpworkBuddy/Resources/Config.plist
$EDITOR Sources/UpworkBuddy/Resources/Config.plist   # paste your Upwork credentials

# 2. Build
chmod +x Scripts/package-app.sh Scripts/introspect-schema.sh
Scripts/package-app.sh 1.0          # produces .build/dist/UpworkBuddy.app

# 3. Install to /Applications
cp -r .build/dist/UpworkBuddy.app /Applications/

# 4. Launch
open /Applications/UpworkBuddy.app
```

> **Note:** Version argument (e.g. `1.0`) is optional; defaults to `dev`.

### Rebuild

```bash
Scripts/package-app.sh && rm -rf /Applications/UpworkBuddy.app && cp -R .build/dist/UpworkBuddy.app /Applications/
```

### Configuration

All runtime config lives in `Sources/UpworkBuddy/Resources/Config.plist`
(gitignored). It is bundled into the executable at build time via SwiftPM's
`Bundle.module` and read through the type-safe [`AppConfig`](Sources/UpworkBuddy/Config/AppConfig.swift)
wrapper.

Required keys (see `Config.example.plist`):

| Key | Purpose |
|-----|---------|
| `UpworkClientId` | OAuth client_id from developers.upwork.com |
| `UpworkClientSecret` | OAuth client_secret (optional if PKCE-only) |
| `UpworkAPIBaseURL` | GraphQL endpoint |
| `UpworkAuthorizeURL` | OAuth authorize URL |
| `UpworkTokenURL` | OAuth token URL |
| `UpworkRedirectURI` | Custom URL scheme callback (`upworkbuddy://callback`) |

For CI: write `Config.plist` from a secure secret store before invoking
`Scripts/package-app.sh`.

The packaging script bakes the credentials into the bundled `Info.plist` and
ad-hoc signs the bundle. URL-scheme registration only takes effect from a
packaged `.app`, so OAuth login must be tested through the bundle (not via
`swift run`).

## Sign in

1. Click the briefcase icon in the menu bar → **Connect Upwork**
2. A browser tab opens upwork.com — sign in and approve
3. The browser redirects to `upworkbuddy://callback?...`; macOS hands the URL
   back to the app via Launch Services
4. Tokens are stored in the macOS Keychain (`com.upworkbuddy.tokens`)

To inspect stored tokens:

```bash
security find-generic-password -s com.upworkbuddy.tokens -a access -w
```

## Schema introspection (dev)

The active-contracts root field name and any fixed-price earnings projection
are not fully documented publicly. Use the helper after signing in:

```bash
Scripts/introspect-schema.sh Query                 # see all root query fields
Scripts/introspect-schema.sh ContractTimeReport    # confirm time-report fields
```

If a field name differs from what `Sources/UpworkBuddy/Upwork/Queries.swift`
uses, update that file and rebuild.

## Development

```bash
swift build          # type-check + build
swift test           # run unit tests
swift run UpworkBuddy   # run unbundled (no OAuth callback support)
```

## Configuration

- Refresh interval, currency, and selected workspace live in `UserDefaults`
  (`UpworkBuddyRefreshSeconds`, `UpworkBuddyCurrency`, `UpworkBuddyTenantId`).
- Tokens live in the Keychain (service `com.upworkbuddy.tokens`,
  accounts `access`, `refresh`, `expiresAt`).

## v1 scope

- Hourly contracts only (uses `contractTimeReport.totalCharges`)
- USD display only
- Auto-selects your first Upwork organization

Fixed-price/milestone earnings, multi-currency FX, and an explicit workspace
picker are deferred to v2.

## Distribution caveat

The app is ad-hoc signed. When downloaded from the internet, macOS will mark
it as quarantined and block opening. Workaround:

```bash
xattr -d com.apple.quarantine /Applications/UpworkBuddy.app
```

Developer-ID signing + notarization is planned for a future release.

## License

MIT
