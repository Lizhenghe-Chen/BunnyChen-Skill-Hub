# SKILLS（技能详情与设计规范）

本文件记录本仓库的**目录结构、各技能详情、诞生依据与设计规范**；项目介绍与安装部署见 [README.md](./README.md)。

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

## 技能说明

| 技能 | 用途 | 附带资源 |
| --- | --- | --- |
| `daily-work-report` | 跨所有项目、workspace、对话与 git 历史汇总生成日/周工作报告 | `references/REFERENCE.md` |
| `code-quality` | 代码质量审查与主动优化（简洁、鲁棒、可维护） | — |
| `frontend-design` | 前端设计品味（桌面+移动端通用）：反 AI 模板化、有辨识度的设计原则与动效规范 | `references/`（`anti-ai-slop` / `motion` / `redesign` / `style-directions`） |
| `book-notes-ocr` | 书页截图批量 OCR 并整理为读书笔记（仅 macOS：Swift + Vision，零第三方依赖） | `references/REFERENCE.md`、`scripts/ocr_script.swift` |

## 参考来源（References）

各技能的诞生均有历史对话可追溯（本地 Copilot 会话库 `session-store.db`），主要依据如下：

| 技能 | 诞生依据（会话追溯） | 外部参考 |
| ---- | -------------------- | -------- |
| `daily-work-report` | 源自 2026-08-26 日报实际踩坑：本地 `session-store.db` 比云端完整、UTC+8 时区换算、用 `cwd` 跨项目定位 git 仓库（2026-08-27 会话，commit `f2977f4`） | [Agent Skills 开放标准](https://agentskills.io/) |
| `code-quality` | 源自用户搜集的网络方案经 Kimi 大模型评估后的精简版（2026-08-27 会话：采纳「红线/验证必填/自我质疑」，拒绝过度设计；commit `8545c8f`、`08c5da8`） | [Agent Skills 开放标准](https://agentskills.io/)、[VS Code Agent Skills 官方文档](https://code.visualstudio.com/docs/agent-customization/agent-skills) |
| `frontend-design` | 源自 2026-08-27 会话：以用户指定的 [taste-skill](https://github.com/Leonxlnx/taste-skill) 全部子技能为方法论主体，`references/` 各文档（`anti-ai-slop` / `motion` / `redesign` / `style-directions`）均标注其来源；落地范例为自有记账应用的真实项目（未提交 commit，`skills/frontend-design/` 待入库） | [taste-skill](https://github.com/Leonxlnx/taste-skill)、[Agent Skills 开放标准](https://agentskills.io/) |
| `book-notes-ocr` | 源自 2026-08-30 会话：为《巴顿的领导艺术》18 张书页截图做 OCR 与读书笔记的完整工作流（目录整理 → macOS Vision OCR → 笔记整理）；脚本经实测稳定运行，完整示例见本机 `~/Downloads/New Folder With Items/《巴顿的领导艺术》/` | [Agent Skills 开放标准](https://agentskills.io/) |

## 设计规范

- 技能遵循 [Agent Skills 开放标准](https://agentskills.io/)：目录名 = frontmatter `name`；`description` 描述「做什么 + 何时用」；长内容拆到 `references/` 按需加载
- 结构合规性（目录、frontmatter、软链接安装方式）于 2026-08-27 会话中逐项对照 VS Code 官方文档与 agentskills.io 校验，并据此完成拆分 `references/`、修正 README 克隆命令等优化（commit `9e4171f`）
- **对标参考（非内容直接引用）**：整体结构对标 [anthropics/skills](https://github.com/anthropics/skills)（Agent Skills 规范的官方实现仓库，`spec/` + `template/`，即 agentskills.io 标准的出处）与 [obra/superpowers](https://github.com/obra/superpowers)（可组合技能集 + 自动触发的工作流方法论，其 `verification-before-completion` 与 `code-quality` 的「验证必填」理念呼应）。历史对话中未从这两个仓库直接摘录内容进技能——如实记录，不虚构引用。
