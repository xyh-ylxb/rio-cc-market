# GitHub 推送快速指南

## 1. 替换用户名（关键步骤！）

首先，你需要将所有 `xyh-ylxb` 替换为你的实际 GitHub 用户名：

```bash
cd /home/yunhao.xia/code/rio-cc-market

# 将 YOUR_USERNAME 替换为你的 GitHub 用户名
# 例如：sed -i 's/xyh-ylxb/mygithubname/g' filename

# 更新 marketplace.json
sed -i 's/xyh-ylxb/YOUR_USERNAME/g' .claude-plugin/marketplace.json

# 更新所有命令文件
find plugins/rio-plugin/commands -name "*.md" -exec sed -i 's/xyh-ylxb/YOUR_USERNAME/g' {} +

# 更新 README
sed -i 's/xyh-ylxb/YOUR_USERNAME/g' plugins/rio-plugin/README.md
sed -i 's/xyh-ylxb/YOUR_USERNAME/g' README.md
```

## 2. 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 填写信息：
   - Repository name: `rio-cc-market`
   - Description: `Rio's Claude Code plugin marketplace`
   - Visibility: Public (推荐) 或 Private
   - **不要勾选** "Initialize with README"
3. 点击 "Create repository"

## 3. 推送到 GitHub

```bash
# 进入仓库目录
cd /home/yunhao.xia/code/rio-cc-market

# 初始化 git（如果还没做）
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: rio-cc-market with rio-plugin

- Create marketplace structure
- Add rio-plugin with 3 commands: greet, status, todo
- Add SKILL.md and documentation
- Add install command"

# 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin git@github.com:YOUR_USERNAME/rio-cc-market.git

# 推送
git push -u origin main

# 如果默认分支是 master 而不是 main，用：
# git push -u origin master
```

## 4. 验证推送成功

访问 `https://github.com/YOUR_USERNAME/rio-cc-market` 查看是否所有文件都已上传。

## 5. 安装测试

在新终端窗口中测试：

```bash
# 添加市场
/plugin marketplace add git@github.com:YOUR_USERNAME/rio-cc-market.git

# 查看可用插件
/plugin marketplace list

# 安装 rio-plugin
/plugin install rio-plugin@rio-cc-market

# 测试命令
/rio:greet
```

## 6. 使用安装命令（可选）

如果你创建了 install-rio-plugin 命令，可以在项目目录中：

```bash
/install-rio-plugin
```

然后按照提示在新终端窗口中执行安装步骤。

---

## 🎉 完成！

你的 `rio-cc-market` 插件市场已经创建并推送到 GitHub！

现在其他人可以通过 `/plugin marketplace add` 命令添加你的市场并安装 `rio-plugin` 了！

## 📋 清单

- [ ] 替换所有 `xyh-ylxb` 为实际 GitHub 用户名
- [ ] 创建 GitHub 仓库
- [ ] 推送代码到 GitHub
- [ ] 验证仓库内容
- [ ] 测试安装流程
- [ ] 分享插件给朋友！
