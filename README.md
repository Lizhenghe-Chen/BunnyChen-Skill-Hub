# BunnyChen Skill Hub（通用 Agent Skills 技能库）

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

本仓库托管一组面向**所有开发者**的通用 **Agent Skills**（工作 + 日常），遵循 [Agent Skills 开放标准](https://agentskills.io/)，一次编写即可安装到 VS Code Copilot、Claude Code、Cursor、OpenCode、Codex CLI 等主流 Agent 平台，实现跨项目、跨设备、跨平台复用。

> 多数平台的设置同步不覆盖用户技能目录，因此用 git 仓库统一管理、按平台手动安装到每台机器。

> 技能详情、目录结构与设计规范见 [SKILLS.md](./SKILLS.md)。

## 包含技能

| 技能                  | 用途                                                                         |
| --------------------- | ---------------------------------------------------------------------------- |
| `daily-work-report` | 跨所有项目、会话与 git 历史汇总生成日/周工作报告（VS Code Copilot 深度适配） |
| `code-quality`      | 代码质量审查与主动优化（简洁、鲁棒、可维护）                                 |
| `frontend-design`   | 前端设计品味（桌面+移动端通用）：反 AI 模板化、有辨识度的设计原则与动效规范  |
| `book-notes-ocr`    | 书页截图批量 OCR 并整理为读书笔记（仅 macOS：Swift + Vision，零第三方依赖）  |

## 安装（在新设备上）

```bash
# 1. 克隆本仓库（如遇网络问题，见文末代理说明）
git clone https://github.com/Lizhenghe-Chen/BunnyChen-Skill-Hub.git

# 2. 一键安装（软链接，之后 git pull 自动更新）
cd BunnyChen-Skill-Hub
./install.sh          # 默认：VS Code Copilot
./install.sh --all    # 或：一次性安装到全部主流 Agent 平台

# 3. 重启对应工具，在聊天输入 / 即可看到技能
```

### install.sh 选项

| 命令                         | 说明                                                                  |
| ---------------------------- | --------------------------------------------------------------------- |
| `./install.sh`             | 安装到`~/.copilot/skills`（VS Code Copilot）                        |
| `./install.sh --claude`    | 安装到`~/.claude/skills`（Claude Code；Cursor / OpenCode 兼容加载） |
| `./install.sh --cursor`    | 安装到`~/.cursor/skills`（Cursor）                                  |
| `./install.sh --opencode`  | 安装到`~/.config/opencode/skills`（OpenCode）                       |
| `./install.sh --codex`     | 安装到`~/.codex/skills`（OpenAI Codex CLI）                         |
| `./install.sh --agents`    | 安装到`~/.agents/skills`（跨平台兼容目录，Cursor / OpenCode 通用）  |
| `./install.sh --all`       | 安装到以上全部平台                                                    |
| `./install.sh --uninstall` | 移除已安装的软链接                                                    |
| `./install.sh --help`      | 显示帮助                                                              |

## 更新技能

```bash
cd BunnyChen-Skill-Hub
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
4. 安装：`./install.sh` 会自动为新增技能建软链接

## 维护说明

- `install.sh` 通过**软链接**把 `skills/*` 链接到各平台目标技能目录（默认 `~/.copilot/skills/`），便于 `git pull` 后立即生效
- 技能目录结构、各技能详情、设计来源与规范见 [SKILLS.md](./SKILLS.md)
- 平台兼容性：所有技能遵循 Agent Skills 开放标准，主流程不依赖特定平台；个别技能的平台要求（如 `book-notes-ocr` 需 macOS、`daily-work-report` 深度依赖 VS Code 会话库）在各自 `SKILL.md` 中标注
- 如遇网络问题，先设置代理再执行 git 操作，例如（**请替换为你自己的代理地址**，如 Clash 默认 `7890` 端口）：
  ```bash
  export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
  ```
