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
| `Scripts/package-app.sh [version]` | Build universal `.app` bundle (arm64 + x86_64), Developer ID sign + optional notarize, zip for distribution |
| `Scripts/release-local.sh [--notarize] [--staple]` | Mirror CI release flow locally: build, sign, DMG, optional notarize+staple. Output to `build/local/` |
| `Scripts/release.sh <X.Y.Z>` | Bump VERSION + create annotated tag (does not push) |
| `Scripts/import-cert.sh` | Import Developer ID `.p12` from `.env` into login keychain |
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
signs the bundle with Developer ID (falls back to ad-hoc if the identity is
missing). URL-scheme registration only takes effect from a packaged `.app`,
so OAuth login must be tested through the bundle (not via `swift run`).

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

## Distribution

`Scripts/package-app.sh` signs with the Developer ID identity discovered via
`security find-identity`. Override with `SIGN_IDENTITY` env var.

To notarize + staple, store credentials once:

```bash
xcrun notarytool store-credentials upworkbuddy-notary \
  --apple-id <apple-id> --team-id <TEAMID> --password <app-specific-password>
```

Then build with notarization enabled:

```bash
NOTARY_PROFILE=upworkbuddy-notary Scripts/package-app.sh 1.0.0
```

Without `NOTARY_PROFILE`, the app is Developer ID signed but not notarized —
Gatekeeper will check online on first launch. If the identity is missing,
the script falls back to ad-hoc signing (end users will see keychain
password prompts on first OAuth login).

## CI/CD (GitHub Actions)

Two workflows in `.github/workflows/`:

- **`ci.yml`** — debug build + tests on push/PR to `main`. Uses Config.example.plist as a stub. Skips commits matching `chore: release v*`.
- **`release.yml`** — fires on `v*.*.*` tag push (or `workflow_dispatch`). Builds universal `.app`, signs with Developer ID, notarizes + staples, packages a DMG, notarizes the DMG, and publishes a GitHub Release with attached artifact + autogenerated changelog.

### Required GitHub secrets

| Secret | Purpose |
|--------|---------|
| `BUILD_CERTIFICATE_BASE64` | base64 of Developer ID `.p12` |
| `P12_PASSWORD` | export password for the `.p12` |
| `KEYCHAIN_PASSWORD` | password for ephemeral CI keychain (any string) |
| `NOTARY_APPLE_ID` | Apple ID email for notarytool |
| `NOTARY_TEAM_ID` | Apple team ID (`L23PD654Q3`) |
| `NOTARY_PASSWORD` | app-specific password from appleid.apple.com |
| `CONFIG_PLIST_BASE64` | base64 of production `Config.plist` |

### Local release workflow

```bash
# One-time
Scripts/import-cert.sh                                # imports cert from .env
xcrun notarytool store-credentials AI_DEVTOOLS_NOTARY \
  --apple-id <id> --team-id L23PD654Q3 --password <app-pw>

# Validate before tagging
Scripts/release-local.sh --notarize --staple

# Tag + ship
Scripts/release.sh 1.0.0
git push origin main && git push origin v1.0.0       # CI publishes release
```

## License

MIT
