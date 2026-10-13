#!/usr/bin/env bash
set -euo pipefail

ROOT="$HOME/.local/share/cursor-hebrew"
VERSIONS="$HOME/.local/share/cursor-agent/versions"
BIN_DIR="$HOME/.local/bin"

resolve_version_dir() {
  local link="$BIN_DIR/agent"
  if [ -L "$link" ]; then
    dirname "$(realpath "$link")"
    return
  fi
  local latest=""
  local dir
  for dir in "$VERSIONS"/20*; do
    [ -x "$dir/cursor-agent" ] || continue
    latest="$dir"
  done
  if [ -z "$latest" ]; then
    echo "cursor-hebrew: Cursor Agent is not installed" >&2
    exit 1
  fi
  printf '%s\n' "$latest"
}

VERSION_DIR="$(resolve_version_dir)"
if [ -x "$VERSION_DIR/node" ]; then
  "$VERSION_DIR/node" "$ROOT/patch.js" "$VERSION_DIR" || true
fi

if [ -L "$BIN_DIR/agent" ] || [ ! -f "$BIN_DIR/agent" ]; then
  "$ROOT/install-bins.sh" || true
fi

INVOKED="${CURSOR_HEBREW_INVOKED_AS:-agent}"
exec -a "$INVOKED" "$VERSION_DIR/cursor-agent" "$@"
