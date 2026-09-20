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

### macOS / Linux（以及 Windows 上的 Git Bash）

```bash
# 1. 克隆本仓库（如遇网络问题，见文末代理说明）
git clone https://github.com/Lizhenghe-Chen/BunnyChen-Skill-Hub.git

# 2. 一键安装（软链接，之后 git pull 自动更新）
cd BunnyChen-Skill-Hub
./install.sh          # 默认：VS Code Copilot
./install.sh --all    # 或：一次性安装到全部主流 Agent 平台

# 3. 重启对应工具，在聊天输入 / 即可看到技能
```

### Windows（原生 PowerShell，无需 Git Bash）

```powershell
# 1. 克隆本仓库（如遇网络问题，见文末代理说明）
git clone https://github.com/Lizhenghe-Chen/BunnyChen-Skill-Hub.git

# 2. 一键安装（符号链接 / 目录联接，之后 git pull 自动更新）
cd BunnyChen-Skill-Hub
.\install.ps1           # 默认：%USERPROFILE%\.copilot\skills（VS Code Copilot）
.\install.ps1 -All      # 或：一次性安装到全部主流 Agent 平台

# 3. 重启 VS Code，在聊天输入 / 即可看到技能
```

Windows 注意事项：

- 若提示「无法加载文件 install.ps1，因为在此系统上禁止运行脚本」（执行策略限制），用下列任一方式代替：
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1    # 不动全局策略，最安全
  install.cmd                  # 同目录下的便捷封装，参数原样透传，如 install.cmd -All
  ```
- **链接类型**：优先创建 **NTFS 符号链接**（开启 Windows「开发者模式」后无需管理员权限，脚本直接调用 Win32 API 以保证兼容 PowerShell 5.1）；若环境仍不允许，则自动回退为**目录联接（Junction）**。两者对 Agent 工具完全等价，`git pull` 后都立即生效，脚本输出中会标注实际类型。
- 也可在 **Git Bash** 里跑 `./install.sh`，但必须带环境变量才会建真符号链接，否则 MSYS 会退化为**复制副本**（之后 `git pull` 不再自动生效）：
  ```bash
  MSYS=winsymlinks:nativestrict ./install.sh
  ```
- 若目标目录下已有**同名真实目录**（非链接），脚本会保留原目录并跳过，不会覆盖你的文件。

### install.sh 选项（macOS / Linux / Git Bash）

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

### install.ps1 选项（Windows PowerShell）

| 命令                      | 说明                                                                     |
| ------------------------- | ------------------------------------------------------------------------ |
| `.\install.ps1`           | 安装到 `%USERPROFILE%\.copilot\skills`（VS Code Copilot）              |
| `.\install.ps1 -Claude`   | 安装到 `%USERPROFILE%\.claude\skills`（Claude Code；Cursor / OpenCode 兼容加载） |
| `.\install.ps1 -Cursor`   | 安装到 `%USERPROFILE%\.cursor\skills`（Cursor）                        |
| `.\install.ps1 -OpenCode` | 安装到 `%USERPROFILE%\.config\opencode\skills`（OpenCode）             |
| `.\install.ps1 -Codex`    | 安装到 `%USERPROFILE%\.codex\skills`（OpenAI Codex CLI）              |
| `.\install.ps1 -Agents`   | 安装到 `%USERPROFILE%\.agents\skills`（跨平台兼容目录）                |
| `.\install.ps1 -All`      | 安装到以上全部平台                                                       |
| `.\install.ps1 -Uninstall`| 移除已安装的链接（不删除仓库中的技能本体）                              |
| `.\install.ps1 -Help`     | 显示帮助                                                                 |

## 更新技能

```bash
cd BunnyChen-Skill-Hub
git pull
# 两个安装脚本都用链接（软链接 / 符号链接 / 目录联接），拉取后即生效，无需重新执行（除非新增技能）
```

## 新增技能

1. 在 `skills/<name>/` 下创建 `SKILL.md`（目录名须与 frontmatter 的 `name` 一致）
2. 可选：在技能目录内加 `references/`、`scripts/`、`assets/` 等资源，并在 `SKILL.md` 中用相对路径引用（如 `[参考](./references/REFERENCE.md)`），保持主文件精简、按需加载
3. 提交并推送：
   ```bash
   git add skills/<name> && git commit -m "feat: 新增技能 <name>" && git push
   ```
4. 安装：`./install.sh`（macOS / Linux）或 `.\install.ps1`（Windows）会自动为新增技能建链接

## 维护说明

- `install.sh`（macOS / Linux / Git Bash）与 `install.ps1` + `install.cmd`（Windows）通过**链接**把 `skills/*` 链接到各平台目标技能目录（默认 `~/.copilot/skills/`），便于 `git pull` 后立即生效；两者参数一一对应，平台列表均以各自脚本的 `--help` / `-Help` 输出为准
- Windows 上优先用符号链接，失败自动回退目录联接（Junction）；两者对 Agent 工具等价
- 技能目录结构、各技能详情、设计来源与规范见 [SKILLS.md](./SKILLS.md)
- 平台兼容性：所有技能遵循 Agent Skills 开放标准，主流程不依赖特定平台；个别技能的平台要求（如 `book-notes-ocr` 需 macOS、`daily-work-report` 深度依赖 VS Code 会话库）在各自 `SKILL.md` 中标注
- 如遇网络问题，先设置代理再执行 git 操作，例如（**请替换为你自己的代理地址**，如 Clash 默认 `7890` 端口）：
  ```bash
  export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
  ```
