#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
ROOT="$HOME/.local/share/cursor-hebrew"
mkdir -p "$BIN_DIR"

write_bin() {
  local name="$1"
  local dest="$BIN_DIR/$name"
  rm -f "$dest"
  cat > "$dest" << EOF
#!/usr/bin/env bash
export CURSOR_HEBREW_INVOKED_AS="$name"
exec "$ROOT/run.sh" "\$@"
EOF
  chmod +x "$dest"
}

write_bin agent
write_bin cursor-agent
