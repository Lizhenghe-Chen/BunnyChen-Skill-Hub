# SKILLS（技能详情与设计规范）

本文件记录本仓库的**目录结构、各技能详情、设计来源与设计规范**；项目介绍与安装部署见 [README.md](./README.md)。

## 目录结构

```
BunnyChen-Skill-Hub/
├── skills/                 # 每个技能一个文件夹
│   └── daily-work-report/
│       ├── SKILL.md                # 主指令（精简，通用流程）
│       └── references/             # 可选资源：环境细节/参考文档（按需加载）
│           └── REFERENCE.md
├── install.sh              # 一键安装（多平台，支持 --claude / --cursor / --all 等）
└── README.md
```

## 技能说明

| 技能 | 用途 | 附带资源 |
| --- | --- | --- |
| `daily-work-report` | 跨所有项目、会话与 git 历史汇总生成日/周工作报告（VS Code Copilot 深度适配） | `references/REFERENCE.md` |
| `code-quality` | 代码质量审查与主动优化（简洁、鲁棒、可维护） | — |
| `frontend-design` | 前端设计品味（桌面+移动端通用）：反 AI 模板化、有辨识度的设计原则与动效规范 | `references/`（`anti-ai-slop` / `motion` / `redesign` / `style-directions`） |
| `book-notes-ocr` | 书页截图批量 OCR 并整理为读书笔记（仅 macOS：Swift + Vision，零第三方依赖） | `references/REFERENCE.md`、`scripts/ocr_script.swift` |

## 设计来源（Sources）

各技能的方法论与内容来源如下，均遵循 [Agent Skills 开放标准](https://agentskills.io/)：

| 技能 | 设计来源 |
| ---- | -------- |
| `daily-work-report` | 跨项目/跨会话的工作汇总方法论：以本地活动数据（VS Code Copilot 会话库）为主，辅以云端会话存储与 git 历史 |
| `code-quality` | 代码质量审查方法论：简洁 / 鲁棒 / 可维护，配「红线 / 验证必填 / 自我质疑」三原则 |
| `frontend-design` | [taste-skill](https://github.com/Leonxlnx/taste-skill) 全部子技能为方法论主体，`references/` 各文档（`anti-ai-slop` / `motion` / `redesign` / `style-directions`）均标注其来源 |
| `book-notes-ocr` | macOS 原生 Vision 框架 OCR + 结构化读书笔记整理流程（零第三方依赖） |

## 设计规范

- 技能遵循 [Agent Skills 开放标准](https://agentskills.io/)：目录名 = frontmatter `name`；`description` 描述「做什么 + 何时用」；长内容拆到 `references/` 按需加载
- 结构合规性（目录、frontmatter、软链接安装方式）对照 [VS Code Agent Skills 官方文档](https://code.visualstudio.com/docs/copilot/customization/agent-skills) 与 [agentskills.io](https://agentskills.io/) 逐项校验，并据此完成拆分 `references/` 等优化
- **对标参考（非内容直接引用）**：整体结构对标 [anthropics/skills](https://github.com/anthropics/skills)（Agent Skills 规范的官方实现仓库，`spec/` + `template/`，即 agentskills.io 标准的出处）与 [obra/superpowers](https://github.com/obra/superpowers)（可组合技能集 + 自动触发的工作流方法论，其 `verification-before-completion` 与 `code-quality` 的「验证必填」理念呼应）
