# 🚀 rio-cc-market

> 一个功能强大的 Claude Code 插件市场，提供完整的开发工作流解决方案

[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.com/claude-code)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Plugins](https://img.shields.io/badge/Plugins-1+-purple)](#)

## ✨ 特性

**rio-cc-market** 是一个企业级的 Claude Code 插件市场，提供：

- 🎯 **12 个专业命令** - 从项目规划到代码审查的完整工作流
- 🤖 **12 个智能 Agents** - 覆盖研究、审查、分析等各个领域
- 🎨 **5 个可复用 Skills** - Git 管理、知识积累、工具创建
- 🔌 **7 个 MCP 服务器** - 代码搜索、文档查询、Git 集成、可视化

## 📦 插件概览

### rio-plugin

一个功能丰富的开发工具集，包含：

#### 🎯 核心功能（6 个命令）
- **项目规划** (`core:plan`) - 将需求转化为结构化计划
- **计划执行** (`core:work`) - 自动执行项目计划
- **代码审查** (`core:review`) - 多维度代码质量审查
- **知识积累** (`core:compound`) - 记录和复用解决方案
- **深化计划** (`core:deepen-plan`) - 为计划添加深度和细节
- **计划评审** (`core:plan-review`) - 多专家并行评审计划

#### 🛠️ 工具集（6 个命令）
- **PR 摘要** (`utils:pr-summary-cn`) - 生成中文 PR 摘要
- **TODO 解析** (`utils:resolve-todos`) - 并行处理所有 TODO
- **创建 Agent** (`utils:create-agent-skill`) - 创建自定义 AI agents
- **创建命令** (`utils:create-command`) - 创建自定义 slash 命令
- **修复技能** (`utils:heal-skill`) - 修复损坏的技能文件
- **报告问题** (`utils:report-bug`) - 引导创建详细的 bug 报告

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

### 安装插件

```bash
# 添加 marketplace
/plugin marketplace add https://github.com/xyh-ylxb/rio-cc-market.git

# 安装 rio-plugin
/plugin install rio-plugin@rio-cc-market
```

### 配置 GitHub Token（推荐）

```bash
# 编辑 MCP 配置
nano ~/.claude/plugins/rio-plugin/.mcp.json

# 替换占位符
"GITHUB_PERSONAL_ACCESS_TOKEN": "你的 GitHub Token"
```

### 立即开始

```bash
# 创建项目计划
/core:plan "实现用户认证系统"

# 执行计划
/core:work plans/auth-system.md

# 审查代码
/core:review

# 生成 PR 摘要
/utils:pr-summary-cn master
```

## 📖 完整文档

查看 **[完整使用指南 (USAGE.md)](USAGE.md)** 了解：

- 📋 所有命令的详细说明和示例
- 🤖 所有 Agents 的功能和应用场景
- 🎯 所有 Skills 的使用方法
- 🔌 所有 MCP 服务器的配置和用途
- 💡 实际使用场景和最佳实践

## 📊 功能一览

| 类别 | 数量 | 说明 |
|------|------|------|
| **Commands** | 12 | Slash 命令，用于执行复杂工作流 |
| **Agents** | 12 | 专业 AI agents，处理特定领域任务 |
| **Skills** | 5 | 可复用的专业技能和工具 |
| **MCP Servers** | 7 | 底层能力服务器（搜索、文档、Git 等） |

## 🎯 使用场景

### 场景 1：新功能开发
```bash
/core:plan "添加用户权限系统"
/core:deepen-plan plans/permission-system.md
/core:plan-review plans/permission-system.md
/core:work plans/permission-system.md
```

### 场景 2：代码审查
```bash
/core:review "审查 feature/auth 分支"
/utils:pr-summary-cn master
```

### 场景 3：问题解决和知识积累
```bash
/core:compound "数据库连接池超时问题解决方案"
```

## 🏗️ 项目结构

```
rio-cc-market/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace 元数据
├── plugins/
│   └── rio-plugin/
│       ├── commands/             # 12 个 slash 命令
│       │   ├── core/            # 核心功能命令
│       │   └── utils/           # 工具命令
│       ├── agents/              # 12 个 AI agents
│       │   ├── core/            # 核心 agents
│       │   ├── research/        # 研究类 agents
│       │   └── review/          # 审查类 agents
│       ├── skills/              # 5 个 skills
│       ├── hooks/               # Plugin hooks
│       └── .mcp.json            # MCP 服务器配置
├── CLAUDE.md                     # Claude Code 指南
├── USAGE.md                      # 完整使用指南
└── README.md                     # 本文件
```

## 🤝 贡献

欢迎贡献！请随时提交 Pull Request。

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 👤 作者

**Rio** - [GitHub](https://github.com/xyh-ylxb)

## 🙏 致谢

感谢 Claude Code 团队提供的强大插件系统！

---

**[📖 查看完整使用指南](USAGE.md)** | **[🔧 查看开发指南](CLAUDE.md)**
