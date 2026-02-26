---
name: hook-creator
description: Expert guidance for creating Claude Code hooks. Use when configuring hooks in settings files, creating hook scripts, or implementing hook-based workflows for tool interception, validation, or automation.
---

# Hook Creator

This skill provides comprehensive guidance for creating and managing Claude Code hooks—powerful automation tools that intercept and respond to Claude Code events.

## Quick Start

Create a simple PreToolUse hook that validates Bash commands:

```bash
# ~/.claude/settings.json or .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/validate-command.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

```bash
#!/bin/bash
# .claude/hooks/validate-command.sh
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Block destructive commands
if [[ "$command" =~ ^rm\ -rf ]]; then
  echo "Destructive command blocked" >&2
  exit 2
fi

exit 0
```

## What Are Hooks?

Hooks are event-driven automation points that intercept Claude Code execution at specific moments. They receive JSON input via stdin and communicate back through exit codes and stdout.

### Hook Capabilities

- **Validate or block** tool calls before execution (PreToolUse)
- **Auto-approve** permission requests (PermissionRequest)
- **Run post-processing** after tool execution (PostToolUse)
- **Add context** to conversations (UserPromptSubmit, SessionStart)
- **Control session** lifecycle (Stop, SubagentStop)
- **Handle notifications** from Claude Code (Notification)
- **Integrate with MCP** tools using pattern matching

### Hook Types

**Command hooks** (`type: "command"`): Execute bash scripts
- Fast, deterministic, ideal for validation rules
- Have access to environment variables
- Return status via exit codes and JSON output

**Prompt hooks** (`type: "prompt"`): Use LLM for intelligent decisions
- Context-aware evaluation
- Best for complex, nuanced decisions
- Only supported for Stop and SubagentStop events

## Hook Events

### PreToolUse
Runs after tool parameters are created but before execution.

**Common matchers**: `Bash`, `Write`, `Edit`, `Read`, `Task`, `Glob`, `Grep`

**Use cases**:
- Validate or modify tool inputs before execution
- Auto-approve specific tool calls
- Block dangerous operations

**Decision control**:
- `allow`: Bypass permission system
- `deny`: Prevent tool execution
- `ask`: Show user confirmation dialog

### PermissionRequest
Runs when user is shown a permission dialog.

**Use cases**:
- Auto-approve known-safe operations
- Deny specific permission requests
- Modify tool inputs before approval

### PostToolUse
Runs immediately after successful tool completion.

**Use cases**:
- Trigger notifications or logging
- Validate tool outputs
- Add feedback for Claude to consider

### UserPromptSubmit
Runs when user submits a prompt, before Claude processes it.

**Use cases**:
- Add contextual information to conversations
- Validate prompts for security issues
- Block inappropriate prompts

### Stop / SubagentStop
Runs when Claude or a subagent finishes responding.

**Use cases**:
- Prevent premature stopping
- Ensure task completion
- Continue work automatically

### SessionStart
Runs when Claude starts or resumes a session.

**Matchers**: `startup`, `resume`, `clear`, `compact`

**Use cases**:
- Load development context (recent issues, changes)
- Install dependencies or configure environment
- Persist environment variables via `$CLAUDE_ENV_FILE`

### SessionEnd
Runs when a Claude Code session ends.

**Use cases**:
- Cleanup tasks or logging
- Save session state or statistics

### Notification
Runs when Claude Code sends notifications.

**Matchers**: `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`

**Use cases**:
- Custom notification handling
- Forward notifications to external systems

## Configuration Structure

### Basic Structure

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern|*",
        "hooks": [
          {
            "type": "command|prompt",
            "command": "bash-command",
            "prompt": "llm-prompt",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### Configuration Locations

Hooks are configured in settings files (priority order):
1. `~/.claude/settings.json` - User settings
2. `.claude/settings.json` - Project settings
3. `.claude/settings.local.json` - Local project (not committed)
4. Plugin hooks - Auto-merged when plugins enabled

### Matcher Patterns

- **Exact match**: `Write` matches only Write tool
- **Multiple tools**: `Edit|Write` matches Edit or Write
- **Wildcards**: `.*` or `*` matches all tools
- **Empty/omitted**: Matches all tools (for events without matchers)

### Environment Variables

Available in all hook commands:

- `$CLAUDE_PROJECT_DIR`: Project root directory
- `$CLAUDE_PLUGIN_ROOT`: Plugin directory (plugin hooks only)
- `$CLAUDE_CODE_REMOTE`: "true" in remote web environment (unset locally)
- `$CLAUDE_ENV_FILE`: Persist environment vars (SessionStart only)

## Hook Input/Output

### Input Format

Hooks receive JSON via stdin:

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/session.jsonl",
  "cwd": "/current/working/directory",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "echo 'hello'"
  },
  "tool_use_id": "toolu_01ABC123..."
}
```

### Output: Exit Codes

- **0**: Success (stdout shown in verbose mode, except UserPromptSubmit/SessionStart where stdout is added as context)
- **2**: Blocking error (stderr fed back to Claude, blocks action for applicable events)
- **Other**: Non-blocking error (stderr shown in verbose mode)

### Output: JSON Control

Return structured JSON in stdout for advanced control:

```json
{
  "continue": true,
  "stopReason": "Message shown when stopping",
  "suppressOutput": true,
  "systemMessage": "Warning to user"
}
```

#### PreToolUse JSON Output

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "Explanation",
    "updatedInput": {
      "field_to_modify": "new value"
    }
  }
}
```

#### PostToolUse JSON Output

```json
{
  "decision": "block",
  "reason": "Explanation",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Extra information for Claude"
  }
}
```

#### Stop/SubagentStop JSON Output

```json
{
  "decision": "block",
  "reason": "Why Claude should continue (required when blocking)"
}
```

## Common Patterns

### Pattern 1: Command Validation

Validate bash commands before execution:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/validate-bash.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

```bash
#!/bin/bash
# .claude/hooks/validate-bash.sh
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Enforce better tools
if echo "$command" | grep -qE '\bgrep\b(?!.*\|)'; then
  echo "Use 'rg' (ripgrep) instead of 'grep'" >&2
  exit 2
fi

if echo "$command" | grep -qE '\bfind\s+\S+\s+-name\b'; then
  echo "Use 'rg --files' instead of 'find -name'" >&2
  exit 2
fi

exit 0
```

### Pattern 2: Auto-Approve Safe Operations

Auto-approve documentation file reads:

```json
{
  "hooks": {
    "PermissionRequest": [
      {
        "matcher": "Read",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/auto-approve-docs.sh"
          }
        ]
      }
    ]
  }
}
```

```python
#!/usr/bin/env python3
# .claude/hooks/auto-approve-docs.sh
import json
import sys

input_data = json.load(sys.stdin)
file_path = input_data.get("tool_input", {}).get("file_path", "")

# Auto-approve documentation files
if file_path.endswith((".md", ".mdx", ".txt", ".json")):
    output = {
        "hookSpecificOutput": {
            "hookEventName": "PermissionRequest",
            "decision": {
                "behavior": "allow"
            }
        },
        "suppressOutput": True
    }
    print(json.dumps(output))
    sys.exit(0)

sys.exit(0)
```

### Pattern 3: Add Session Context

Load recent changes on session start:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/load-context.sh"
          }
        ]
      }
    ]
  }
}
```

```bash
#!/bin/bash
# .claude/hooks/load-context.sh
cd "$CLAUDE_PROJECT_DIR" || exit 0

# Get recent commits (last 5)
recent_changes=$(git log -5 --oneline --pretty=format:"- %s" 2>/dev/null)

# Get current branch
current_branch=$(git branch --show-current 2>/dev/null)

if [ -n "$recent_changes" ] || [ -n "$current_branch" ]; then
  echo "# Repository Context"
  echo ""
  echo "**Current branch:** $current_branch"
  echo ""
  echo "**Recent changes:**"
  echo "$recent_changes"
fi

exit 0
```

### Pattern 4: Prompt-Based Stop Hook

Use LLM to intelligently decide if Claude should stop:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Analyze the conversation context: $ARGUMENTS\n\nDetermine if:\n1. All requested tasks are complete\n2. All tests pass\n3. No errors remain unaddressed\n\nRespond with JSON: {\"decision\": \"approve\"|\"block\", \"reason\": \"explanation\"}",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Pattern 5: MCP Tool Integration

Target specific MCP tools:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__memory__.*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Memory operation' >> ~/hooks.log"
          }
        ]
      },
      {
        "matcher": "mcp__.*__write.*",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/validate-mcp-write.sh"
          }
        ]
      }
    ]
  }
}
```

## Security Considerations

### Disclaimer

**USE AT YOUR OWN RISK**: Hooks execute arbitrary shell commands automatically. You are solely responsible for hook commands. Malicious or poorly written hooks can cause data loss or system damage.

### Best Practices

1. **Validate inputs**: Never trust input data blindly
2. **Quote variables**: Use `"$VAR"` not `$VAR`
3. **Block path traversal**: Check for `..` in file paths
4. **Use absolute paths**: Specify full paths via `$CLAUDE_PROJECT_DIR`
5. **Skip sensitive files**: Avoid `.env`, `.git/`, keys
6. **Test thoroughly**: Test hooks in safe environment first

### Configuration Safety

Direct edits to hooks don't take effect immediately. Claude Code:
1. Captures hook snapshot at startup
2. Uses snapshot throughout session
3. Warns if hooks modified externally
4. Requires review in `/hooks` menu for changes

## Debugging

### Basic Troubleshooting

1. Check configuration: Run `/hooks` to verify hook registration
2. Verify syntax: Ensure JSON settings are valid
3. Test commands: Run hook commands manually first
4. Check permissions: Ensure scripts are executable (`chmod +x`)
5. Review logs: Use `claude --debug` for execution details

### Common Issues

- **Quotes not escaped**: Use `\"` inside JSON strings
- **Wrong matcher**: Tool names are case-sensitive
- **Command not found**: Use absolute paths for scripts
- **Exit code confusion**: Exit code 2 blocks, others warn

### Debug Output

Run `claude --debug` to see detailed hook execution:

```
[DEBUG] Executing hooks for PostToolUse:Write
[DEBUG] Found 1 hook matchers in settings
[DEBUG] Matched 1 hooks for query "Write"
[DEBUG] Executing hook command: <command> with timeout 60000ms
[DEBUG] Hook command completed with status 0
```

## Plugin Hooks

Plugins can provide hooks that integrate with user/project hooks:

```json
{
  "description": "Automatic code formatting",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

Place in `plugins/your-plugin/hooks/hooks.json` or specify custom path in plugin metadata.

## Execution Details

- **Timeout**: 60 seconds default (configurable per command)
- **Parallelization**: All matching hooks run in parallel
- **Deduplication**: Identical hook commands auto-deduplicated
- **Environment**: Current directory with Claude Code's environment
- **Input**: JSON via stdin
- **Output**: Varies by event (see above)

## Guidelines

- **Keep hooks simple**: Prefer bash scripts for straightforward logic
- **Use prompt hooks sparingly**: Only for nuanced, context-aware decisions
- **Set appropriate timeouts**: Adjust based on expected execution time
- **Handle errors explicitly**: Scripts should validate inputs and handle errors
- **Test thoroughly**: Verify hooks work as expected before production use
- **Document purpose**: Add comments explaining hook behavior
- **Use environment variables**: Leverage `$CLAUDE_PROJECT_DIR` for portability

## Examples

See [examples.md](references/examples.md) for complete working examples of common hook patterns.

## Reference

For complete API details, see:
- [official-hooks-docs.md](references/official-hooks-docs.md) - Full Claude Code hooks documentation
- [hook-input-schemas.md](references/hook-input-schemas.md) - Detailed input/output schemas
- [security-guide.md](references/security-guide.md) - Security best practices
