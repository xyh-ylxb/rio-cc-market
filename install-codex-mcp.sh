#!/bin/sh

set -eu

ensure_server() {
  name="$1"
  shift

  if codex mcp get "$name" >/dev/null 2>&1; then
    codex mcp remove "$name" >/dev/null
  fi

  codex mcp add "$name" "$@"
}

ensure_server exa --url https://mcp.exa.ai/mcp
ensure_server deepwiki --url https://mcp.deepwiki.com/sse
ensure_server context7 --url https://mcp.context7.com/mcp

ensure_server xmind \
  --env outputPath=/tmp/xmind-generator-mcp \
  --env autoOpenFile=false \
  -- npx xmind-generator-mcp

ensure_server git -- npx @modelcontextprotocol/server-git

ensure_server github \
  --env GITHUB_PERSONAL_ACCESS_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-}" \
  -- npx @modelcontextprotocol/server-github

ensure_server gitlab \
  --env GITLAB_PERSONAL_ACCESS_TOKEN="${GITLAB_PERSONAL_ACCESS_TOKEN:-}" \
  --env GITLAB_HOST="${GITLAB_HOST:-gitlab.com}" \
  -- npx @modelcontextprotocol/server-gitlab

printf '%s\n' "Codex MCP servers registered."
