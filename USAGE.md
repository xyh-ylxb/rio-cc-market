# 📖 rio-cc-market 完整使用指南

> 全面掌握 rio-plugin 的所有功能、工具和最佳实践

## 📑 目录

- [1. 快速开始](#1-快速开始)
- [2. MCP 服务器](#2-mcp-服务器)
- [3. 命令详解](#3-命令详解)
- [4. Agents 介绍](#4-agents-介绍)
- [5. Skills 使用](#5-skills-使用)
- [6. 使用场景](#6-使用场景)
- [7. 最佳实践](#7-最佳实践)
- [8. 故障排除](#8-故障排除)

---

## 1. 快速开始

### 1.1 安装插件

```bash
# 添加 marketplace
/plugin marketplace add https://github.com/xyh-ylxb/rio-cc-market.git

# 查看可用插件
/plugin marketplace list

# 安装 rio-plugin
/plugin install rio-plugin@rio-cc-market
```

### 1.2 配置 GitHub Token（推荐但可选）

GitHub MCP 可以让你直接与 GitHub API 交互，创建 Issues、管理 PR 等。

```bash
# 1. 生成 GitHub Personal Access Token
# 访问：https://github.com/settings/tokens
# 需要的权限：repo, read:org

# 2. 编辑配置文件
nano ~/.claude/plugins/rio-plugin/.mcp.json

# 3. 替换占位符
"github": {
  "command": "npx",
  "args": ["@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_你的实际Token"
  }
}
```

### 1.3 验证安装

```bash
# 测试基本命令
/core:plan "测试计划"

# 查看所有可用命令
/help | grep Vengineer
```

---

## 2. MCP 服务器

MCP 服务器提供底层能力，被 Agents 和 Commands 自动调用。

### 2.1 研究工具

#### 🔍 Exa - 代码搜索引擎

**功能**：搜索代码示例、文档和解决方案

**用途**：
- 查找编程问题的解决方案
- 搜索 GitHub 和 Stack Overflow
- 获取官方文档链接

**使用方式**：自动集成在 agents 中

---

#### 🧠 DeepWiki - GitHub 仓库问答

**功能**：向任何 GitHub 仓库提问

**用途**：
- 理解开源项目的架构
- 查询代码实现决策
- 学习最佳实践

**使用方式**：agents 自动调用

---

#### 📚 Context7 - 框架文档查询

**功能**：查询任何框架的最新文档

**用途**：
- 获取官方 API 文档
- 查询版本特定功能
- 了解配置选项

**使用方式**：agents 自动调用

---

### 2.2 可视化工具

#### 🎨 XMind - 思维导图生成器

**功能**：将结构化数据转换为思维导图

**安装**：
```bash
npm install -g xmind-generator-mcp
```

**配置**：
```json
"xmind": {
  "command": "npx",
  "args": ["xmind-generator-mcp"],
  "env": {
    "outputPath": "/tmp/xmind-generator-mcp",
    "autoOpenFile": "false"
  }
}
```

**用途**：
- 将项目计划可视化
- 创建架构设计图
- 整理知识结构

---

### 2.3 版本控制工具

#### 🎯 Git - 版本控制操作

**功能**：执行 Git 命令和操作

**用途**：
- 查看仓库状态和历史
- 管理分支和提交
- 分析代码变更

---

#### 🐙 GitHub - GitHub API 集成

**功能**：完整的 GitHub API 访问

**配置**：需要设置 `GITHUB_PERSONAL_ACCESS_TOKEN`

**用途**：
- 创建和管理 Issues
- 操作 Pull Requests
- 查询仓库统计信息
- 监控 Actions 工作流

---

#### 🦊 GitLab - GitLab API 集成

**功能**：GitLab 仓库和 CI/CD 管理

**配置**（可选）：
```json
"gitlab": {
  "command": "npx",
  "args": ["@modelcontextprotocol/server-gitlab"],
  "env": {
    "GITLAB_PERSONAL_ACCESS_TOKEN": "glpat_你的Token",
    "GITLAB_HOST": "gitlab.com"
  }
}
```

**用途**：
- 管理 Merge Requests
- 查询 CI/CD pipeline 状态
- 操作 GitLab 项目

---

## 3. 命令详解

### 3.1 核心命令

#### /core:plan - 项目规划

**功能**：将功能需求转化为结构化的项目计划

**语法**：
```bash
/core:plan "[功能描述]"
```

**示例**：
```bash
/core:plan "实现用户认证系统，支持邮箱和GitHub登录"
```

**输出**：
- 详细的项目计划 Markdown 文件
- 包含：问题陈述、解决方案、技术栈、实施步骤
- 自动集成最佳实践研究
- 使用 SpecFlow 分析器验证需求

**最佳实践**：
- ✅ 清晰描述功能目标
- ✅ 提及技术栈或约束条件
- ✅ 说明预期的用户体验

---

#### /core:work - 执行计划

**功能**：自动执行项目计划

**语法**：
```bash
/core:work [计划文件路径]
```

**示例**：
```bash
/core:work plans/user-auth-system.md
```

**工作流程**：
1. 读取并分析计划
2. 创建 TODO 列表
3. 逐步实施任务
4. 自动运行测试
5. 提交代码

**特点**：
- 并行处理独立任务
- 实时进度跟踪
- 自动质量检查

---

#### /core:review - 代码审查

**功能**：多维度代码质量审查

**语法**：
```bash
/core:review [分支名或描述]
```

**示例**：
```bash
# 审查当前分支
/core:review

# 审查指定分支
/core:review "feature/user-authentication"

# 审查特定目录
/core:review "src/auth/"
```

**审查维度**：
- 🏗️ **架构设计** - 模块划分、依赖关系
- 📝 **代码质量** - 命名、注释、结构
- ⚡ **性能** - 算法效率、资源使用
- 🔒 **安全** - 漏洞、最佳实践
- 🧪 **测试** - 覆盖率、测试质量

---

#### /core:compound - 知识积累

**功能**：记录和存档解决方案

**语法**：
```bash
/core:compound "[问题描述和解决方案]"
```

**示例**：
```bash
/core:compound "解决了 Nginx 在高并发下的连接超时问题：增加 worker_connections 并优化 keepalive_timeout"
```

**输出**：
- 带有 YAML frontmatter 的结构化文档
- 自动分类标签
- 可搜索的知识库

**后续使用**：
```bash
# 搜索相关知识
"查找关于 Nginx 连接问题的解决方案"
```

---

#### /core:deepen-plan - 深化计划

**功能**：为计划添加深度和细节

**语法**：
```bash
/core:deepen-plan [计划文件路径]
```

**示例**：
```bash
/core:deepen-plan plans/basic-feature.md
```

**增强内容**：
- 每个部分的最佳实践
- 详细的实现步骤
- 潜在风险和缓解策略
- 性能和安全性考虑

---

#### /core:plan-review - 计划评审

**功能**：多专家并行评审计划

**语法**：
```bash
/core:plan-review [计划文件路径]
```

**示例**：
```bash
/core:plan-review plans/payment-integration.md
```

**评审角度**：
- 可行性分析
- 风险识别
- 边缘情况
- 改进建议

---

### 3.2 工具命令

#### /utils:pr-summary-cn - PR 摘要生成

**功能**：自动生成中文 PR 摘要

**语法**：
```bash
/utils:pr-summary-cn [基础分支]
```

**示例**：
```bash
# 相对于 master
/utils:pr-summary-cn master

# 相对于 develop
/utils:pr-summary-cn develop

# 相对于特定分支
/utils:pr-summary-cn feature/auth-base
```

**输出结构**：
```markdown
## 变更摘要
一句话概括主要目的

## 主要变更
- 变更点 1
- 变更点 2
- 变更点 3

## 技术细节
关键实现说明
```

---

#### /utils:resolve-todos - TODO 解析

**功能**：并行处理所有 TODO 注释

**语法**：
```bash
/utils:resolve-todos [文件或目录路径]
```

**示例**：
```bash
# 处理整个项目
/utils:resolve-todos src/

# 处理特定文件
/utils:resolve-todos components/UserAuth.tsx

# 处理当前目录
/utils:resolve-todos .
```

**工作流程**：
1. 扫描所有 TODO 注释
2. 并行分析和分类
3. 自动实现或创建任务
4. 更新或删除 TODO

---

#### /utils:create-agent-skill - 创建 Agent

**功能**：创建自定义 AI agent

**语法**：
```bash
/utils:create-agent-skill "[agent 描述]"
```

**示例**：
```bash
/utils:create-agent-skill "创建一个 TypeScript 专家 agent，专注于类型系统和最佳实践"
```

**输出**：
- 完整的 agent 定义文件
- 包含角色定位、工作流程、最佳实践

---

#### /utils:create-command - 创建命令

**功能**：创建自定义 slash 命令

**语法**：
```bash
/utils:create-command "[命令目的和需求]"
```

**示例**：
```bash
/utils:create-command "创建一个数据库迁移命令，自动生成迁移文件"
```

**输出**：
- 符合规范的命令 Markdown 文件
- 包含 YAML frontmatter 和使用说明

---

#### /utils:heal-skill - 修复技能

**功能**：修复损坏的 SKILL.md 文件

**语法**：
```bash
/utils:heal-skill [技能名称]
```

**示例**：
```bash
# 修复特定技能
/utils:heal-skill "my-custom-skill"

# 修复所有损坏的技能（扫描模式）
/utils:heal-skill
```

**修复内容**：
- 更新过时的 API 引用
- 修正错误的语法
- 补充缺失的元数据

---

#### /utils:report-bug - 报告问题

**功能**：引导创建详细的 bug 报告

**语法**：
```bash
/utils:report-bug "[问题简述]"
```

**示例**：
```bash
/utils:report-bug "用户登录后 session 丢失"
```

**报告结构**：
- 问题描述
- 复现步骤
- 预期行为 vs 实际行为
- 环境信息
- 错误日志
- 截图/录屏

---

## 4. Agents 介绍

### 4.1 核心 Agents

#### 🤖 general - 通用目的 Agent

**用途**：处理跨领域任务和协调其他 agents

**何时使用**：
- 需要多领域知识的任务
- 不确定应该使用哪个专家 agent
- 需要协调多个 agents

---

#### 📊 spec-flow-analyzer - 规范流程分析器

**用途**：分析功能需求，识别用户流程和边缘情况

**何时使用**：
- 在 `/core:plan` 之后验证需求
- 需要识别潜在的用户场景
- 确保需求完整性

---

### 4.2 研究 Agents

#### 🔍 best-practices-researcher - 最佳实践研究者

**用途**：研究行业最佳实践和权威文档

**何时使用**：
- 需要了解某个技术的最佳实践
- 实现新功能前的技术调研
- 寻找权威的解决方案参考

**使用示例**：
```bash
# 在 plan 命令中自动调用
/core:plan "使用 WebSocket 实现实时通知"
# 会自动研究 WebSocket 最佳实践
```

---

#### 📚 framework-docs-researcher - 框架文档研究者

**用途**：获取框架/库的官方文档和 API 参考

**何时使用**：
- 需要查询特定 API 的用法
- 了解框架的配置选项
- 查找版本特定的变更

---

#### 📜 git-history-analyzer - Git 历史分析器

**用途**：分析代码历史，理解设计决策的演变

**何时使用**：
- 需要理解某个代码为什么这样写
- 追踪 bug 的历史根源
- 学习项目的演变过程

---

#### 🏗️ repo-research-analyst - 仓库研究分析器

**用途**：分析项目结构、代码模式和团队约定

**何时使用**：
- 加入新项目需要了解架构
- 需要识别代码组织模式
- 理解团队的编码规范

---

### 4.3 审查 Agents

#### 🏛️ architecture-strategist - 架构策略师

**用途**：审查系统设计和架构决策

**关注点**：
- 模块划分和依赖关系
- 可扩展性和可维护性
- 设计模式的应用

---

#### 🧩 bobo-cpp-reviewer - C++ 代码审查专家

**用途**：严格的 C++ 代码质量审查（Big Head bobo 标准）

**关注点**：
- 现代 C++ 特性使用
- 内存安全和 RAII
- 性能优化
- 代码可读性

---

#### 🐍 bobo-python-reviewer - Python 代码审查专家

**用途**：Python 代码质量审查（Big Head bobo 标准）

**关注点**：
- Pythonic 代码风格
- 类型提示和文档
- PEP 8 规范
- 性能最佳实践

---

#### ✂️ code-simplicity-reviewer - 代码简洁性审查者

**用途**：识别过度复杂的设计，推动简洁性

**关注点**：
- YAGNI 原则（You Aren't Gonna Need It）
- KISS 原则（Keep It Simple, Stupid）
- 避免过度工程
- 代码可读性

---

#### 🔍 pattern-recognition-specialist - 模式识别专家

**用途**：识别设计模式和反模式

**关注点**：
- 设计模式的正确应用
- 代码重复和抽象机会
- 命名约定一致性

---

#### ⚡ performance-oracle - 性能预言家

**用途**：分析性能瓶颈和优化机会

**关注点**：
- 算法复杂度
- 数据库查询优化
- 缓存策略
- 可扩展性

---

## 5. Skills 使用

### 5.1 git-worktree - Git Worktree 管理

**功能**：管理并行的 Git worktrees

**使用方式**：
```bash
# 在对话中调用
"使用 git-worktree skill 创建一个 feature/user-auth 分支"

# 切换到另一个 worktree
"使用 git-worktree 切换到 feature/payment 分支"

# 清理已完成的 worktree
"使用 git-worktree 清理 feature/old-feature"
```

**功能亮点**：
- 自动复制 .env 文件
- 自动管理 .gitignore
- 交互式确认

---

### 5.2 create-agent-skills - 创建 Agent 技能

**功能**：引导创建自定义 agent

**使用方式**：
```bash
"使用 create-agent-skills 创建一个数据库优化专家"
```

**提供内容**：
- Agent 结构模板
- 工作流程指导
- 最佳实践参考
- 验证清单

---

### 5.3 skill-creator - 技能创建器

**功能**：快速创建新技能

**使用方式**：
```bash
"使用 skill-creator 创建一个 Docker 容器管理技能"
```

**特点**：
- 简化的创建流程
- 符合规范的模板
- 即用型示例

---

### 5.4 compound-docs - 复合文档

**功能**：分类存档问题解决方案

**使用方式**：
```bash
"使用 compound-docs 记录 Redis 缓存穿透问题的解决方案"
```

**元数据格式**：
```yaml
---
category: performance
tags: [redis, cache, optimization]
severity: high
---
```

**后续检索**：
```bash
"搜索 compound-docs 关于 Redis 的文档"
```

---

### 5.5 hook-creator - Hook 创建器

**功能**：创建自定义 hooks

**使用方式**：
```bash
"使用 hook-creator 创建一个 pre-commit hook 运行测试"
```

**支持的事件**：
- Tool calls
- User prompts
- Agent outputs
- Command execution

---

## 6. 使用场景

### 场景 1：新功能开发工作流

```bash
# 步骤 1：创建详细计划
/core:plan "实现用户权限系统，包括角色、权限和管理界面"

# 步骤 2：深化计划细节
/core:deepen-plan plans/permission-system.md

# 步骤 3：评审计划
/core:plan-review plans/permission-system.md

# 步骤 4：执行实施
/core:work plans/permission-system.md

# 步骤 5：审查代码
/core:review

# 步骤 6：生成 PR 摘要
/utils:pr-summary-cn develop
```

---

### 场景 2：代码审查工作流

```bash
# 方式 1：审查当前分支
/core:review

# 方式 2：审查特定分支
/core:review "feature/authentication"

# 方式 3：审查后生成摘要
/core:review
/utils:pr-summary-cn master
```

---

### 场景 3：技术债务清理

```bash
# 步骤 1：扫描所有 TODO
/utils:resolve-todos src/

# 步骤 2：查看生成的任务清单
# （agent 会自动创建 TODO 列表）

# 步骤 3：逐个处理 TODO
# （agent 会自动实施或更新）
```

---

### 场景 4：知识积累和复用

```bash
# 步骤 1：记录解决方案
/core:compound "解决了 Nginx 在高并发下的连接超时问题：

问题现象：超过 1000 并发时出现 502 错误
解决方案：
1. 增加 worker_connections 到 10240
2. 优化 keepalive_timeout 到 30
3. 启用共享 session 存储避免惊群效应"

# 步骤 2：后续遇到类似问题时查询
"搜索 compound-docs 关于 Nginx 并发的问题"
```

---

### 场景 5：创建自定义工具

```bash
# 创建自定义命令
/utils:create-command "创建一个数据库迁移助手命令"

# 创建自定义 agent
/utils:create-agent-skill "创建一个 Kubernetes 部署专家 agent"
```

---

## 7. 最佳实践

### 7.1 命令使用

✅ **推荐做法**：
- 在开始新功能前使用 `/core:plan`
- 定期使用 `/core:review` 保持代码质量
- 使用 `/core:compound` 积累团队知识

❌ **避免**：
- 跳过计划直接编码（小型功能除外）
- 忽略 code review 的建议
- 不记录解决方案导致重复踩坑

---

### 7.2 Agent 选择

| 场景 | 推荐的 Agent |
|------|-------------|
| 需要研究最佳实践 | 等待 plan 命令自动调用 research agents |
| 审查代码架构 | `/core:review` 会自动调用 architecture-strategist |
| 性能问题分析 | `/core:review` 会自动调用 performance-oracle |
| 需要理解代码历史 | 手动调用 git-history-analyzer |

---

### 7.3 MCP 配置

**生产环境建议**：
```json
{
  "github": {
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"  // 使用环境变量
    }
  },
  "xmind": {
    "env": {
      "outputPath": "/path/to/secure/directory",  // 使用固定路径
      "autoOpenFile": "false"  // 自动化场景设为 false
    }
  }
}
```

---

### 7.4 工作流优化

**并行处理**：
```bash
# 利用 agent 并行研究
/core:plan "复杂功能"
# 会自动启动 3 个 research agents 并行工作

# 并行代码审查
/core:review
# 会启动多个 review agents 同时分析
```

**增量使用**：
```bash
# 新手：从简单命令开始
/utils:pr-summary-cn master

# 中级：添加规划流程
/core:plan "小功能" + /core:work

# 高级：完整工作流
/core:plan → deepen-plan → plan-review → work → review
```

---

## 8. 故障排除

### 8.1 常见问题

#### Q1: 命令找不到

**问题**：
```
Error: Command not found: /core:plan
```

**解决方案**：
```bash
# 1. 确认插件已安装
/plugin list

# 2. 重新安装插件
/plugin install rio-plugin@rio-cc-market

# 3. 重启 Claude Code
```

---

#### Q2: MCP 服务器连接失败

**问题**：
```
Error: Failed to connect to MCP server
```

**解决方案**：
```bash
# 1. 检查网络连接
ping github.com

# 2. 验证配置文件
cat ~/.claude/plugins/rio-plugin/.mcp.json

# 3. 查看详细日志
# 在 Claude Code 设置中启用调试日志
```

---

#### Q3: GitHub Token 无效

**问题**：
```
Error: GitHub API authentication failed
```

**解决方案**：
```bash
# 1. 检查 Token 是否过期
# 访问：https://github.com/settings/tokens

# 2. 验证 Token 权限
# 需要：repo, read:org

# 3. 重新生成并更新配置
nano ~/.claude/plugins/rio-plugin/.mcp.json
```

---

#### Q4: XMind 生成失败

**问题**：
```
Error: Failed to generate XMind file
```

**解决方案**：
```bash
# 1. 安装 xmind-generator-mcp
npm install -g xmind-generator-mcp

# 2. 验证安装
npx xmind-generator-mcp --version

# 3. 检查输出路径权限
ls -la /tmp/xmind-generator-mcp
```

---

### 8.2 获取帮助

**命令内帮助**：
```bash
# 查看命令帮助
/core:plan --help

# 查看插件信息
/plugin info rio-plugin
```

**社区支持**：
- GitHub Issues: https://github.com/xyh-ylxb/rio-cc-market/issues
- 文档: https://github.com/xyh-ylxb/rio-cc-market/blob/main/USAGE.md

---

## 9. 进阶技巧

### 9.1 组合使用

```bash
# 完整的 CI/CD 工作流
/core:plan "新功能"
→ /core:deepen-plan
→ /core:work
→ /core:review
→ /utils:pr-summary-cn
→ (GitHub MCP 自动创建 PR)
```

### 9.2 自定义扩展

```bash
# 创建领域专用 agents
/utils:create-agent-skill "创建金融科技领域的安全审计专家"

# 创建团队特定命令
/utils:create-command "创建符合团队规范的代码格式化命令"
```

### 9.3 性能优化

- 使用 MCP 缓存减少重复查询
- 并行执行独立任务
- 增量处理大型项目

---

## 🎓 总结

**rio-cc-market** 提供了一个**完整的 AI 辅助开发工作流**：

1. **规划** → `/core:plan`
2. **深化** → `/core:deepen-plan`
3. **评审** → `/core:plan-review`
4. **执行** → `/core:work`
5. **审查** → `/core:review`
6. **总结** → `/utils:pr-summary-cn`
7. **积累** → `/core:compound`

立即开始使用，体验 AI 赋能的高效开发！🚀

---

**[返回 README](README.md)** | **[查看开发指南](CLAUDE.md)**
