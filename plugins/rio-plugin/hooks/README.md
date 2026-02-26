# Language Context Hook (Vengineer Plugin)

This hook automatically adds language preference instructions to Claude's context based on the user's input language. It's part of the Vengineer plugin and will be automatically enabled when the plugin is active.

## What It Does

When a user submits a prompt, this hook:

1. **Detects the input language** - Analyzes whether the prompt is primarily Chinese or English
2. **Adds language instructions** - Injects context about which language to use for:
   - Responses to the user (matches input language)
   - Files generated for user reading (matches input language)
   - Skills/Commands/Agents code and configuration files (always English)

## Location

```
plugins/Vengineer/
└── hooks/
    ├── hooks.json                       # Plugin hook configuration
    ├── add-language-context.py          # Hook script
    └── README.md                        # This file
```

## How It Works

### Language Detection

The hook counts Chinese characters (CJK Unified Ideographs) vs English characters:
- If Chinese characters are > 30% of total → treats as Chinese
- Otherwise → treats as English

### Context Added

**For Chinese input:**
```
**Language Preference:**
- 用户输入主要是中文，请用中文回复
- 需要用户阅读生成的文件应使用中文
- 为 Skills/Commands/Agents 生成的文件（代码、配置等）应使用英文
```

**For English input:**
```
**Language Preference:**
- User input is primarily in English, please respond in English
- Files generated for user reading should use English
- Files generated for Skills/Commands/Agents (code, config, etc.) should use English
```

## Configuration

The hook is configured in `plugins/Vengineer/hooks/hooks.json`:

```json
{
  "description": "Automatically add language preference context based on user input language (Chinese vs English)",
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/add-language-context.py"
          }
        ]
      }
    ]
  }
}
```

The `${CLAUDE_PLUGIN_ROOT}` environment variable points to the Vengineer plugin directory.

## Testing

Test the hook manually:

```bash
# Test with Chinese input
cat > /tmp/test-zh.json << 'EOF'
{
  "prompt": "你好，请帮我创建一个新的技能",
  "hook_event_name": "UserPromptSubmit"
}
EOF
cat /tmp/test-zh.json | plugins/Vengineer/hooks/add-language-context.py

# Test with English input
cat > /tmp/test-en.json << 'EOF'
{
  "prompt": "Please help me create a new skill",
  "hook_event_name": "UserPromptSubmit"
}
EOF
cat /tmp/test-en.json | plugins/Vengineer/hooks/add-language-context.py
```

## Verifying It's Active

1. Ensure Vengineer plugin is enabled in your Claude Code settings
2. Run `/hooks` in Claude Code to see registered hooks
3. Check that `UserPromptSubmit` hook from Vengineer is listed
4. When you submit prompts, Claude will automatically receive the language context

## Customization

### Adjust Language Detection Threshold

Edit `plugins/Vengineer/hooks/add-language-context.py`:

```python
# Current threshold: 30%
if chinese_ratio > 0.3:
    return 'zh'

# More sensitive (20%):
if chinese_ratio > 0.2:
    return 'zh'

# Less sensitive (40%):
if chinese_ratio > 0.4:
    return 'zh'
```

### Modify Instruction Text

Edit the `instruction` variable in the script to customize the messages.

## Troubleshooting

**Hook not working:**
1. Verify Vengineer plugin is enabled
2. Verify script is executable: `chmod +x plugins/Vengineer/hooks/add-language-context.py`
3. Check hooks.json syntax: Run `/hooks` in Claude Code
4. Look for errors in debug mode: `claude --debug`

**Wrong language detected:**
1. The detection uses a 30% threshold for Chinese characters
2. Mixed content is treated as English unless Chinese is dominant
3. Adjust the threshold if needed (see Customization above)

**Context not appearing:**
1. Verify UserPromptSubmit hooks are supported in your Claude Code version
2. Check the hook returns exit code 0
3. Use `claude --debug` to see hook execution logs

## Security

This hook:
- ✅ Validates JSON input
- ✅ Uses safe string operations
- ✅ Doesn't execute arbitrary commands
- ✅ Only adds context, doesn't block prompts
- ✅ Has no external dependencies

## Notes

- The hook runs before Claude processes each user prompt
- The added context is invisible to users but guides Claude's responses
- Files for code/automation (Skills, Commands, Agents) are always instructed to use English
- The hook has no timeout (runs quickly)
- This is a plugin-level hook and will be automatically merged when Vengineer plugin is enabled
