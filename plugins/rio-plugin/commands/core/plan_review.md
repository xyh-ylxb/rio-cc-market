---
name: core:plan-review
description: Have multiple specialized agents review a plan in parallel
argument-hint: "[plan file path or plan content]"
---

Analyze the provided plan and determine the primary programming language(s) and technology stack involved. Then select and invoke appropriate review agents in parallel based on the detected language:

**Language-based Reviewer Selection:**

- **C / C++**: @agent-bobo-cpp-reviwer @agent-code-simplicity-reviewer
- **Python**: @agent-bobo-python-reviewer @agent-code-simplicity-reviewer
- **Ruby / Rails / Go / Java / TypeScript**: @agent-code-simplicity-reviewer @agent-architecture-strategist

**Additional Specialized Reviewers** (include when relevant):
- Performance concerns, optimization: @agent-performance-oracle
- Architectural decisions, system design: @agent-architecture-strategist
- Design patterns, code duplication: @agent-pattern-recognition-specailist
- Code simplicity, minimal implementation: @agent-code-simplicity-reviewer

**Workflow:**
1. Read the plan from the provided file path or directly from the input
2. Extract code snippets, file extensions, and technology mentions
3. Determine the primary language and any specialized concerns
4. Launch 2-4 most relevant reviewers in parallel
5. Aggregate their feedback and present a consolidated review

Review the following plan:

{{ARGUMENTS}}