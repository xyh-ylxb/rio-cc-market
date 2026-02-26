# Hook Input/Output Schemas

Detailed reference for all hook event input and output schemas.

## Common Input Fields

All hooks receive these base fields via stdin (JSON):

```typescript
interface BaseHookInput {
  session_id: string;           // Unique session identifier
  transcript_path: string;      // Path to conversation JSONL file
  cwd: string;                  // Current working directory when hook invoked
  permission_mode: string;      // Current permission mode
  hook_event_name: string;      // The event type (e.g., "PreToolUse")
}
```

## Event-Specific Schemas

### PreToolUse

**Input:**

```typescript
interface PreToolUseInput extends BaseHookInput {
  hook_event_name: "PreToolUse";
  tool_name: string;            // Name of the tool being called
  tool_input: object;           // Tool-specific parameters (varies by tool)
  tool_use_id: string;          // Unique tool call identifier
}
```

**Example Input:**

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/test/.claude/projects/test/abc123.jsonl",
  "cwd": "/Users/test/projects/myapp",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm test",
    "timeout": 120000
  },
  "tool_use_id": "toolu_01ABC123DEF456"
}
```

**Output (JSON Control):**

```typescript
interface PreToolUseOutput {
  continue?: boolean;           // Stop Claude after hook (default: true)
  stopReason?: string;          // Message shown when stopping
  suppressOutput?: boolean;     // Hide stdout from transcript (default: false)
  systemMessage?: string;       // Warning shown to user
  hookSpecificOutput?: {
    hookEventName: "PreToolUse";
    permissionDecision: "allow" | "deny" | "ask";
    permissionDecisionReason?: string;  // Explanation for decision
    updatedInput?: object;      // Modified tool parameters
  };
}
```

**Exit Code Behavior:**
- `0`: Allow tool (or use JSON decision)
- `2`: Block tool, stderr shown to Claude

### PermissionRequest

**Input:**

```typescript
interface PermissionRequestInput extends BaseHookInput {
  hook_event_name: "PermissionRequest";
  tool_name: string;            // Name of the tool requesting permission
  tool_input: object;           // Tool-specific parameters
  tool_use_id: string;          // Unique tool call identifier
}
```

**Output (JSON Control):**

```typescript
interface PermissionRequestOutput {
  continue?: boolean;
  stopReason?: string;
  suppressOutput?: boolean;
  systemMessage?: string;
  hookSpecificOutput?: {
    hookEventName: "PermissionRequest";
    decision: {
      behavior: "allow" | "deny";
      updatedInput?: object;     // Modified tool parameters (for allow)
      message?: string;          // Explanation (for deny)
      interrupt?: boolean;       // Stop Claude (for deny)
    };
  };
}
```

**Exit Code Behavior:**
- `0`: Allow permission (or use JSON decision)
- `2`: Deny permission, stderr shown to user only

### PostToolUse

**Input:**

```typescript
interface PostToolUseInput extends BaseHookInput {
  hook_event_name: "PostToolUse";
  tool_name: string;
  tool_input: object;           // Original tool parameters
  tool_response: object;        // Tool's response (varies by tool)
  tool_use_id: string;
}
```

**Example Input:**

```json
{
  "session_id": "abc123",
  "transcript_path": "/Users/test/.claude/projects/test/abc123.jsonl",
  "cwd": "/Users/test/projects/myapp",
  "permission_mode": "default",
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "content": "Hello, world!"
  },
  "tool_response": {
    "filePath": "/path/to/file.txt",
    "success": true
  },
  "tool_use_id": "toolu_01ABC123DEF456"
}
```

**Output (JSON Control):**

```typescript
interface PostToolUseOutput {
  continue?: boolean;
  stopReason?: string;
  suppressOutput?: boolean;
  systemMessage?: string;
  decision?: "block" | undefined;
  reason?: string;              // Required when decision is "block"
  hookSpecificOutput?: {
    hookEventName: "PostToolUse";
    additionalContext?: string;  // Extra info for Claude to consider
  };
}
```

**Exit Code Behavior:**
- `0`: Success (or use JSON decision)
- `2`: Non-blocking, stderr shown to Claude

### UserPromptSubmit

**Input:**

```typescript
interface UserPromptSubmitInput extends BaseHookInput {
  hook_event_name: "UserPromptSubmit";
  prompt: string;               // The user's submitted prompt
}
```

**Output (JSON Control):**

```typescript
interface UserPromptSubmitOutput {
  continue?: boolean;           // If false, prompt not processed
  stopReason?: string;
  decision?: "block" | undefined;
  reason?: string;              // Required when decision is "block"
  hookSpecificOutput?: {
    hookEventName: "UserPromptSubmit";
    additionalContext?: string;  // Added to conversation context
  };
}
```

**Exit Code Behavior:**
- `0`: Allow prompt, stdout added as context (or use JSON)
- `2`: Block prompt, erase it, stderr shown to user only

**Adding Context (Plain Text):**

Non-JSON stdout is automatically added as context:

```bash
#!/bin/bash
echo "# Current Context"
echo "Branch: main"
echo "Recent: Added feature X"
# This output is added to Claude's context
```

### Stop / SubagentStop

**Input:**

```typescript
interface StopInput extends BaseHookInput {
  hook_event_name: "Stop" | "SubagentStop";
  stop_hook_active: boolean;    // true if already continuing via hook
}
```

**Output (JSON Control):**

```typescript
interface StopOutput {
  continue?: boolean;           // If false, stops Claude entirely
  stopReason?: string;          // Message shown when stopping
  decision?: "block" | undefined;
  reason?: string;              // Required when decision is "block"
}
```

**Exit Code Behavior:**
- `0`: Allow stop (or use JSON decision)
- `2`: Block stop, stderr shown to Claude with reason

### Notification

**Input:**

```typescript
interface NotificationInput extends BaseHookInput {
  hook_event_name: "Notification";
  message: string;              // Notification message
  notification_type: "permission_prompt" | "idle_prompt" | "auth_success" | "elicitation_dialog";
}
```

**Output:**

No special control. Exit codes:
- `0`: Success
- `2`: Non-blocking, stderr shown to user only

### SessionStart

**Input:**

```typescript
interface SessionStartInput extends BaseHookInput {
  hook_event_name: "SessionStart";
  source: "startup" | "resume" | "clear" | "compact";
}
```

**Output (JSON Control):**

```typescript
interface SessionStartOutput {
  continue?: boolean;
  stopReason?: string;
  suppressOutput?: boolean;
  systemMessage?: string;
  hookSpecificOutput?: {
    hookEventName: "SessionStart";
    additionalContext?: string;  // Added to conversation context
  };
}
```

**Environment Variables:**
- `$CLAUDE_ENV_FILE`: Path to file where environment variables can be persisted

**Exit Code Behavior:**
- `0`: Success, stdout added as context (or use JSON)
- `2`: Non-blocking, stderr shown to user only

**Persisting Environment Variables:**

```bash
#!/bin/bash
# Add environment variable for all subsequent bash commands
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=production' >> "$CLAUDE_ENV_FILE"
  echo 'export PATH="$PATH:./node_modules/.bin"' >> "$CLAUDE_ENV_FILE"
fi
exit 0
```

### SessionEnd

**Input:**

```typescript
interface SessionEndInput extends BaseHookInput {
  hook_event_name: "SessionEnd";
  cwd: string;                  // Current working directory
  reason: "clear" | "logout" | "prompt_input_exit" | "other";
}
```

**Output:**

No blocking capability. Exit codes:
- `0`: Success
- `2`: Non-blocking, stderr logged only

### PreCompact

**Input:**

```typescript
interface PreCompactInput extends BaseHookInput {
  hook_event_name: "PreCompact";
  trigger: "manual" | "auto";
  custom_instructions: string;  // User's compact instructions (manual only)
}
```

**Output:**

No blocking capability. Exit codes:
- `0`: Success
- `2`: Non-blocking, stderr shown to user only

## Tool-Specific Input Schemas

### Bash Tool

```typescript
interface BashToolInput {
  command: string;
  timeout?: number;
  run_in_background?: boolean;
  dangerouslyDisableSandbox?: boolean;
}
```

### Write Tool

```typescript
interface WriteToolInput {
  file_path: string;
  content: string;
}
```

### Edit Tool

```typescript
interface EditToolInput {
  file_path: string;
  old_string: string;
  new_string: string;
  replace_all?: boolean;
}
```

### Read Tool

```typescript
interface ReadToolInput {
  file_path: string;
  offset?: number;
  limit?: number;
}
```

### Glob Tool

```typescript
interface GlobToolInput {
  pattern: string;
  path?: string;
}
```

### Grep Tool

```typescript
interface GrepToolInput {
  pattern: string;
  path?: string;
  glob?: string;
  type?: string;
  output_mode?: "content" | "files_with_matches" | "count";
  case_insensitive?: boolean;
  multiline?: boolean;
}
```

## Common JSON Output Fields

### Global Fields

Available in all hook types:

```typescript
interface CommonOutput {
  continue?: boolean;           // Default: true
  stopReason?: string;          // Shown when continue is false
  suppressOutput?: boolean;     // Default: false
  systemMessage?: string;       // Warning to user
}
```

### Field Behaviors

**`continue: false`**
- PreToolUse: Different from deny, stops entire Claude
- PostToolUse: Overrides block decision
- UserPromptSubmit: Prevents prompt processing
- Stop/SubagentStop: Takes precedence over block

**`suppressOutput: true`**
- Hides hook stdout from transcript
- Useful for clean verbose mode

**`systemMessage`**
- Shown to user as warning/info
- Not added to Claude's context

## Response Format for Prompt Hooks

Prompt hooks (type: "prompt") must respond with JSON:

```typescript
interface PromptHookResponse {
  decision: "approve" | "block";
  reason: string;               // Explanation for decision
  continue?: boolean;           // Optional: stop Claude entirely
  stopReason?: string;          // Message when continue is false
  systemMessage?: string;       // Optional: warning to user
}
```

## Tool Response Schemas

### Bash Response

```typescript
interface BashToolResponse {
  stdout: string;
  stderr: string;
  exit_code: number;
}
```

### Write Response

```typescript
interface WriteToolResponse {
  filePath: string;
  success: boolean;
}
```

### Read Response

```typescript
interface ReadToolResponse {
  file_path: string;
  content: string;
  line_count: number;
}
```

## Error Handling

All hooks should handle these error cases:

1. **Invalid JSON input**: Exit with code 1 or 2
2. **Missing expected fields**: Provide defaults or exit with error
3. **File not found**: Log to stderr, exit 0 (non-blocking) or 2 (blocking)
4. **Command execution failure**: Log to stderr with details

Example error handling:

```python
#!/usr/bin/env python3
import json
import sys

try:
    input_data = json.load(sys.stdin)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
    sys.exit(2)  # Use exit code 2 for blocking error

required_fields = ["tool_name", "tool_input"]
missing = [f for f in required_fields if f not in input_data]

if missing:
    print(f"Error: Missing required fields: {missing}", file=sys.stderr)
    sys.exit(2)

# Process hook logic...
```
