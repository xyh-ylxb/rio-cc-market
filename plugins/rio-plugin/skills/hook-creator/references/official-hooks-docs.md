# Official Claude Code Hooks Documentation

This is a complete reference copy of the official Claude Code hooks documentation from https://code.claude.com/docs/en/hooks.

## Configuration

Claude Code hooks are configured in your settings files:

- `~/.claude/settings.json` - User settings
- `.claude/settings.json` - Project settings
- `.claude/settings.local.json` - Local project settings (not committed)
- Enterprise managed policy settings

### Structure

Hooks are organized by matchers, where each matcher can have multiple hooks:

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern",
        "hooks": [
          {
            "type": "command",
            "command": "your-command-here"
          }
        ]
      }
    ]
  }
}
```

- **matcher**: Pattern to match tool names, case-sensitive (only applicable for `PreToolUse`, `PermissionRequest`, and `PostToolUse`)
  - Simple strings match exactly: `Write` matches only the Write tool
  - Supports regex: `Edit|Write` or `Notebook.*`
  - Use `*` to match all tools. You can also use empty string (`""`) or leave `matcher` blank.
- **hooks**: Array of hooks to execute when the pattern matches
  - `type`: Hook execution type - `"command"` for bash commands or `"prompt"` for LLM-based evaluation
  - `command`: (For `type: "command"`) The bash command to execute (can use `$CLAUDE_PROJECT_DIR` environment variable)
  - `prompt`: (For `type: "prompt"`) The prompt to send to the LLM for evaluation
  - `timeout`: (Optional) How long a hook should run, in seconds, before canceling that specific hook

For events like `UserPromptSubmit`, `Stop`, and `SubagentStop` that don't use matchers, you can omit the matcher field:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/prompt-validator.py"
          }
        ]
      }
    ]
  }
}
```

### Project-Specific Hook Scripts

You can use the environment variable `CLAUDE_PROJECT_DIR` (only available when Claude Code spawns the hook command) to reference scripts stored in your project, ensuring they work regardless of Claude's current directory:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/check-style.sh"
          }
        ]
      }
    ]
  }
}
```

### Plugin hooks

Plugins can provide hooks that integrate seamlessly with your user and project hooks. Plugin hooks are automatically merged with your configuration when plugins are enabled.

**How plugin hooks work:**

- Plugin hooks are defined in the plugin's `hooks/hooks.json` file or in a file given by a custom path to the `hooks` field.
- When a plugin is enabled, its hooks are merged with user and project hooks
- Multiple hooks from different sources can respond to the same event
- Plugin hooks use the `${CLAUDE_PLUGIN_ROOT}` environment variable to reference plugin files

**Example plugin hook configuration:**

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

**Environment variables for plugins:**

- `${CLAUDE_PLUGIN_ROOT}`: Absolute path to the plugin directory
- `${CLAUDE_PROJECT_DIR}`: Project root directory (same as for project hooks)
- All standard environment variables are available

## Prompt-Based Hooks

In addition to bash command hooks (`type: "command"`), Claude Code supports prompt-based hooks (`type: "prompt"`) that use an LLM to evaluate whether to allow or block an action. Prompt-based hooks are currently only supported for `Stop` and `SubagentStop` hooks, where they enable intelligent, context-aware decisions.

### How prompt-based hooks work

Instead of executing a bash command, prompt-based hooks:

1. Send the hook input and your prompt to a fast LLM (Haiku)
2. The LLM responds with structured JSON containing a decision
3. Claude Code processes the decision automatically

### Configuration

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Evaluate if Claude should stop: $ARGUMENTS. Check if all tasks are complete."
          }
        ]
      }
    ]
  }
}
```

**Fields:**

- `type`: Must be `"prompt"`
- `prompt`: The prompt text to send to the LLM
  - Use `$ARGUMENTS` as a placeholder for the hook input JSON
  - If `$ARGUMENTS` is not present, input JSON is appended to the prompt
- `timeout`: (Optional) Timeout in seconds (default: 30 seconds)

### Response schema

The LLM must respond with JSON containing:

```json
{
  "decision": "approve" | "block",
  "reason": "Explanation for the decision",
  "continue": false,
  "stopReason": "Message shown to user",
  "systemMessage": "Warning or context"
}
```

**Response fields:**

- `decision`: `"approve"` allows the action, `"block"` prevents it
- `reason`: Explanation shown to Claude when decision is `"block"`
- `continue`: (Optional) If `false`, stops Claude's execution entirely
- `stopReason`: (Optional) Message shown when `continue` is false
- `systemMessage`: (Optional) Additional message shown to the user

### Supported hook events

Prompt-based hooks work with any hook event, but are most useful for:

- **Stop**: Intelligently decide if Claude should continue working
- **SubagentStop**: Evaluate if a subagent has completed its task
- **UserPromptSubmit**: Validate user prompts with LLM assistance
- **PreToolUse**: Make context-aware permission decisions
- **PermissionRequest**: Intelligently allow or deny permission dialogs

## Hook Events

### PreToolUse

Runs after Claude creates tool parameters and before processing the tool call.

**Common matchers:**

- `Task` - Subagent tasks
- `Bash` - Shell commands
- `Glob` - File pattern matching
- `Grep` - Content search
- `Read` - File reading
- `Edit` - File editing
- `Write` - File writing
- `WebFetch`, `WebSearch` - Web operations

Use PreToolUse decision control to allow, deny, or ask for permission to use the tool.

### PermissionRequest

Runs when the user is shown a permission dialog.

Use PermissionRequest decision control to allow or deny on behalf of the user.

Recognizes the same matcher values as PreToolUse.

### PostToolUse

Runs immediately after a tool completes successfully.

Recognizes the same matcher values as PreToolUse.

### Notification

Runs when Claude Code sends notifications. Supports matchers to filter by notification type.

**Common matchers:**

- `permission_prompt` - Permission requests from Claude Code
- `idle_prompt` - When Claude is waiting for user input (after 60+ seconds of idle time)
- `auth_success` - Authentication success notifications
- `elicitation_dialog` - When Claude Code needs input for MCP tool elicitation

You can use matchers to run different hooks for different notification types, or omit the matcher to run hooks for all notifications.

### UserPromptSubmit

Runs when the user submits a prompt, before Claude processes it. This allows you to add additional context based on the prompt/conversation, validate prompts, or block certain types of prompts.

### Stop

Runs when the main Claude Code agent has finished responding. Does not run if the stoppage occurred due to a user interrupt.

### SubagentStop

Runs when a Claude Code subagent (Task tool call) has finished responding.

### PreCompact

Runs before Claude Code is about to run a compact operation.

**Matchers:**
- `manual` - Invoked from `/compact`
- `auto` - Invoked from auto-compact (due to full context window)

### SessionStart

Runs when Claude Code starts a new session or resumes an existing session (which currently does start a new session under the hood). Useful for loading in development context like existing issues or recent changes to your codebase, installing dependencies, or setting up environment variables.

**Matchers:**
- `startup` - Invoked from startup
- `resume` - Invoked from `--resume`, `--continue`, or `/resume`
- `clear` - Invoked from `/clear`
- `compact` - Invoked from auto or manual compact.

### SessionEnd

Runs when a Claude Code session ends. Useful for cleanup tasks, logging session statistics, or saving session state.

## Hook Input

Hooks receive JSON data via stdin containing session information and event-specific data:

```json
{
  // Common fields
  session_id: string
  transcript_path: string
  cwd: string
  permission_mode: string

  // Event-specific fields
  hook_event_name: string
  ...
}
```

See [hook-input-schemas.md](hook-input-schemas.md) for detailed schemas for each event type.

## Hook Output

There are two mutually exclusive ways for hooks to return output back to Claude Code:

### Simple: Exit Code

Hooks communicate status through exit codes, stdout, and stderr:

- **Exit code 0**: Success. `stdout` is shown to the user in verbose mode (ctrl+o), except for `UserPromptSubmit` and `SessionStart`, where stdout is added to the context.
- **Exit code 2**: Blocking error. Only `stderr` is used as the error message and fed back to Claude.
- **Other exit codes**: Non-blocking error. `stderr` is shown to the user in verbose mode.

### Advanced: JSON Output

Hooks can return structured JSON in `stdout` for more sophisticated control. See [hook-input-schemas.md](hook-input-schemas.md) for detailed JSON output schemas for each event type.

## Hook Execution Details

- **Timeout**: 60-second execution limit by default, configurable per command.
- **Parallelization**: All matching hooks run in parallel
- **Deduplication**: Multiple identical hook commands are deduplicated automatically
- **Environment**: Runs in current directory with Claude Code's environment
  - The `CLAUDE_PROJECT_DIR` environment variable is available and contains the absolute path to the project root directory
  - The `CLAUDE_CODE_REMOTE` environment variable indicates whether the hook is running in a remote (web) environment (`"true"`) or local CLI environment (not set or empty)
- **Input**: JSON via stdin
- **Output**: Varies by event (see above)

## Debugging

If your hooks aren't working:

1. **Check configuration** - Run `/hooks` to see if your hook is registered
2. **Verify syntax** - Ensure your JSON settings are valid
3. **Test commands** - Run hook commands manually first
4. **Check permissions** - Make sure scripts are executable
5. **Review logs** - Use `claude --debug` to see hook execution details

Common issues:

- **Quotes not escaped** - Use `\"` inside JSON strings
- **Wrong matcher** - Check tool names match exactly (case-sensitive)
- **Command not found** - Use full paths for scripts

## Security Considerations

**USE AT YOUR OWN RISK**: Claude Code hooks execute arbitrary shell commands on your system automatically. By using hooks, you acknowledge that:

- You are solely responsible for the commands you configure
- Hooks can modify, delete, or access any files your user account can access
- Malicious or poorly written hooks can cause data loss or system damage
- Anthropic provides no warranty and assumes no liability for any damages resulting from hook usage
- You should thoroughly test hooks in a safe environment before production use

Always review and understand any hook commands before adding them to your configuration.

**Security best practices:**

1. Validate and sanitize inputs - Never trust input data blindly
2. Always quote shell variables - Use `"$VAR"` not `$VAR`
3. Block path traversal - Check for `..` in file paths
4. Use absolute paths - Specify full paths for scripts (use "$CLAUDE_PROJECT_DIR" for the project path)
5. Skip sensitive files - Avoid `.env`, `.git/`, keys, etc.

See [security-guide.md](security-guide.md) for comprehensive security guidance.

**Configuration Safety:**

Direct edits to hooks in settings files don't take effect immediately. Claude Code:

1. Captures a snapshot of hooks at startup
2. Uses this snapshot throughout the session
3. Warns if hooks are modified externally
4. Requires review in `/hooks` menu for changes to apply

This prevents malicious hook modifications from affecting your current session.

---

**Source:** https://code.claude.com/docs/en/hooks
