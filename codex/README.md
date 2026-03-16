# rio-plugin for Codex

This bundle ports the usable parts of `rio-plugin` into Codex-native assets.

See [PORTING_MATRIX.md](PORTING_MATRIX.md) for the one-to-one source-to-target mapping.

## What gets installed

- 12 command skills
- 12 agent skills
- 5 migrated Rio skills
- aggregator skills such as `rio-workflows`
- MCP assets:
  - `rio-mcp-servers.json`
  - `install-codex-mcp.sh`

## Install

```bash
./install-codex.sh
```

By default this writes into `~/.codex/`.

To install somewhere else:

```bash
CODEX_HOME=/path/to/codex-home ./install-codex.sh
```

## MCP notes

The original plugin ships MCP definitions in JSON. This branch copies the JSON and an executable Codex MCP installer to:

```bash
~/.codex/rio-plugin/rio-mcp-servers.json
~/.codex/rio-plugin/install-codex-mcp.sh
```

You can register the MCP servers directly with:

```bash
~/.codex/rio-plugin/install-codex-mcp.sh
```

## Scope

This branch does not emulate Claude marketplace installs or slash commands directly. It converts them into:

- Codex skills
- Codex-facing docs
- standalone helper scripts
- Codex MCP registration commands
