#!/usr/bin/env bash
# Loads release signing secrets from a local .env and pushes them to the
# GitHub repo with `gh secret set`. The two file-based secrets (Config.plist
# and the .p12 cert) are base64-encoded here so .env only holds paths, never
# binary blobs.
#
# Usage: Scripts/set-github-secrets.sh [path-to-env]   (default: .env)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

ENV_FILE="${1:-.env}"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "ERROR: ${ENV_FILE} not found. Copy .env.example to .env and fill it in." >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "ERROR: gh CLI not found." >&2
  exit 1
fi

# Load .env into the environment (ignores comments/blank lines).
set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a

set_secret() {
  local name="$1" value="$2"
  if [[ -z "${value}" ]]; then
    echo "skip  ${name} (empty)"
    return
  fi
  printf '%s' "${value}" | gh secret set "${name}"
  echo "set   ${name}"
}

set_secret_from_file_b64() {
  local name="$1" path="$2"
  if [[ -z "${path}" ]]; then
    echo "skip  ${name} (no path)"
    return
  fi
  if [[ ! -f "${path}" ]]; then
    echo "ERROR: ${name}: file '${path}' not found" >&2
    exit 1
  fi
  base64 -i "${path}" | gh secret set "${name}"
  echo "set   ${name} (base64 of ${path})"
}

# A base64 secret may be provided two ways: inline (NAME_BASE64 already holds
# the blob) or as a file path (we encode it here). Inline wins when both exist.
set_b64_secret() {
  local name="$1" inline="$2" path="$3"
  if [[ -n "${inline}" ]]; then
    set_secret "${name}" "${inline}"
  else
    set_secret_from_file_b64 "${name}" "${path}"
  fi
}

echo "Setting secrets for $(gh repo view --json nameWithOwner -q .nameWithOwner)"
echo ""

set_b64_secret CONFIG_PLIST_BASE64      "${CONFIG_PLIST_BASE64:-}"    "${CONFIG_PLIST_PATH:-}"
set_b64_secret BUILD_CERTIFICATE_BASE64 "${BUILD_CERTIFICATE_BASE64:-}" "${P12_PATH:-}"
set_secret P12_PASSWORD       "${P12_PASSWORD:-}"
set_secret KEYCHAIN_PASSWORD  "${KEYCHAIN_PASSWORD:-}"
set_secret NOTARY_APPLE_ID    "${NOTARY_APPLE_ID:-}"
set_secret NOTARY_TEAM_ID     "${NOTARY_TEAM_ID:-}"
set_secret NOTARY_PASSWORD    "${NOTARY_PASSWORD:-}"
set_secret SPARKLE_PRIVATE_KEY "${SPARKLE_PRIVATE_KEY:-}"

echo ""
echo "Done. Verify with: gh secret list"
echo "Then release:      gh workflow run release.yml -f tag=v1.0.0"
