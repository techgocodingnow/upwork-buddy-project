#!/usr/bin/env bash
# Builds a universal UpworkBuddy.app bundle from the SwiftPM target and drops a
# distributable zip alongside.
#
# Usage:
#   Scripts/package-app.sh [<version>]
#
# Credentials live in Sources/UpworkBuddy/Resources/Config.plist (gitignored).
# Copy Config.example.plist to Config.plist and fill in values before building.

set -euo pipefail

VERSION="${1:-dev}"
BUNDLE_NAME="UpworkBuddy.app"
BUNDLE_ID="com.upworkbuddy.app"
EXECUTABLE_NAME="UpworkBuddy"
MIN_MACOS="14.0"
URL_SCHEME="upworkbuddy"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="${ROOT}/.build/dist"
CONFIG_PLIST="${ROOT}/Sources/UpworkBuddy/Resources/Config.plist"
APP_ICON="${ROOT}/Sources/UpworkBuddy/Resources/GeneratedBrand/UpworkBuddy.icns"

cd "${ROOT}"

if [[ ! -f "${CONFIG_PLIST}" ]]; then
  echo "ERROR: ${CONFIG_PLIST} not found." >&2
  echo "       Copy Config.example.plist to Config.plist and fill in values." >&2
  exit 1
fi

CLIENT_ID=$(/usr/libexec/PlistBuddy -c "Print :UpworkClientId" "${CONFIG_PLIST}" 2>/dev/null || true)
if [[ -z "${CLIENT_ID}" ]]; then
  echo "WARNING: UpworkClientId is empty in Config.plist; OAuth will fail." >&2
fi

echo "▸ Cleaning previous dist..."
rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}"

echo "▸ Building universal binary (arm64 + x86_64)..."
# DEBUG=1 keeps `#if DEBUG` sections (debug settings menu, dev tools) in the
# release-optimized bundle. Off by default for public builds.
BUILD_FLAGS=(-c release --arch arm64 --arch x86_64)
if [[ "${DEBUG:-0}" == "1" ]]; then
  echo "  (DEBUG=1 → adding -DDEBUG compile flag)"
  BUILD_FLAGS+=(-Xswiftc -DDEBUG)
fi
swift build "${BUILD_FLAGS[@]}"

BIN_PATH=$(swift build "${BUILD_FLAGS[@]}" --show-bin-path)
BUILT_BINARY="${BIN_PATH}/${EXECUTABLE_NAME}"
if [[ ! -x "${BUILT_BINARY}" ]]; then
  echo "Binary not found at ${BUILT_BINARY}" >&2
  exit 1
fi

echo "▸ Assembling ${BUNDLE_NAME}..."
BUNDLE="${DIST_DIR}/${BUNDLE_NAME}"
mkdir -p "${BUNDLE}/Contents/MacOS"
mkdir -p "${BUNDLE}/Contents/Resources"
mkdir -p "${BUNDLE}/Contents/lib"
cp "${BUILT_BINARY}" "${BUNDLE}/Contents/MacOS/${EXECUTABLE_NAME}"

# Copy Sparkle.framework (rpath = @executable_path/../lib).
SPARKLE_SRC="${ROOT}/.build/artifacts/sparkle/Sparkle/Sparkle.xcframework/macos-arm64_x86_64/Sparkle.framework"
if [[ ! -d "${SPARKLE_SRC}" ]]; then
  SPARKLE_SRC="${BIN_PATH}/Sparkle.framework"
fi
if [[ -d "${SPARKLE_SRC}" ]]; then
  cp -R "${SPARKLE_SRC}" "${BUNDLE}/Contents/lib/"
else
  echo "ERROR: Sparkle.framework not found" >&2
  exit 1
fi

# Copy SwiftPM-generated resource bundle (contains Config.plist) into the app bundle.
RESOURCE_BUNDLE="${BIN_PATH}/UpworkBuddy_UpworkBuddy.bundle"
if [[ -d "${RESOURCE_BUNDLE}" ]]; then
  cp -R "${RESOURCE_BUNDLE}" "${BUNDLE}/Contents/Resources/"
fi

if [[ -f "${APP_ICON}" ]]; then
  cp "${APP_ICON}" "${BUNDLE}/Contents/Resources/UpworkBuddy.icns"
fi

cat > "${BUNDLE}/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleDisplayName</key>
    <string>Upwork Buddy</string>
    <key>CFBundleExecutable</key>
    <string>${EXECUTABLE_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleIconFile</key>
    <string>UpworkBuddy</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Upwork Buddy</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>${VERSION}</string>
    <key>CFBundleVersion</key>
    <string>${VERSION}</string>
    <key>LSMinimumSystemVersion</key>
    <string>${MIN_MACOS}</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>CFBundleURLTypes</key>
    <array>
      <dict>
        <key>CFBundleURLName</key>
        <string>com.upworkbuddy.oauth</string>
        <key>CFBundleURLSchemes</key>
        <array>
          <string>${URL_SCHEME}</string>
        </array>
      </dict>
    </array>
</dict>
</plist>
PLIST

cat > "${BUNDLE}/Contents/PkgInfo" <<'PKG'
APPL????
PKG

ENTITLEMENTS="${ROOT}/Scripts/UpworkBuddy.entitlements"
SIGN_IDENTITY="${SIGN_IDENTITY:-Developer ID Application: I Le Duc (L23PD654Q3)}"

if security find-identity -v -p codesigning | grep -qF "${SIGN_IDENTITY}"; then
  echo "▸ Signing with: ${SIGN_IDENTITY}"
  # Sign nested resource bundles first, then frameworks, then the app bundle.
  find "${BUNDLE}/Contents/Resources" -name "*.bundle" -type d -print0 2>/dev/null | \
    while IFS= read -r -d '' nested; do
      codesign --force --options runtime --timestamp \
        --sign "${SIGN_IDENTITY}" "${nested}"
    done
  for fw in "${BUNDLE}/Contents/lib/"*.framework; do
    [[ -d "${fw}" ]] || continue
    # Sign nested helpers inside-out, before the framework itself:
    #   1. Bare executables (Sparkle ships 'Autoupdate' — NOT a bundle, so it
    #      is missed by the *.xpc/*.app search and would fail notarization with
    #      "not signed with a valid Developer ID / no secure timestamp").
    #   2. XPC services and helper .app bundles.
    find "${fw}/Versions" -maxdepth 2 -type f -name Autoupdate -print0 2>/dev/null | \
      while IFS= read -r -d '' helper; do
        codesign --force --options runtime --timestamp \
          --sign "${SIGN_IDENTITY}" "${helper}"
      done
    find "${fw}" \( -name "*.xpc" -o -name "*.app" \) -type d -print0 2>/dev/null | \
      while IFS= read -r -d '' helper; do
        codesign --force --options runtime --timestamp \
          --sign "${SIGN_IDENTITY}" "${helper}"
      done
    codesign --force --options runtime --timestamp \
      --sign "${SIGN_IDENTITY}" "${fw}"
  done
  codesign --force --options runtime --timestamp \
    --entitlements "${ENTITLEMENTS}" \
    --sign "${SIGN_IDENTITY}" "${BUNDLE}"
  codesign --verify --deep --strict --verbose=2 "${BUNDLE}"

  if [[ -n "${NOTARY_PROFILE:-}" ]]; then
    echo "▸ Notarizing (profile: ${NOTARY_PROFILE})..."
    NOTARY_ZIP="${DIST_DIR}/UpworkBuddy-notarize.zip"
    /usr/bin/ditto -c -k --keepParent "${BUNDLE}" "${NOTARY_ZIP}"
    NOTARY_ARGS=(--keychain-profile "${NOTARY_PROFILE}" --wait)
    if [[ -n "${NOTARY_KEYCHAIN:-}" ]]; then
      NOTARY_ARGS+=(--keychain "${NOTARY_KEYCHAIN}")
    fi
    xcrun notarytool submit "${NOTARY_ZIP}" "${NOTARY_ARGS[@]}"
    rm -f "${NOTARY_ZIP}"
    echo "▸ Stapling..."
    xcrun stapler staple "${BUNDLE}"
    xcrun stapler validate "${BUNDLE}"
  else
    echo "  (skipping notarization — set NOTARY_PROFILE env var to enable)"
  fi
else
  echo "▸ WARN: '${SIGN_IDENTITY}' not found — falling back to ad-hoc."
  echo "       End users will get keychain password prompts."
  codesign --force --sign - --timestamp=none --deep "${BUNDLE}" 2>/dev/null || true
  codesign --verify --deep --strict "${BUNDLE}" 2>/dev/null || echo "  (signature verify skipped)"
fi

ZIP_NAME="UpworkBuddy-${VERSION}.zip"
ZIP_PATH="${DIST_DIR}/${ZIP_NAME}"
echo "▸ Packaging ${ZIP_NAME}..."
(cd "${DIST_DIR}" && /usr/bin/ditto -c -k --keepParent "${BUNDLE_NAME}" "${ZIP_NAME}")

echo ""
echo "✓ Built ${ZIP_PATH}"
ls -la "${DIST_DIR}"
