# UpworkBuddy

A lightweight macOS menu-bar app that shows your Upwork freelance earnings at a glance — total hours, total earnings, and per-project breakdowns rolled up by **today / week / month / year**.

- Lives in the menu bar, no Dock icon
- No third-party dependencies — pure Swift + SwiftPM
- Tokens stored securely in the macOS Keychain
- Requires macOS 14 (Sonoma) or newer

---

## Requirements

- macOS 14 (Sonoma) or newer
- Swift 6 toolchain (`swift --version` ≥ 6.0)
- An Upwork developer app — register at <https://www.upwork.com/developer/keys/apply>
  - Set the **Redirect URI** to `upworkbuddy://callback`
  - Copy your `client_id` and `client_secret`

---

## Getting started

### 1. Configure credentials

```bash
cp Sources/UpworkBuddy/Resources/Config.example.plist \
   Sources/UpworkBuddy/Resources/Config.plist
```

Open `Config.plist` and fill in your Upwork credentials:

| Key | Value |
|-----|-------|
| `UpworkClientId` | OAuth client_id from developers.upwork.com |
| `UpworkClientSecret` | OAuth client_secret |
| `UpworkAPIBaseURL` | `https://api.upwork.com/graphql` |
| `UpworkAuthorizeURL` | `https://www.upwork.com/ab/account-security/oauth2/authorize` |
| `UpworkTokenURL` | `https://www.upwork.com/api/v3/oauth2/token` |
| `UpworkRedirectURI` | `upworkbuddy://callback` |

`Config.plist` is gitignored — your credentials will never be committed.

### 2. Build

```bash
chmod +x Scripts/package-app.sh
Scripts/package-app.sh          # produces .build/dist/UpworkBuddy.app
```

### 3. Install and launch

```bash
cp -r .build/dist/UpworkBuddy.app /Applications/
open /Applications/UpworkBuddy.app
```

> **Note:** OAuth login requires the packaged `.app` (not `swift run`) because URL-scheme handling only works through a signed bundle.

---

## Sign in

1. Click the briefcase icon in the menu bar → **Connect Upwork**
2. A browser tab opens — sign in and approve
3. macOS redirects back to the app via the `upworkbuddy://callback` URL scheme
4. Tokens are stored in the macOS Keychain under `com.upworkbuddy.tokens`

To verify stored tokens:

```bash
security find-generic-password -s com.upworkbuddy.tokens -a access -w
```

---

## Development

```bash
swift build       # type-check and build
swift test        # run unit tests
swift run UpworkBuddy   # run unbundled (OAuth callback not supported here)
```

To rebuild and reinstall after changes:

```bash
Scripts/package-app.sh && rm -rf /Applications/UpworkBuddy.app && cp -R .build/dist/UpworkBuddy.app /Applications/
```

Runtime preferences (refresh interval, currency, workspace) are stored in `UserDefaults`. Tokens live in the Keychain.

---

## CI/CD

Two GitHub Actions workflows are included:

- **`ci.yml`** — runs a debug build and tests on every push/PR to `main`
- **`release.yml`** — fires on `v*.*.*` tag pushes; builds a universal `.app`, signs it with Developer ID, notarizes, packages a DMG, and publishes a GitHub Release

### Required secrets for release

| Secret | Purpose |
|--------|---------|
| `BUILD_CERTIFICATE_BASE64` | base64-encoded Developer ID `.p12` |
| `P12_PASSWORD` | export password for the `.p12` |
| `KEYCHAIN_PASSWORD` | any string — used for the ephemeral CI keychain |
| `NOTARY_APPLE_ID` | Apple ID email for notarytool |
| `NOTARY_TEAM_ID` | Your Apple team ID |
| `NOTARY_PASSWORD` | App-specific password from appleid.apple.com |
| `CONFIG_PLIST_BASE64` | base64-encoded production `Config.plist` |

---

## Distributing

The packaging script signs with the Developer ID identity found in your keychain. Override with the `SIGN_IDENTITY` env var.

To notarize + staple, store credentials once:

```bash
xcrun notarytool store-credentials upworkbuddy-notary \
  --apple-id <apple-id> --team-id <TEAMID> --password <app-specific-password>
```

Then build with notarization:

```bash
NOTARY_PROFILE=upworkbuddy-notary Scripts/package-app.sh 1.0.0
```

Without `NOTARY_PROFILE`, the app is signed but not notarized — Gatekeeper will check online on first launch.

---

## Current limitations

- Hourly contracts only (`contractTimeReport.totalCharges`)
- USD display only
- Auto-selects your first Upwork organization

Fixed-price earnings, multi-currency support, and a workspace picker are planned for a future release.

---

## License

MIT
