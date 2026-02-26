# Rio CC Market

A marketplace for Claude Code plugins maintained by Rio.

## Available Plugins

### rio-plugin

A collection of useful utilities and commands for daily development workflow.

**Features:**
- Greeting command to test plugin installation
- Project status check
- Todo list creation

## Installation

### Method 1: Using Claude Code Commands

```bash
# Add the marketplace
/plugin marketplace add git@github.com:xyh-ylxb/rio-cc-market.git

# List available plugins
/plugin marketplace list

# Install rio-plugin
/plugin install rio-plugin@rio-cc-market
```

### Method 2: Using Install Command (if available)

```bash
/install-rio-plugin
```

## Usage

After installation, you can use the following commands:

```bash
# Greeting command
/rio:greet

# Check project status
/rio:status

# Create todo list
/rio:todo
```

## Development

### Repository Structure

```
rio-cc-market/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   └── rio-plugin/
│       ├── commands/
│       ├── skills/
│       ├── agents/
│       └── hooks/
├── CLAUDE.md
└── README.md
```

### Adding New Commands

1. Create a new `.md` file in `plugins/rio-plugin/commands/`
2. Include YAML frontmatter with `name` and `description`
3. Write the command documentation in markdown

Example:
```markdown
---
name: rio:your-command
description: Description of what this command does
---

# /rio:your-command

Instructions here...
```

## License

MIT License - See LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
