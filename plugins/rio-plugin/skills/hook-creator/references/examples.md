# Hook Examples

This file contains complete, working examples of common hook patterns.

## Example 1: Enforce Better Tool Usage

Prevent use of inferior tools by suggesting better alternatives.

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/enforce-better-tools.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```bash
#!/usr/bin/env bash
# .claude/hooks/enforce-better-tools.sh

# Read JSON input from stdin
input=$(cat)

# Extract the command
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Define validation rules: pattern -> message
declare -A rules=(
  ["\bgrep\b(?!.*\|)"]="Use 'rg' (ripgrep) instead of 'grep' for better performance and features"
  ["\bfind\s+\S+\s+-name\b"]="Use 'rg --files | rg pattern' or 'rg --files -g pattern' instead of 'find -name'"
  ["\bcat\s+\S+\s+\|"]="Use 'rg' or 'less' instead of 'cat | ...'"
)

# Check each rule
for pattern in "${!rules[@]}"; do
  if echo "$command" | grep -qP "$pattern"; then
    echo "${rules[$pattern]}" >&2
    exit 2  # Exit code 2 blocks the tool call
  fi
done

exit 0  # Allow the command to proceed
```

## Example 2: Auto-Approve Safe File Operations

Automatically approve read operations on safe file types.

### Configuration

```json
{
  "hooks": {
    "PermissionRequest": [
      {
        "matcher": "Read",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/auto-approve-reads.py"
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```python
#!/usr/bin/env python3
# .claude/hooks/auto-approve-reads.py

import json
import sys
import os

def main():
    # Read JSON input from stdin
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(1)

    file_path = input_data.get("tool_input", {}).get("file_path", "")

    # Define safe file extensions
    safe_extensions = {
        '.md', '.mdx', '.txt', '.json', '.yaml', '.yml',
        '.toml', '.ini', '.cfg', '.conf', '.xml',
        '.py', '.js', '.ts', '.jsx', '.tsx', '.rs', '.go',
        '.sh', '.bash', '.zsh', '.fish',
        '.css', '.scss', '.less', '.html', '.htm'
    }

    # Check if file has a safe extension
    _, ext = os.path.splitext(file_path)
    if ext.lower() in safe_extensions:
        # Auto-approve by returning JSON with allow decision
        output = {
            "hookSpecificOutput": {
                "hookEventName": "PermissionRequest",
                "decision": {
                    "behavior": "allow"
                }
            },
            "suppressOutput": True  # Don't show in verbose mode
        }
        print(json.dumps(output))
        sys.exit(0)

    # For other files, let the normal permission flow proceed
    sys.exit(0)

if __name__ == "__main__":
    main()
```

## Example 3: Add Git Context on Session Start

Automatically load repository context when starting a session.

### Configuration

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/load-git-context.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```bash
#!/usr/bin/env bash
# .claude/hooks/load-git-context.sh

# Change to project directory
cd "$CLAUDE_PROJECT_DIR" || exit 0

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

# Gather context
context=""

# Current branch
current_branch=$(git branch --show-current 2>/dev/null)
if [ -n "$current_branch" ]; then
  context+="**Current branch:** \`$current_branch\`\n\n"
fi

# Recent commits (last 5)
recent_commits=$(git log -5 --oneline --pretty=format:"- %s" 2>/dev/null)
if [ -n "$recent_commits" ]; then
  context+="**Recent commits:**\n$recent_commits\n\n"
fi

# Uncommitted changes
uncommitted=$(git status --short 2>/dev/null)
if [ -n "$uncommitted" ]; then
  context+="**Uncommitted changes:**\n"
  context+="$(echo "$uncommitted" | wc -l) files modified\n\n"
fi

# Current work
context+="**Working on:** "
latest_commit=$(git log -1 --pretty=format:"%s" 2>/dev/null)
if [ -n "$latest_commit" ]; then
  context+="Last commit was: $latest_commit\n"
else
  context+="New repository\n"
fi

# Output the context (this gets added to Claude's context)
echo "# Repository Context"
echo ""
echo "$context"

exit 0
```

## Example 4: Block Destructive Commands

Prevent execution of dangerous commands.

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-destructive.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```bash
#!/usr/bin/env bash
# .claude/hooks/block-destructive.sh

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Dangerous patterns to block
dangerous_patterns=(
  "rm -rf /"
  "rm -rf \\.\\."
  "rm -rf ~/"
  "dd if=/"
  ":(){ :|:& };:"  # Fork bomb
  "chmod -R 777 /"
  "chown -R .* /"
)

for pattern in "${dangerous_patterns[@]}"; do
  if echo "$command" | grep -qF "$pattern"; then
    echo "Blocked potentially destructive command: $pattern" >&2
    echo "If this is intentional, modify the command or use /bypass" >&2
    exit 2
  fi
done

# Warn about suspicious patterns
suspicious_patterns=(
  "rm -rf"
  "dd if="
  "mkfs\\."
  "format"
)

for pattern in "${suspicious_patterns[@]}"; do
  if echo "$command" | grep -qE "$pattern"; then
    echo "Warning: This command may be destructive" >&2
    echo "Command: $command" >&2
    # Don't block, just warn
  fi
done

exit 0
```

## Example 5: Validate Prompts for Security

Block prompts that might accidentally include sensitive information.

### Configuration

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/validate-prompt.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```python
#!/usr/bin/env python3
# .claude/hooks/validate-prompt.sh

import json
import sys
import re

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(1)

    prompt = input_data.get("prompt", "")

    # Security patterns to detect
    security_patterns = [
        (r"(?i)(password|secret|api[_-]?key|token)\s*[:=]\s*\S+", "Prompt appears to contain a password, secret, or key"),
        (r"(?i)(sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36,})", "Prompt appears to contain an API token"),
        (r"(?i)BEGIN\s+(RSA\s+)?PRIVATE\s+KEY", "Prompt appears to contain a private key"),
    ]

    for pattern, message in security_patterns:
        if re.search(pattern, prompt):
            output = {
                "decision": "block",
                "reason": f"Security check failed: {message}. Please remove sensitive information and try again."
            }
            print(json.dumps(output))
            sys.exit(0)

    # Allow the prompt to proceed
    sys.exit(0)

if __name__ == "__main__":
    main()
```

## Example 6: Auto-Format Code After Writes

Automatically format code files after they're written.

### Configuration

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/auto-format.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```bash
#!/usr/bin/env bash
# .claude/hooks/auto-format.sh

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Determine file type and run appropriate formatter
case "$file_path" in
  *.py)
    if command -v black &> /dev/null; then
      black "$file_path" 2>/dev/null
    fi
    ;;
  *.js|*.jsx|*.ts|*.tsx)
    if command -v prettier &> /dev/null; then
      prettier --write "$file_path" 2>/dev/null
    fi
    ;;
  *.go)
    if command -v gofmt &> /dev/null; then
      gofmt -w "$file_path" 2>/dev/null
    fi
    ;;
  *.rs)
    if command -v rustfmt &> /dev/null; then
      rustfmt "$file_path" 2>/dev/null
    fi
    ;;
esac

exit 0
```

## Example 7: Log Tool Usage

Track which tools are being used for analytics.

### Configuration

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/log-usage.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```bash
#!/usr/bin/env bash
# .claude/hooks/log-usage.sh

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // empty')
session_id=$(echo "$input" | jq -r '.session_id // empty')
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Log to file
log_file="$CLAUDE_PROJECT_DIR/.claude/tool-usage.log"
echo "[$timestamp] [$session_id] $tool_name" >> "$log_file"

exit 0
```

## Example 8: Intelligently Continue Work

Use prompt-based hook to decide if Claude should continue working.

### Configuration

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "You are evaluating whether Claude should stop working.\n\nContext: $ARGUMENTS\n\nAnalyze the conversation and determine:\n1. Are all user-requested tasks complete?\n2. Are there any errors that need addressing?\n3. Is there follow-up work that should be done?\n\nRespond with JSON: {\"decision\": \"approve\" or \"block\", \"reason\": \"your explanation\"}\n\nIf tasks are incomplete or errors exist, use \"block\" and explain what remains.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

This uses the LLM to intelligently decide whether to continue working based on conversation context.

## Example 9: Prevent Sensitive File Access

Block access to sensitive files like .env or credentials.

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read|Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-sensitive-files.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```python
#!/usr/bin/env python3
# .claude/hooks/block-sensitive-files.sh

import json
import sys
import os

def main():
    input_data = json.load(sys.stdin)
    file_path = input_data.get("tool_input", {}).get("file_path", "")

    # Sensitive file patterns
    sensitive_patterns = [
        '.env',
        '.env.local',
        '.env.production',
        '.env.*',
        'credentials.json',
        'secrets.json',
        '.aws/credentials',
        '.ssh/id_rsa',
        '.ssh/id_ed25519',
    ]

    # Check if file matches any sensitive pattern
    for pattern in sensitive_patterns:
        if pattern in file_path:
            output = {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": "deny",
                    "permissionDecisionReason": f"Access to sensitive file blocked: {pattern}"
                }
            }
            print(json.dumps(output))
            sys.exit(0)

    sys.exit(0)

if __name__ == "__main__":
    main()
```

## Example 10: MCP Tool Integration

Log and validate MCP tool usage.

### Configuration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__.*",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/log-mcp-usage.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Script

```bash
#!/usr/bin/env bash
# .claude/hooks/log-mcp-usage.sh

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // empty')

# Extract MCP server and tool from tool_name
# Format: mcp__<server>__<tool>
if [[ $tool_name =~ ^mcp__(.+)__(.+)$ ]]; then
  server="${BASH_REMATCH[1]}"
  tool="${BASH_REMATCH[2]}"

  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  log_file="$CLAUDE_PROJECT_DIR/.claude/mcp-usage.log"

  echo "[$timestamp] MCP server: $server, tool: $tool" >> "$log_file"
fi

exit 0
```

## Testing Hooks

To test hooks manually, create test input JSON:

```bash
# Create test input
cat > /tmp/hook-test.json <<EOF
{
  "session_id": "test-123",
  "transcript_path": "/tmp/test.jsonl",
  "cwd": "/tmp",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "grep test file.txt"
  },
  "tool_use_id": "test-id"
}
EOF

# Test the hook
cat /tmp/hook-test.json | .claude/hooks/your-hook.sh
echo "Exit code: $?"
```
