#!/usr/bin/env bash
#
# build-package.sh — Build a zip archive of the addon with externals.
#
# Environment variables:
#   VERSION         : Required. Version string (e.g. "1.6.0-alpha-abc1234")
#   SKIP_EXTERNALS  : Optional. Set to "true" to skip fetching external libs.
#
# Outputs (GitHub Actions):
#   archive         : Absolute path to the generated zip file
#   package_name    : Package (folder) name inside the zip
#

set -euo pipefail

VERSION="${VERSION:?VERSION is required}"
TOPDIR="$(cd "$(dirname "$0")/.." && pwd)"
PKG_NAME="SimpleDisenchant"
BUILD_DIR="$TOPDIR/.build"
STAGE_DIR="$BUILD_DIR/$PKG_NAME"

echo "==> Building $PKG_NAME $VERSION"

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$STAGE_DIR"

# ──────────────────────────────────────────────
# Read ignore list from pkgmeta.yaml
# ──────────────────────────────────────────────
RSYNC_EXCLUDES=(--exclude ".build" --exclude ".release" --exclude ".git")
while IFS= read -r pattern; do
  [[ -z "$pattern" ]] && continue
  RSYNC_EXCLUDES+=(--exclude "$pattern")
done < <(awk '
  /^ignore:/ { in_section=1; next }
  in_section && /^[^[:space:]-]/ { in_section=0 }
  in_section && /^[[:space:]]*-/ {
    gsub(/^[[:space:]]*-[[:space:]]*/, "")
    gsub(/^["'\'']|["'\'']$/, "")
    print
  }
' "$TOPDIR/pkgmeta.yaml")

echo "==> Copying source files"
rsync -a "${RSYNC_EXCLUDES[@]}" "$TOPDIR/" "$STAGE_DIR/"

# ──────────────────────────────────────────────
# Fetch externals
# ──────────────────────────────────────────────
if [[ "${SKIP_EXTERNALS:-false}" != "true" ]]; then
  echo "==> Fetching externals"

  # Libs/LibStub (svn)
  echo "  - Libs/LibStub (svn)"
  mkdir -p "$STAGE_DIR/Libs"
  rm -rf "$STAGE_DIR/Libs/LibStub"
  svn export -q --force https://repos.curseforge.com/wow/libstub/trunk "$STAGE_DIR/Libs/LibStub"

  # Libs/LibDataBroker-1.1 (git, latest)
  echo "  - Libs/LibDataBroker-1.1 (git)"
  tmp_ldb=$(mktemp -d)
  git clone --depth 1 -q https://github.com/tekkub/libdatabroker-1-1 "$tmp_ldb"
  rm -rf "$STAGE_DIR/Libs/LibDataBroker-1.1"
  mkdir -p "$STAGE_DIR/Libs/LibDataBroker-1.1"
  # Copy everything except .git
  (shopt -s dotglob; cp -r "$tmp_ldb"/* "$STAGE_DIR/Libs/LibDataBroker-1.1/")
  rm -rf "$STAGE_DIR/Libs/LibDataBroker-1.1/.git" \
         "$STAGE_DIR/Libs/LibDataBroker-1.1/.gitignore"
  rm -rf "$tmp_ldb"
else
  echo "==> Skipping externals (SKIP_EXTERNALS=true)"
fi

# ──────────────────────────────────────────────
# Create zip
# ──────────────────────────────────────────────
ARCHIVE_NAME="$PKG_NAME-$VERSION.zip"
ARCHIVE="$BUILD_DIR/$ARCHIVE_NAME"

echo "==> Creating archive: $ARCHIVE_NAME"
(cd "$BUILD_DIR" && zip -rq "$ARCHIVE_NAME" "$PKG_NAME")

echo ""
echo "✓ Archive created: $ARCHIVE"
ls -lh "$ARCHIVE"

# ──────────────────────────────────────────────
# GitHub Actions outputs
# ──────────────────────────────────────────────
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "archive=$ARCHIVE" >> "$GITHUB_OUTPUT"
  echo "archive_name=$ARCHIVE_NAME" >> "$GITHUB_OUTPUT"
  echo "package_name=$PKG_NAME" >> "$GITHUB_OUTPUT"
fi
