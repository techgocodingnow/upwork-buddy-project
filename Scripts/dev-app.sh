#!/usr/bin/env bash
# Wraps the debug binary in a minimal .app bundle for menu-bar testing.
# Faster than package-app.sh — no universal build, no signing, no notarization.
#
# Usage: Scripts/dev-app.sh   (then: open .build/dev/UpworkBuddy.app)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEV_DIR="${ROOT}/.build/dev"
BUNDLE="${DEV_DIR}/UpworkBuddy.app"
EXECUTABLE_NAME="UpworkBuddy"
APP_ICON="${ROOT}/Sources/UpworkBuddy/Resources/GeneratedBrand/UpworkBuddy.icns"

cd "${ROOT}"

echo "▸ swift build (debug)..."
swift build

BIN_PATH=$(swift build --show-bin-path)
BUILT_BINARY="${BIN_PATH}/${EXECUTABLE_NAME}"

echo "▸ Assembling dev bundle..."
rm -rf "${BUNDLE}"
mkdir -p "${BUNDLE}/Contents/MacOS"
mkdir -p "${BUNDLE}/Contents/Resources"
cp "${BUILT_BINARY}" "${BUNDLE}/Contents/MacOS/${EXECUTABLE_NAME}"

RESOURCE_BUNDLE="${BIN_PATH}/UpworkBuddy_UpworkBuddy.bundle"
if [[ -d "${RESOURCE_BUNDLE}" ]]; then
  cp -R "${RESOURCE_BUNDLE}" "${BUNDLE}/Contents/Resources/"
fi

if [[ -f "${APP_ICON}" ]]; then
  cp "${APP_ICON}" "${BUNDLE}/Contents/Resources/UpworkBuddy.icns"
fi

cat > "${BUNDLE}/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleDisplayName</key>
    <string>UpworkBuddy (dev)</string>
    <key>CFBundleExecutable</key>
    <string>UpworkBuddy</string>
    <key>CFBundleIdentifier</key>
    <string>com.upworkbuddy.app.dev</string>
    <key>CFBundleIconFile</key>
    <string>UpworkBuddy</string>
    <key>CFBundleName</key>
    <string>UpworkBuddy</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>dev</string>
    <key>CFBundleVersion</key>
    <string>dev</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
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
          <string>upworkbuddy</string>
        </array>
      </dict>
    </array>
</dict>
</plist>
PLIST

cat > "${BUNDLE}/Contents/PkgInfo" <<'PKG'
APPL????
PKG

codesign --force --sign - --deep "${BUNDLE}" 2>/dev/null || true

echo "✓ Built ${BUNDLE}"
echo "  open ${BUNDLE}"
