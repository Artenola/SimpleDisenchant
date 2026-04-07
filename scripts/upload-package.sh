#!/usr/bin/env bash
#
# upload-package.sh — Upload an addon zip to CurseForge and Wago.
#
# Environment variables:
#   ARCHIVE          : Required. Path to the zip file.
#   VERSION          : Required. Version string (e.g. "1.6.0-beta-abc1234").
#   RELEASE_TYPE     : Required. One of: alpha | beta | release
#   CF_API_KEY       : Optional. CurseForge API token. If empty, CF upload is skipped.
#   WAGO_API_TOKEN   : Optional. Wago API token. If empty, Wago upload is skipped.
#   CF_PROJECT_ID    : Optional. Default: 1445028
#   WAGO_PROJECT_ID  : Optional. Default: QKy9q4K7
#   CHANGELOG_BODY   : Optional. Changelog text to include with upload.
#

set -euo pipefail

ARCHIVE="${ARCHIVE:?ARCHIVE is required}"
VERSION="${VERSION:?VERSION is required}"
RELEASE_TYPE="${RELEASE_TYPE:?RELEASE_TYPE is required}"
CF_PROJECT_ID="${CF_PROJECT_ID:-1445028}"
WAGO_PROJECT_ID="${WAGO_PROJECT_ID:-QKy9q4K7}"
CHANGELOG_BODY="${CHANGELOG_BODY:-Release $VERSION}"
LABEL="v$VERSION"

TOPDIR="$(cd "$(dirname "$0")/.." && pwd)"
TOC_FILE="$TOPDIR/SimpleDisenchant.toc"

if [[ ! -f "$ARCHIVE" ]]; then
  echo "ERROR: archive not found: $ARCHIVE" >&2
  exit 1
fi

case "$RELEASE_TYPE" in
  alpha|beta|release) ;;
  *) echo "ERROR: invalid RELEASE_TYPE: $RELEASE_TYPE" >&2; exit 1 ;;
esac

# ──────────────────────────────────────────────
# Parse Interface numbers from TOC → patch strings
# Example: 120001 → "12.0.1"
# ──────────────────────────────────────────────
interface_to_patch() {
  local n="${1// /}"
  local major=$((n / 10000))
  local minor=$(( (n / 100) % 100 ))
  local patch=$((n % 100))
  echo "${major}.${minor}.${patch}"
}

INTERFACE_LINE=$(grep -m1 -E '^## Interface:' "$TOC_FILE" | sed 's/^## Interface:[[:space:]]*//')
if [[ -z "$INTERFACE_LINE" ]]; then
  echo "ERROR: could not read ## Interface: from $TOC_FILE" >&2
  exit 1
fi

IFS=',' read -ra INTERFACE_NUMS <<< "$INTERFACE_LINE"
PATCHES=()
for n in "${INTERFACE_NUMS[@]}"; do
  PATCHES+=("$(interface_to_patch "$n")")
done

echo "==> Upload configuration"
echo "    Archive      : $(basename "$ARCHIVE")"
echo "    Version      : $VERSION"
echo "    Release type : $RELEASE_TYPE"
echo "    Game patches : ${PATCHES[*]}"
echo ""

# ──────────────────────────────────────────────
# CurseForge upload
# ──────────────────────────────────────────────
upload_curseforge() {
  if [[ -z "${CF_API_KEY:-}" ]]; then
    echo "==> CurseForge: skipped (no CF_API_KEY)"
    return 0
  fi

  echo "==> CurseForge: fetching game version list"
  local versions_json
  versions_json=$(curl -sS -H "x-api-token: $CF_API_KEY" \
    "https://wow.curseforge.com/api/game/wow/versions")

  if [[ -z "$versions_json" || "$versions_json" == *"errorMessage"* ]]; then
    echo "ERROR: could not fetch CurseForge game versions" >&2
    echo "$versions_json" >&2
    return 1
  fi

  # gameVersionTypeID 517 = retail
  local ids=()
  local matched=()
  for patch in "${PATCHES[@]}"; do
    local id
    id=$(jq -r --arg v "$patch" \
      '.[] | select(.gameVersionTypeID == 517 and .name == $v) | .id' \
      <<<"$versions_json" | head -1)

    if [[ -z "$id" ]]; then
      # fallback: highest retail version that is <= requested
      id=$(jq -r --arg v "$patch" \
        '[.[] | select(.gameVersionTypeID == 517 and .name <= $v)] | max_by(.id) | .id // empty' \
        <<<"$versions_json")
      if [[ -n "$id" ]]; then
        local name
        name=$(jq -r --argjson id "$id" '.[] | select(.id == $id) | .name' <<<"$versions_json")
        echo "    WARN: no exact CurseForge match for $patch, using $name (id=$id)"
        matched+=("$name")
      else
        echo "    WARN: no CurseForge version match for $patch, skipping"
        continue
      fi
    else
      matched+=("$patch")
    fi
    ids+=("$id")
  done

  if [[ ${#ids[@]} -eq 0 ]]; then
    echo "ERROR: no valid CurseForge game versions resolved" >&2
    return 1
  fi

  local game_versions_json
  game_versions_json="[$(IFS=,; echo "${ids[*]}")]"

  local payload
  payload=$(jq -n \
    --arg label "$LABEL" \
    --argjson versions "$game_versions_json" \
    --arg type "$RELEASE_TYPE" \
    --arg changelog "$CHANGELOG_BODY" \
    '{displayName: $label, gameVersions: $versions, releaseType: $type, changelog: $changelog, changelogType: "markdown"}')

  echo "    Uploading $(basename "$ARCHIVE") (${matched[*]} $RELEASE_TYPE)"

  local tmpfile http_code
  tmpfile=$(mktemp)
  http_code=$(curl -sS -o "$tmpfile" -w '%{http_code}' \
    --retry 3 --retry-delay 5 \
    -H "x-api-token: $CF_API_KEY" \
    -F "metadata=$payload" \
    -F "file=@$ARCHIVE" \
    "https://wow.curseforge.com/api/projects/$CF_PROJECT_ID/upload-file") || true

  if [[ "$http_code" == "200" ]]; then
    echo "    ✓ CurseForge: Success"
    rm -f "$tmpfile"
    return 0
  else
    echo "    ✗ CurseForge: Error ($http_code)" >&2
    [[ -s "$tmpfile" ]] && cat "$tmpfile" >&2
    rm -f "$tmpfile"
    return 1
  fi
}

# ──────────────────────────────────────────────
# Wago upload
# ──────────────────────────────────────────────
upload_wago() {
  if [[ -z "${WAGO_API_TOKEN:-}" ]]; then
    echo "==> Wago: skipped (no WAGO_API_TOKEN)"
    return 0
  fi

  echo "==> Wago: fetching game version list"
  local wago_json wago_patches
  wago_json=$(curl -sS "https://addons.wago.io/api/data/game")
  wago_patches=$(jq -c '.patches.retail // empty' <<<"$wago_json")

  if [[ -z "$wago_patches" || "$wago_patches" == "null" ]]; then
    echo "ERROR: could not fetch Wago patch list" >&2
    return 1
  fi

  local supported=()
  for patch in "${PATCHES[@]}"; do
    if jq -e --arg v "$patch" 'index($v) != null' <<<"$wago_patches" &>/dev/null; then
      supported+=("$patch")
    else
      # fallback: highest <= patch
      local fallback
      fallback=$(jq -r --arg v "$patch" 'map(select(. <= $v)) | max // empty' <<<"$wago_patches")
      if [[ -n "$fallback" ]]; then
        echo "    WARN: Wago has no $patch, using $fallback"
        supported+=("$fallback")
      else
        echo "    WARN: no Wago version match for $patch, skipping"
      fi
    fi
  done

  if [[ ${#supported[@]} -eq 0 ]]; then
    echo "ERROR: no valid Wago game versions resolved" >&2
    return 1
  fi

  local stability="$RELEASE_TYPE"
  [[ "$stability" == "release" ]] && stability="stable"

  local supported_json
  supported_json=$(printf '%s\n' "${supported[@]}" | jq -R . | jq -cs .)

  local payload
  payload=$(jq -n \
    --arg label "$LABEL" \
    --argjson supported "$supported_json" \
    --arg stability "$stability" \
    --arg changelog "$CHANGELOG_BODY" \
    '{label: $label, supported_retail_patches: $supported, stability: $stability, changelog: $changelog}')

  echo "    Uploading $(basename "$ARCHIVE") (${supported[*]} $stability)"

  local tmpfile http_code
  tmpfile=$(mktemp)
  http_code=$(curl -sS -o "$tmpfile" -w '%{http_code}' \
    --retry 3 --retry-delay 5 \
    -H "authorization: Bearer $WAGO_API_TOKEN" \
    -H "accept: application/json" \
    -F "metadata=$payload" \
    -F "file=@$ARCHIVE" \
    "https://addons.wago.io/api/projects/$WAGO_PROJECT_ID/version") || true

  if [[ "$http_code" == "200" || "$http_code" == "201" ]]; then
    echo "    ✓ Wago: Success"
    rm -f "$tmpfile"
    return 0
  else
    echo "    ✗ Wago: Error ($http_code)" >&2
    [[ -s "$tmpfile" ]] && cat "$tmpfile" >&2
    rm -f "$tmpfile"
    return 1
  fi
}

# ──────────────────────────────────────────────
# Run
# ──────────────────────────────────────────────
rc=0
upload_curseforge || rc=1
echo ""
upload_wago || rc=1
echo ""

exit $rc
