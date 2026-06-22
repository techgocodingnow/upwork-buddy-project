#!/usr/bin/env bash
# sign-and-publish-appcast.sh
#
# Signs a release DMG with the Sparkle EdDSA private key, then prepends a new
# <item> entry to appcast.xml on the gh-pages branch.
#
# Usage:
#   sign-and-publish-appcast.sh <version> <build> <dmg-path> <release-tag>
#
# Required env:
#   SPARKLE_PRIVATE_KEY     base64 EdDSA private key (NOT the public key)
#   SPARKLE_BIN             path to Sparkle's bin directory containing
#                           `sign_update` (defaults to .build/artifacts/sparkle/Sparkle/bin
#                           — Sparkle 2.x ships sign_update as a binary artifact)
#
# Optional env:
#   GITHUB_REPOSITORY       e.g. techgocodingnow/upwork-buddy-project
#                           (defaults from GitHub Actions; required when run locally)
#   APPCAST_BRANCH          defaults to gh-pages
set -euo pipefail

VERSION="${1:?version required, e.g. 3.1.2}"
BUILD="${2:?build number required, e.g. 16}"
DMG_PATH="${3:?path to signed/notarized DMG required}"
TAG="${4:?release git tag required, e.g. v3.1.2}"

REPO="${GITHUB_REPOSITORY:-techgocodingnow/upwork-buddy-project}"
APPCAST_BRANCH="${APPCAST_BRANCH:-gh-pages}"
SPARKLE_BIN="${SPARKLE_BIN:-.build/artifacts/sparkle/Sparkle/bin}"

if [ ! -f "$DMG_PATH" ]; then
  echo "::error::DMG not found at $DMG_PATH" >&2
  exit 1
fi

if [ -z "${SPARKLE_PRIVATE_KEY:-}" ]; then
  echo "::error::SPARKLE_PRIVATE_KEY env not set" >&2
  exit 1
fi

# Sign the DMG. sign_update reads the private key file via --ed-key-file.
PRIVKEY_FILE="$(mktemp)"
trap 'rm -f "$PRIVKEY_FILE"' EXIT
printf '%s' "$SPARKLE_PRIVATE_KEY" > "$PRIVKEY_FILE"

if [ ! -x "$SPARKLE_BIN/sign_update" ]; then
  echo "::error::sign_update not found at $SPARKLE_BIN/sign_update" >&2
  echo "Run \`swift package resolve\` first to fetch Sparkle." >&2
  exit 1
fi

SIG_LINE="$("$SPARKLE_BIN/sign_update" "$DMG_PATH" --ed-key-file "$PRIVKEY_FILE")"
# SIG_LINE format: sparkle:edSignature="..." length="..."
if [[ ! "$SIG_LINE" =~ sparkle:edSignature= ]]; then
  echo "::error::sign_update produced unexpected output: $SIG_LINE" >&2
  exit 1
fi

ED_SIG="$(printf '%s' "$SIG_LINE" | sed -nE 's/.*sparkle:edSignature="([^"]+)".*/\1/p')"
LENGTH="$(printf '%s' "$SIG_LINE" | sed -nE 's/.*length="?([0-9]+)"?.*/\1/p')"
if [ -z "$ED_SIG" ] || [ -z "$LENGTH" ]; then
  echo "::error::could not parse sign_update output: $SIG_LINE" >&2
  exit 1
fi

DMG_FILENAME="$(basename "$DMG_PATH")"
DMG_URL="https://github.com/${REPO}/releases/download/${TAG}/${DMG_FILENAME}"
PUB_DATE="$(date -u +'%a, %d %b %Y %H:%M:%S +0000')"

# Build the new <item>.
NEW_ITEM=$(cat <<XML
    <item>
      <title>Version ${VERSION}</title>
      <sparkle:shortVersionString>${VERSION}</sparkle:shortVersionString>
      <sparkle:version>${BUILD}</sparkle:version>
      <sparkle:minimumSystemVersion>14.0</sparkle:minimumSystemVersion>
      <pubDate>${PUB_DATE}</pubDate>
      <enclosure url="${DMG_URL}"
                 type="application/x-apple-diskimage"
                 length="${LENGTH}"
                 sparkle:edSignature="${ED_SIG}" />
    </item>
XML
)

# Check out the appcast branch into a temp worktree, prepend, commit, push.
ROOT="$(git rev-parse --show-toplevel)"
WORKTREE_DIR="$(mktemp -d)"
trap 'rm -rf "$PRIVKEY_FILE" "$WORKTREE_DIR"' EXIT

# Set git identity (works in CI without a global config).
git config user.email "${GIT_AUTHOR_EMAIL:-actions@github.com}"
git config user.name  "${GIT_AUTHOR_NAME:-github-actions[bot]}"

# Fetch the branch — create from a clean orphan if it doesn't exist yet.
if git ls-remote --exit-code --heads origin "$APPCAST_BRANCH" >/dev/null 2>&1; then
  git fetch origin "$APPCAST_BRANCH":"$APPCAST_BRANCH" || true
  git worktree add "$WORKTREE_DIR" "$APPCAST_BRANCH"
else
  git worktree add --detach "$WORKTREE_DIR"
  ( cd "$WORKTREE_DIR" && git checkout --orphan "$APPCAST_BRANCH" && git rm -rf . >/dev/null 2>&1 || true )
fi

APPCAST="$WORKTREE_DIR/appcast.xml"
if [ ! -f "$APPCAST" ]; then
  cp "$ROOT/appcast/appcast.xml" "$APPCAST"
fi

# Insert NEW_ITEM directly after the <channel ...> element open tag and
# its leading siblings — i.e. before the first existing <item> if present,
# otherwise before </channel>.
TMP="$(mktemp)"
# Pass the multiline item through the environment, not `awk -v`: awk's -v
# assignment runs escape processing and rejects literal newlines ("newline in
# string"), which silently broke appcast publishing. ENVIRON reads the value
# verbatim, newlines included.
export NEW_ITEM
awk '
  BEGIN { inserted=0 }
  !inserted && /<item>/ { print ENVIRON["NEW_ITEM"]; inserted=1 }
  !inserted && /<\/channel>/ { print ENVIRON["NEW_ITEM"]; inserted=1 }
  { print }
  END {
    if (!inserted) {
      print "ERROR: failed to insert into appcast.xml" > "/dev/stderr"
      exit 1
    }
  }
' "$APPCAST" > "$TMP"
mv "$TMP" "$APPCAST"

# Commit + push.
(
  cd "$WORKTREE_DIR"
  git add appcast.xml
  git commit -m "appcast: ${TAG} (${VERSION} build ${BUILD})"
  git push origin "HEAD:${APPCAST_BRANCH}"
)

git worktree remove --force "$WORKTREE_DIR"

echo "Published appcast entry for ${TAG}"
echo "  edSignature: ${ED_SIG}"
echo "  length:      ${LENGTH}"
echo "  enclosure:   ${DMG_URL}"
