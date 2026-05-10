#!/usr/bin/env bash
# Bumps version + creates annotated tag locally. Does NOT push.
#
# Usage: Scripts/release.sh <MAJOR.MINOR.PATCH[-PRERELEASE]>
#
# After running, review the commit/tag and push manually:
#   git push origin main && git push origin v<version>

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <MAJOR.MINOR.PATCH[-PRERELEASE]>" >&2
  exit 2
fi

VERSION="$1"
TAG="v${VERSION}"

if ! [[ "${VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.]+)?$ ]]; then
  echo "ERROR: version '${VERSION}' must match MAJOR.MINOR.PATCH[-PRERELEASE]" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: working tree is not clean. Commit or stash changes first." >&2
  git status --short
  exit 1
fi

if git rev-parse "${TAG}" >/dev/null 2>&1; then
  echo "ERROR: tag ${TAG} already exists." >&2
  exit 1
fi

VERSION_FILE="${ROOT}/VERSION"
echo "${VERSION}" > "${VERSION_FILE}"
git add "${VERSION_FILE}"
git commit -m "chore: release ${TAG}"
git tag -a "${TAG}" -m "UpworkBuddy ${VERSION}"

echo ""
echo "✓ Created commit + tag ${TAG}"
echo ""
echo "Next:"
echo "  git push origin main"
echo "  git push origin ${TAG}"
echo ""
echo "CI will build, sign, notarize, and publish the GitHub release."
