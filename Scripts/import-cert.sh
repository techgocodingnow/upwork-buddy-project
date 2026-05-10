#!/usr/bin/env bash
# Import a Developer ID p12 cert into the login keychain from .env values.
#
# Usage: Scripts/import-cert.sh
#
# Requires .env at repo root with:
#   BUILD_CERTIFICATE_BASE64=<base64 of .p12>
#   P12_PASSWORD=<p12 export password>

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ROOT}/.env"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "ERROR: ${ENV_FILE} not found." >&2
  echo "       Create it with BUILD_CERTIFICATE_BASE64= and P12_PASSWORD=" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a

: "${BUILD_CERTIFICATE_BASE64:?BUILD_CERTIFICATE_BASE64 missing in .env}"
: "${P12_PASSWORD:?P12_PASSWORD missing in .env}"

CERT_TMP="$(mktemp -t upworkbuddy-cert.XXXXXX.p12)"
trap 'rm -f "${CERT_TMP}"' EXIT

echo "${BUILD_CERTIFICATE_BASE64}" | base64 --decode > "${CERT_TMP}"

LOGIN_KC="${HOME}/Library/Keychains/login.keychain-db"

echo "▸ Importing into ${LOGIN_KC}..."
security import "${CERT_TMP}" \
  -P "${P12_PASSWORD}" \
  -A -t cert -f pkcs12 \
  -k "${LOGIN_KC}"

echo "▸ Setting partition list (codesign access)..."
KC_PASS_PROMPT=""
read -r -s -p "Login keychain password (for set-key-partition-list): " KC_PASS_PROMPT
echo
security set-key-partition-list \
  -S apple-tool:,apple:,codesign: \
  -s -k "${KC_PASS_PROMPT}" \
  "${LOGIN_KC}" >/dev/null

echo "▸ Verifying..."
if security find-identity -v -p codesigning "${LOGIN_KC}" | grep -q "Developer ID Application"; then
  security find-identity -v -p codesigning "${LOGIN_KC}" | grep "Developer ID Application"
  echo "✓ Cert imported."
else
  echo "ERROR: cert not found after import." >&2
  exit 1
fi
