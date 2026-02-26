# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Repository Overview

This is **rio-cc-market**, a marketplace for Claude Code plugins. It contains the **rio-plugin** - a collection of useful utilities and commands for daily development workflow.

### Repository Structure

```
rio-cc-market/
├── .claude-plugin/
│   └── marketplace.json        # Plugin marketplace metadata
├── plugins/
│   └── rio-plugin/             # Main plugin
│       ├── agents/               # Subagent definitions
│       ├── commands/             # Slash commands
│       ├── skills/               # User-invocable skills
│       └── hooks/                # Plugin hooks
└── README.md
```

## Plugin Architecture

### rio-plugin Components

**Commands** (`plugins/rio-plugin/commands/`):
- `greet.md` - Simple greeting command
- `status.md` - Project/workspace status check
- `todo.md` - Create todo list for current task

**Agents** (`plugins/rio-plugin/agents/`):
- Placeholder for future subagent definitions

**Skills** (`plugins/rio-plugin/skills/`):
- Placeholder for future skills

**Hooks** (`plugins/rio-plugin/hooks/`):
- Placeholder for future hooks

## Development Guidelines

### When Adding New Commands

1. Create markdown file in `commands/` directory
2. Include YAML frontmatter: `name`, `description`, `argument-hint` (optional)
3. Follow existing command structure
4. Test the command after adding

### When Adding New Components

Follow the same structure as Vengineer plugin for consistency:
- Use lowercase names with hyphens
- Include proper YAML frontmatter
- Document clearly in the body

## Installation

Users install this plugin via:
```bash
/plugin marketplace add git@github.com:xyh-ylxb/rio-cc-market.git
/plugin install rio-plugin@rio-cc-market
```

Or use the install command:
```bash
/install-rio-plugin
```
