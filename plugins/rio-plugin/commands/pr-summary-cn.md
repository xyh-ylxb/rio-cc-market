---
name: utils:pr-summary-cn
description: Generate concise Chinese PR summary from git changes
allowed-tools: Bash(git:*)
argument-hint: "[被你所处的分支合并的分支, 默认为 Master]"
---

Base branch: ${ARGUMENTS:-master}

Current branch and status:
!git branch --show-current > /dev/null 2>&1 && git status --short > /dev/null 2>&1

Commit history from base branch:
!git log ${ARGUMENTS:-master}..HEAD --oneline --no-merges > /dev/null 2>&1

Detailed changes:
!git diff ${ARGUMENTS:-master}...HEAD --stat > /dev/null 2>&1

Code changes:
!git diff ${ARGUMENTS:-master}...HEAD > /dev/null 2>&1

Based on the above git log and diff information, generate a concise Chinese PR summary with the following structure. You can explore (use explorer agent) the codebase for more information. 

## 变更摘要
[用一句话概括本次PR的主要目的(可以有多个主要目的)]

## 主要变更
- [列举3-5个最重要的变更点，使用简洁的中文描述]

## 技术细节
- [如有必要，简要说明关键技术实现或架构变化]


Keep the summary concise, professional, and focused on the most important changes.
