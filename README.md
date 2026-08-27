# Copilot Skills（个人全局技能库）

本仓库用于托管个人**全局 Copilot Skills**，实现跨项目、跨设备同步。

> VS Code 的 Settings Sync 不会同步 `~/.copilot/skills/` 下的技能，因此用 git 仓库统一管理、手动安装到每台机器。

## 包含技能

| 技能 | 用途 |
|------|------|
| `daily-work-report` | 跨所有项目、workspace、对话与 git 历史汇总生成日/周工作报告 |

## 目录结构

```
copilot-skills/
├── skills/                 # 每个技能一个文件夹（含 SKILL.md + 可选资源）
│   └── daily-work-report/
│       └── SKILL.md
├── install.sh              # 一键安装所有技能到 ~/.copilot/skills/
└── README.md
```

## 安装（在新设备上）

```bash
# 1. 克隆本仓库（建议私有仓库 + 需要时走代理）
git clone git@github.com:Lizhenghe-Chen/copilot-skills.git
# 或 HTTPS： git clone https://github.com/Lizhenghe-Chen/copilot-skills.git

# 2. 一键安装（软链接，之后 git pull 自动更新）
cd copilot-skills
./install.sh

# 3. 重启 VS Code，在聊天输入 / 即可看到技能
```

## 更新技能

```bash
cd copilot-skills
git pull
# install.sh 使用软链接，拉取后即生效，无需重新执行（除非新增技能）
```

## 新增技能

1. 在 `skills/<name>/` 下创建 `SKILL.md`
2. 提交并推送：
   ```bash
   git add skills/<name> && git commit -m "feat: 新增技能 <name>" && git push
   ```
3. 在本机安装：`./install.sh` 会自动为新增技能建软链接

## 维护说明

- `install.sh` 通过**软链接**把 `skills/*` 链接到 `~/.copilot/skills/`，便于 `git pull` 后立即生效
- 如遇跨境网络问题，先设置代理再执行 git 操作，例如：
  ```bash
  export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
  ```
