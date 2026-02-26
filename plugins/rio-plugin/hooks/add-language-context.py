#!/usr/bin/env python3
"""
UserPromptSubmit hook to add language preference context.

This hook detects the language of the user's prompt and adds instructions
about which language to use in responses and generated files.
"""

import json
import sys
import re


def detect_language(text: str) -> str:
    """
    Detect if text is mostly Chinese or English.

    Returns: 'zh' for Chinese, 'en' for English
    """
    # Count Chinese characters (CJK Unified Ideographs)
    chinese_chars = len(re.findall(r'[\u4e00-\u9fff]', text))
    # Count alphanumeric characters (rough proxy for English)
    english_chars = len(re.findall(r'[a-zA-Z]', text))

    # If more than 30% of characters are Chinese, consider it Chinese
    total_chars = chinese_chars + english_chars
    if total_chars == 0:
        return 'en'  # Default to English for empty/very short input

    chinese_ratio = chinese_chars / total_chars
    if chinese_ratio > 0.45:
        return 'zh'
    return 'en'


def main():
    # Read JSON input from stdin
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)

    # Extract the prompt
    prompt = input_data.get("prompt", "")

    if not prompt:
        # No prompt to analyze, just exit
        sys.exit(0)

    # Detect language
    language = detect_language(prompt)

    # Build the language preference instruction
    if language == 'zh':
        instruction = """
**Language Preference:**
- 用户输入主要是中文，请用中文回复
- 需要用户阅读生成的文件应使用中文
- 为 Skills/Commands/Agents 生成的文件（代码、配置等）应使用英文
"""
    else:
        instruction = """
**Language Preference:**
- User input is primarily in English, please respond in English
- Files generated for user reading should use English
- Files generated for Skills/Commands/Agents (code, config, etc.) should use English
"""

    # Output the instruction as additional context
    # This will be added to Claude's context before processing the prompt
    print(instruction.strip())

    # Exit with 0 to allow the prompt to proceed with the added context
    sys.exit(0)


if __name__ == "__main__":
    main()
