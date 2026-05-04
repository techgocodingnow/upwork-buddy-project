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
swift build -c release --arch arm64 --arch x86_64

BIN_PATH=$(swift build -c release --arch arm64 --arch x86_64 --show-bin-path)
BUILT_BINARY="${BIN_PATH}/${EXECUTABLE_NAME}"
if [[ ! -x "${BUILT_BINARY}" ]]; then
  echo "Binary not found at ${BUILT_BINARY}" >&2
  exit 1
fi

echo "▸ Assembling ${BUNDLE_NAME}..."
BUNDLE="${DIST_DIR}/${BUNDLE_NAME}"
mkdir -p "${BUNDLE}/Contents/MacOS"
mkdir -p "${BUNDLE}/Contents/Resources"
cp "${BUILT_BINARY}" "${BUNDLE}/Contents/MacOS/${EXECUTABLE_NAME}"

# Copy SwiftPM-generated resource bundle (contains Config.plist) into the app bundle.
RESOURCE_BUNDLE="${BIN_PATH}/UpworkBuddy_UpworkBuddy.bundle"
if [[ -d "${RESOURCE_BUNDLE}" ]]; then
  cp -R "${RESOURCE_BUNDLE}" "${BUNDLE}/Contents/Resources/"
fi

cat > "${BUNDLE}/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleDisplayName</key>
    <string>UpworkBuddy</string>
    <key>CFBundleExecutable</key>
    <string>${EXECUTABLE_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${EXECUTABLE_NAME}</string>
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

echo "▸ Ad-hoc signing..."
codesign --force --sign - --timestamp=none --deep "${BUNDLE}" 2>/dev/null || true
codesign --verify --deep --strict "${BUNDLE}" 2>/dev/null || echo "  (signature verify skipped)"

ZIP_NAME="UpworkBuddy-${VERSION}.zip"
ZIP_PATH="${DIST_DIR}/${ZIP_NAME}"
echo "▸ Packaging ${ZIP_NAME}..."
(cd "${DIST_DIR}" && /usr/bin/ditto -c -k --keepParent "${BUNDLE_NAME}" "${ZIP_NAME}")

echo ""
echo "✓ Built ${ZIP_PATH}"
ls -la "${DIST_DIR}"
