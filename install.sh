#!/usr/bin/env bash
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.local/share/cursor-hebrew"
mkdir -p "$DEST" "$HOME/.local/bin"

if [ "$SRC" != "$DEST" ]; then
  cp "$SRC/hebrew-bidi.js" "$SRC/hebrew-reorder.js" "$SRC/patch.js" \
    "$SRC/run.sh" "$SRC/install-bins.sh" "$SRC/install.sh" "$DEST/"
fi
chmod +x "$DEST/run.sh" "$DEST/install-bins.sh" "$DEST/install.sh" "$DEST/patch.js"
"$DEST/install-bins.sh"

SNIPPET_MARK="cursor-hebrew/install-bins.sh"
SNIPPET=$(cat << 'EOF'

# Cursor Agent Hebrew. An update puts the stock shortcut back; the next shell restores it.
if [ -L "$HOME/.local/bin/agent" ] && [ -x "$HOME/.local/share/cursor-hebrew/install-bins.sh" ]; then
  "$HOME/.local/share/cursor-hebrew/install-bins.sh"
fi
agent() { CURSOR_HEBREW_INVOKED_AS=agent "$HOME/.local/share/cursor-hebrew/run.sh" "$@"; }
cursor-agent() { CURSOR_HEBREW_INVOKED_AS=cursor-agent "$HOME/.local/share/cursor-hebrew/run.sh" "$@"; }
EOF
)

add_snippet() {
  local file="$1"
  [ -f "$file" ] || return 0
  if grep -q "$SNIPPET_MARK" "$file"; then
    return 0
  fi
  printf '%s\n' "$SNIPPET" >> "$file"
  echo "Added the Hebrew shortcut to $file"
}

add_snippet "$HOME/.zshrc"
add_snippet "$HOME/.bashrc"

VERSIONS="$HOME/.local/share/cursor-agent/versions"
latest=""
for dir in "$VERSIONS"/20*; do
  [ -x "$dir/node" ] || continue
  latest="$dir"
done
if [ -n "$latest" ]; then
  "$latest/node" "$DEST/patch.js" "$latest" || true
  echo "Hebrew is on for $(basename "$latest")"
else
  echo "Cursor Agent is not installed yet. Install it, then run: agent"
fi

echo "Open a new terminal and start agent again."
