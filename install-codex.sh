#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DST="$CODEX_HOME/skills"
DOCS_DST="$CODEX_HOME/rio-plugin"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

log() {
  printf '%s\n' "$1"
}

install_dir_copy() {
  src="$1"
  dst="$2"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    backup="${dst}.bak.${TIMESTAMP}"
    mv "$dst" "$backup"
    log "Backed up existing $(basename "$dst") to $backup"
  fi

  cp -R "$src" "$dst"
  log "Installed $(basename "$dst")"
}

mkdir -p "$SKILLS_DST" "$DOCS_DST"

for skill_src in "$SCRIPT_DIR"/codex/skills/*; do
  if [ ! -d "$skill_src" ]; then
    continue
  fi

  skill_name=$(basename "$skill_src")
  install_dir_copy "$skill_src" "$SKILLS_DST/$skill_name"
done

cp "$SCRIPT_DIR/codex/mcp/rio-mcp-servers.json" "$DOCS_DST/rio-mcp-servers.json"
cp "$SCRIPT_DIR/codex/README.md" "$DOCS_DST/README.md"
cp "$SCRIPT_DIR/install-codex-mcp.sh" "$DOCS_DST/install-codex-mcp.sh"

log ""
log "Codex assets installed to $CODEX_HOME"
log "Skills installed under:"
log "  - $SKILLS_DST"
log ""
log "MCP example copied to:"
log "  - $DOCS_DST/rio-mcp-servers.json"
log "  - $DOCS_DST/install-codex-mcp.sh"
log ""
log "Next steps:"
log "1. Review $DOCS_DST/README.md"
log "2. Optional: run $DOCS_DST/install-codex-mcp.sh to register MCP servers with Codex"
log "3. Restart Codex so it reloads installed skills"
