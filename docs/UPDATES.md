# In-app Updates (Sparkle)

UpworkBuddy ships in-app updates via [Sparkle 2](https://sparkle-project.org).
Background checks run every 24 h; when a new version is found, the user gets a
macOS notification banner and Sparkle's standard update window. Updates are
EdDSA-signed, fetched from a GitHub-Pages-hosted appcast, and verified before
install.

## Architecture

| Piece | Where |
|---|---|
| Update service (`@Observable` bridge) | `Sources/UpworkBuddy/Services/UpdateService.swift` |
| Settings page UI | `Sources/UpworkBuddy/Views/SoftwareUpdatesView.swift` |
| App-delegate wiring (UN delegate, registration) | `Sources/UpworkBuddy/UpworkBuddyApp.swift` |
| Sparkle Info.plist keys | `Sources/UpworkBuddy/Info.plist` |
| Appcast template | `appcast/appcast.xml` |
| Release-time signer | `Scripts/sign-and-publish-appcast.sh` |
| CI integration | `.github/workflows/release.yml` |

## One-time setup

### 1. Generate the EdDSA key pair

Run **once**, locally — the private key never leaves your secure storage:

```bash
swift package resolve
.build/artifacts/sparkle/Sparkle/bin/generate_keys
```

`generate_keys` prints two strings:

- **Public key** → paste into `Sources/UpworkBuddy/Info.plist` under
  `SUPublicEDKey`, replacing `REPLACE_WITH_BASE64_ED25519_PUBLIC_KEY`.
  This file is committed.
- **Private key** → store **only** in:
  - GitHub repo secret `SPARKLE_PRIVATE_KEY` (used by CI to sign each release)
  - 1Password / your password manager (offline backup)

  Losing the private key means you cannot ship updates to existing installs.
  Rotation requires every user to manually download a new build.

### 2. Configure GitHub Pages

The appcast is published to the `gh-pages` branch and served at
`https://techgocodingnow.github.io/upwork-buddy-project/appcast.xml` — the
URL already wired into `Info.plist` under `SUFeedURL`.

In GitHub repo settings → Pages:

- **Source**: Deploy from a branch
- **Branch**: `gh-pages` / `(root)`

The first release run pushes the branch automatically; verify the URL is
reachable before cutting a public release.

### 3. Add the GitHub Actions secret

`Settings → Secrets and variables → Actions → New repository secret`:

- Name: `SPARKLE_PRIVATE_KEY`
- Value: the base64 private key from step 1, no surrounding whitespace.

## Release flow

A `git tag vX.Y.Z` push triggers `.github/workflows/release.yml`. The added
steps run after notarization and before the GitHub Release publish:

1. `swift package resolve` (fetches Sparkle's `sign_update` tool)
2. `Scripts/sign-and-publish-appcast.sh`:
   - signs the notarized DMG with `sign_update`
   - prepends a new `<item>` to `appcast.xml` on `gh-pages`
   - commits and pushes

Existing v3.1.1 installs poll the appcast every 24 h. They detect the new
entry, verify the EdDSA signature against `SUPublicEDKey`, download the DMG,
verify Apple's notarization signature, and install.

## Local verification

To test against a fake feed without cutting a real release:

```bash
mkdir -p /tmp/upwork-feed
cp appcast/appcast.xml /tmp/upwork-feed/
# edit /tmp/upwork-feed/appcast.xml — add an <item> with a high version
cd /tmp/upwork-feed && python3 -m http.server 8000

# Override the feed URL on the running app:
defaults write com.gocodingnow.UpworkBuddy SUFeedURL http://localhost:8000/appcast.xml

# Optional — drop scheduled-check interval to 60s for faster iteration:
defaults write com.gocodingnow.UpworkBuddy SUScheduledCheckInterval 60
```

Then click **Settings → Software Updates → Check for Updates**. If your fake
appcast advertises a higher `sparkle:version` than the running build, Sparkle's
window will appear. Reset overrides with `defaults delete com.gocodingnow.UpworkBuddy SUFeedURL`.

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| "Update is improperly signed" | DMG signed with wrong EdDSA key, or the public key in `Info.plist` doesn't match the secret. |
| "You're up to date" but appcast clearly has a new entry | `sparkle:version` (build number, integer) is `<=` the running `CFBundleVersion`. Bump build. |
| Appcast 404 | GitHub Pages not enabled on `gh-pages`, or DNS not propagated yet (wait 5–10 min after first push). |
| Notification banner never fires | `UNUserNotificationCenter` not authorized — check System Settings → Notifications → UpworkBuddy. |
| CI step "SPARKLE_PRIVATE_KEY not set" warning | Secret not configured in repo settings. |
| "An error occurred while running the updater" after download | macOS denied Sparkle's `Autoupdate` helper through App Management. Console shows `kTCCServiceSystemPolicyAppBundles denied by TCC for Autoupdate`. Reset the app decision with `tccutil reset SystemPolicyAppBundles com.upworkbuddy.app`, then allow UpworkBuddy in System Settings → Privacy & Security → App Management and retry. |

## Key rotation

If the private key leaks:

1. Run `generate_keys` to mint a new pair.
2. Update `SUPublicEDKey` in Info.plist; commit; cut a new release.
3. Update the `SPARKLE_PRIVATE_KEY` GitHub secret.
4. Existing installs running the old public key will reject any future
   updates signed with the new key — they will need to manually download a
   build with the new public key from the GitHub Releases page.

For this reason, treat the private key as you would a code-signing identity.
