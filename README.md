# 🚀 rio-cc-market

> `codex` 分支提供完整的 Codex 安装包；Claude 的 commands、agents、skills 已迁成 Codex skill，MCP 提供可执行注册脚本。

[![Codex](https://img.shields.io/badge/Codex-Compatible-green)](#)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Plugins](https://img.shields.io/badge/Plugins-1+-purple)](#)

## ✨ 特性

**rio-cc-market** 的 `codex` 分支提供 Codex 适配版 Rio 工作流，包含：

- 🎯 **12 个 command skills** - 对应原 Claude commands
- 🤖 **12 个 agent skills** - 对应原 Claude agents
- 🧰 **5 个迁移后的 Rio skills** - 对应原 Claude skills
- 🌿 **Git worktree 辅助** - 适配 Codex 的并行分支工作流
- 🔌 **7 个 MCP servers** - 支持通过 Codex CLI 注册

## 📦 插件概览

### rio-plugin

一个功能丰富的开发工具集，包含：

#### 🎯 Command Skills（12 个）
- **`rio-core-plan`** - 将需求转化为结构化计划
- **`rio-core-work`** - 执行计划并跟踪验证
- **`rio-core-review`** - 多视角代码审查
- **`rio-core-compound`** - 沉淀已解决问题
- **`rio-core-deepen-plan`** - 深化计划细节
- **`rio-core-plan-review`** - 计划评审
- **`rio-utils-pr-summary-cn`** - 生成中文 PR 摘要
- **`rio-utils-resolve-todos`** - 解析和处理 TODO
- **`rio-utils-create-agent-skill`** - 创建 Codex skill
- **`rio-utils-create-command`** - 创建 Codex 工作流入口
- **`rio-utils-heal-skill`** - 修复损坏技能
- **`rio-utils-report-bug`** - 生成缺陷/需求报告

#### 🤖 Agent Skills（12 个）
- `rio-agent-general`
- `rio-agent-spec-flow-analyzer`
- `rio-agent-best-practices-researcher`
- `rio-agent-framework-docs-researcher`
- `rio-agent-git-history-analyzer`
- `rio-agent-repo-research-analyst`
- `rio-agent-architecture-strategist`
- `rio-agent-bobo-cpp-reviewer`
- `rio-agent-bobo-python-reviewer`
- `rio-agent-code-simplicity-reviewer`
- `rio-agent-pattern-recognition-specialist`
- `rio-agent-performance-oracle`

#### 🛠️ Migrated Skills（5 个）
- `rio-compound-docs`
- `rio-create-agent-skills`
- `rio-git-worktree`
- `rio-hook-creator`
- `rio-skill-creator`

#### 🔌 MCP 服务器（7 个）

**研究工具：**
- **Exa** - 代码搜索和示例查找
- **DeepWiki** - GitHub 仓库智能问答
- **Context7** - 框架文档查询

**可视化：**
- **XMind** - 思维导图生成器

**版本控制：**
- **Git** - 官方 Git 操作
- **GitHub** - GitHub API 集成
- **GitLab** - GitLab API 集成

## 🚀 快速开始

### 安装 Codex 版本

```bash
# 拉取 codex 分支
git clone -b codex https://github.com/xyh-ylxb/rio-cc-market.git
cd rio-cc-market

# 安装 Codex 技能包
./install-codex.sh

# 可选：注册全部 MCP servers
./install-codex-mcp.sh
```

### MCP 配置（可选）

```bash
# 查看安装后复制出来的 MCP 示例
cat ~/.codex/rio-plugin/rio-mcp-servers.json
```

### 立即开始

```bash
# 让 Codex 为你规划需求
使用 rio-core-plan 处理 "实现用户认证系统"

# 让 Codex 执行一个计划文件
使用 rio-core-work 执行 plans/auth-system.md

# 让 Codex 审查当前改动
使用 rio-core-review 做 code review

# 用 worktree 管理并行分支
~/.codex/skills/rio-git-worktree/scripts/worktree-manager.sh list
```

## 📖 完整文档

查看 **[完整使用指南 (USAGE.md)](USAGE.md)** 了解原始 Claude 插件内容，Codex 安装说明见 **[codex/README.md](codex/README.md)**：

- 📋 原始命令与工作流设计
- 🎯 全量 Codex skill 映射
- 🔌 MCP 服务器注册方式
- 💡 两套运行时的差异

## 📊 功能一览

| 类别 | 数量 | 说明 |
|------|------|------|
| **Command Skills** | 12 | 对应原 Claude commands |
| **Agent Skills** | 12 | 对应原 Claude agents |
| **Migrated Skills** | 5 | 对应原 Claude skills |
| **MCP Servers** | 7 | 可通过 `install-codex-mcp.sh` 注册 |

## 🎯 使用场景

### 场景 1：新功能开发
```bash
使用 rio-core-plan 规划 "添加用户权限系统"
使用 rio-core-deepen-plan 深化 plans/permission-system.md
使用 rio-core-plan-review 评审 plans/permission-system.md
使用 rio-core-work 执行 plans/permission-system.md
```

### 场景 2：代码审查
```bash
使用 rio-core-review 审查 feature/auth 分支
使用 rio-utils-pr-summary-cn 生成面向 master 的中文 PR 摘要
```

### 场景 3：问题解决和知识积累
```bash
使用 rio-core-compound 沉淀 "数据库连接池超时问题解决方案"
```

## 🏗️ 项目结构

```
rio-cc-market/
├── codex/
│   ├── mcp/                      # Codex MCP 配置与示例
│   ├── skills/                   # Command / agent / migrated skills
│   └── README.md                 # Codex 安装说明
├── install-codex.sh              # Codex 安装脚本
├── install-codex-mcp.sh          # Codex MCP 注册脚本
├── plugins/
│   └── rio-plugin/
│       ├── commands/             # Claude 命令定义（参考）
│       ├── agents/               # Claude agents（参考）
│       ├── skills/               # 原始 skills（参考）
│       ├── hooks/                # Claude hooks（参考）
│       └── .mcp.json             # MCP 源配置
├── AGENTS.md                     # Codex 分支维护说明
├── CLAUDE.md                     # 原始 Claude 说明
├── USAGE.md                      # 原始使用指南
└── README.md                     # 本文件
```

## 🤝 贡献

欢迎贡献！请随时提交 Pull Request。

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 👤 作者

**Rio** - [GitHub](https://github.com/xyh-ylxb)

## 🙏 致谢

感谢 Claude Code 与 Codex 提供的工作流基础能力！

---

**[📖 查看完整使用指南](USAGE.md)** | **[🔧 查看开发指南](CLAUDE.md)**
