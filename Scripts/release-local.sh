#!/usr/bin/env bash
# Mirror CI release flow locally for validation before tagging.
#
# Usage:
#   Scripts/release-local.sh [--notarize] [--staple]
#
# Output goes to build/local/ (gitignored).
# Requires:
#   - Developer ID Application cert in login keychain
#   - create-dmg + jq installed (`brew install create-dmg jq`)
#   - For --notarize: notarytool profile 'AI_DEVTOOLS_NOTARY' stored
#       (xcrun notarytool store-credentials AI_DEVTOOLS_NOTARY \
#         --apple-id X --team-id Y --password Z)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

NOTARIZE=0
STAPLE=0
for arg in "$@"; do
  case "$arg" in
    --notarize) NOTARIZE=1 ;;
    --staple)   STAPLE=1 ;;
    *) echo "Unknown arg: $arg" >&2; exit 2 ;;
  esac
done

TEAM_ID="L23PD654Q3"
SIGN_IDENTITY="${SIGN_IDENTITY:-Developer ID Application: I Le Duc (${TEAM_ID})}"
NOTARY_PROFILE="AI_DEVTOOLS_NOTARY"
LOCAL_OUT="${ROOT}/build/local"

# Pre-flight
echo "▸ Pre-flight checks..."
command -v create-dmg >/dev/null || { echo "ERROR: install via 'brew install create-dmg'"; exit 1; }
command -v jq         >/dev/null || { echo "ERROR: install via 'brew install jq'"; exit 1; }
if ! security find-identity -v -p codesigning | grep -qF "${TEAM_ID}"; then
  echo "ERROR: no Developer ID cert for team ${TEAM_ID} in keychain" >&2
  exit 1
fi
if [[ "${NOTARIZE}" -eq 1 ]]; then
  echo "  (notarytool profile '${NOTARY_PROFILE}' will be validated on first submit)"
fi

VERSION="$(cat VERSION 2>/dev/null || echo "dev-$(date +%Y%m%d%H%M%S)")"

echo "▸ Building + signing v${VERSION}..."
SIGN_IDENTITY="${SIGN_IDENTITY}" \
  Scripts/package-app.sh "${VERSION}"

BUNDLE="${ROOT}/.build/dist/UpworkBuddy.app"

echo "▸ Verifying signing..."
codesign -dv --verbose=4 "${BUNDLE}" 2>&1 | tee /tmp/cs-local.txt
grep -q "flags=.*runtime" /tmp/cs-local.txt || { echo "ERROR: hardened runtime missing"; exit 1; }
grep -q "Timestamp="      /tmp/cs-local.txt || { echo "ERROR: secure timestamp missing"; exit 1; }
codesign --verify --deep --strict --verbose=2 "${BUNDLE}"

echo "▸ Creating DMG..."
mkdir -p "${LOCAL_OUT}"
DMG_PATH="${LOCAL_OUT}/UpworkBuddy-${VERSION}.dmg"
rm -f "${DMG_PATH}"
create-dmg \
  --volname "UpworkBuddy ${VERSION}" \
  --window-pos 200 120 \
  --window-size 640 400 \
  --icon-size 100 \
  --icon "UpworkBuddy.app" 180 180 \
  --hide-extension "UpworkBuddy.app" \
  --app-drop-link 460 180 \
  --no-internet-enable \
  "${DMG_PATH}" \
  "${BUNDLE}"
codesign --force --sign "${SIGN_IDENTITY}" --timestamp "${DMG_PATH}"

if [[ "${NOTARIZE}" -eq 1 ]]; then
  echo "▸ Notarizing DMG (this may take several minutes)..."
  set +e
  OUT=$(xcrun notarytool submit "${DMG_PATH}" \
    --keychain-profile "${NOTARY_PROFILE}" \
    --output-format json --wait)
  RC=$?
  echo "${OUT}"
  STATUS=$(echo "${OUT}" | jq -r '.status // empty')
  SUB_ID=$(echo "${OUT}" | jq -r '.id // empty')
  set -e
  if [[ "${STATUS}" != "Accepted" || "${RC}" -ne 0 ]]; then
    echo "ERROR: notarization failed: ${STATUS}" >&2
    [[ -n "${SUB_ID}" ]] && xcrun notarytool log "${SUB_ID}" --keychain-profile "${NOTARY_PROFILE}"
    exit 1
  fi
fi

if [[ "${STAPLE}" -eq 1 ]]; then
  echo "▸ Stapling..."
  xcrun stapler staple "${DMG_PATH}"
  xcrun stapler validate "${DMG_PATH}"
  spctl -a -t open --context context:primary-signature -vv "${DMG_PATH}" || true
fi

echo ""
echo "✓ ${DMG_PATH}"
ls -la "${LOCAL_OUT}"
