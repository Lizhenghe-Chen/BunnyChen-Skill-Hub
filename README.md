# Copilot Skills（个人全局技能库）

本仓库用于托管个人**全局 Copilot Skills**，实现跨项目、跨设备同步。

> VS Code 的 Settings Sync 不会同步 `~/.copilot/skills/` 下的技能，因此用 git 仓库统一管理、手动安装到每台机器。

## 包含技能

| 技能 | 用途 |
|------|------|
| `daily-work-report` | 跨所有项目、workspace、对话与 git 历史汇总生成日/周工作报告 |
| `code-quality` | 代码质量审查与主动优化（简洁、鲁棒、可维护） |

## 目录结构

```
copilot-skills/
├── skills/                 # 每个技能一个文件夹
│   └── daily-work-report/
│       ├── SKILL.md                # 主指令（精简，通用流程）
│       └── references/             # 可选资源：环境细节/参考文档（按需加载）
│           └── REFERENCE.md
├── install.sh              # 一键安装（支持 --claude / --uninstall）
└── README.md
```

## 安装（在新设备上）

```bash
# 1. 克隆本仓库（私有仓库；跨境网络需要时先设置代理）
#    HTTPS（推荐，配合 macOS keychain 免密）：
git clone https://github.com/Lizhenghe-Chen/copilot-skills.git
#    或 SSH（需已配置 SSH key）：
git clone git@github.com:Lizhenghe-Chen/copilot-skills.git

# 2. 一键安装（软链接，之后 git pull 自动更新）
cd copilot-skills
./install.sh
# 可选：同时安装到 Claude Code（~/.claude/skills）
# ./install.sh --claude

# 3. 重启 VS Code，在聊天输入 / 即可看到技能
```

### install.sh 选项

| 命令 | 说明 |
|------|------|
| `./install.sh` | 安装到 `~/.copilot/skills`（VS Code Copilot） |
| `./install.sh --claude` | 额外安装到 `~/.claude/skills`（Claude Code，Agent Skills 开放标准跨工具复用） |
| `./install.sh --uninstall` | 移除已安装的软链接 |
| `./install.sh --help` | 显示帮助 |

## 更新技能

```bash
cd copilot-skills
git pull
# install.sh 使用软链接，拉取后即生效，无需重新执行（除非新增技能）
```

## 新增技能

1. 在 `skills/<name>/` 下创建 `SKILL.md`（目录名须与 frontmatter 的 `name` 一致）
2. 可选：在技能目录内加 `references/`、`scripts/`、`assets/` 等资源，并在 `SKILL.md` 中用相对路径引用（如 `[参考](./references/REFERENCE.md)`），保持主文件精简、按需加载
3. 提交并推送：
   ```bash
   git add skills/<name> && git commit -m "feat: 新增技能 <name>" && git push
   ```
4. 在本机安装：`./install.sh` 会自动为新增技能建软链接

## 维护说明

- `install.sh` 通过**软链接**把 `skills/*` 链接到目标技能目录（默认 `~/.copilot/skills/`），便于 `git pull` 后立即生效
- 技能遵循 [Agent Skills 开放标准](https://agentskills.io/)：目录名 = frontmatter `name`；`description` 描述「做什么 + 何时用」；长内容拆到 `references/` 按需加载
- 如遇跨境网络问题，先设置代理再执行 git 操作，例如：
  ```bash
  export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
  ```
