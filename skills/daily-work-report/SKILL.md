---
name: daily-work-report
description: '汇总生成日/周工作报告，跨所有项目、workspace、对话与 git 历史。使用场景：用户要求"总结昨天/本周/某几天的日报"、"汇总这段时间做了什么"、"输出工作汇报"，或需要跨多个仓库归纳提交、会话与改动。核心数据源为本地 Copilot 会话数据库（session-store.db，最完整），辅以云端会话存储、git 历史与记忆。'
argument-hint: '指定日期或范围，如"昨天"、"8月25到26日"、"本周"'
user-invocable: true
---

# Daily Work Report（日工作报告汇总）

跨项目、跨 workspace 汇总 Copilot 会话、git 提交与记忆，生成结构化日/周工作汇报。

## 目标

把零散的多项目活动整理成一份按**项目/工作流分组**的日报，回答「某段时间做了什么」。

## 何时使用

- 用户要求总结某天/某段时间的工作汇报（如「总结昨天的日报」「这周 25 到 26 日的工作」）
- 需要跨多个仓库归纳提交、会话、改动
- 周报/月报/述职需要素材

## 关键事实（必读，避免踩坑）

1. **本地会话库最完整**：云端会话存储（`session_store_sql` 工具）只同步了**部分**会话；
   完整历史在本地 SQLite：
   `~/Library/Application Support/Code/User/globalStorage/github.copilot-chat/session-store.db`
   —— 生成日报时**必须以本地库为主**。
2. **时区**：库内 `created_at` / `updated_at` 为 **UTC**，需 **+8 小时**转中国时区（CST）再按天分组。
3. **Schema 差异**：
   - 本地 SQLite：`sessions(id, repository, branch, summary, agent_name, created_at, updated_at)`；
     `turns(session_id, turn_index, user_message, assistant_response, timestamp)`；
     `session_files(session_id, file_path, tool_name, turn_index)`。
   - 云端 DuckDB：`sessions(session_id, repository, branch, summary, agent_name, ...)`；
     `turns(session_id, turn_index, user_message, assistant_response)`。
4. **会话可能跨午夜**：按 `created_at`（创建时间）归属日期即可，不必纠结 updated_at。

## 流程

### 1. 确定日期范围
- 默认「昨天」（今天是 2026-08-27，则取 CST 2026-08-26 全天）。
- 若用户说「这周 25 到 26 日」等，解析为 CST 日期范围 `[start, end)`（不含 end 当天 0 点）。

### 2. 读取本地会话库（主数据源）
用 `sqlite3` 直接查询本地库，按 CST 过滤目标日期：

```bash
DB="$HOME/Library/Application Support/Code/User/globalStorage/github.copilot-chat/session-store.db"
sqlite3 -header -column "$DB" "SELECT id, agent_name, repository, branch,
  datetime(created_at, '+8 hours') AS cst_created,
  substr(summary,1,120) AS summary
  FROM sessions
  WHERE date(datetime(created_at, '+8 hours')) >= 'YYYY-MM-DD'
    AND date(datetime(created_at, '+8 hours')) <  'YYYY-MM-DD'
  ORDER BY cst_created;"
```

然后对每个会话读取 turns 理解实际做了什么（用户消息 + 助手回复），并按需查
`session_files` 识别涉及文件/组件：

```bash
sqlite3 -header -column "$DB" "SELECT turn_index,
  substr(replace(replace(user_message,char(10),' '),char(13),' '),1,200) AS user_msg,
  substr(replace(replace(assistant_response,char(10),' '),char(13),' '),1,200) AS asst_msg
  FROM turns WHERE session_id = '<SESSION_ID>' ORDER BY turn_index;"
```

### 3. 用云端会话存储补充（可选）
若本地库缺数据或想核对，用 `session_store_sql` 查询（DuckDB 语法）：
```sql
SELECT session_id, repository, branch,
  created_at + INTERVAL '8 hours' AS cst_created, substr(summary,1,150) AS summary
FROM sessions
WHERE (created_at + INTERVAL '8 hours') >= 'YYYY-MM-DD 00:00'
  AND (created_at + INTERVAL '8 hours') <  'YYYY-MM-DD 00:00'
ORDER BY cst_created;
```
注意：云端可能只包含部分会话；若两者不一致，**以本地库为准**并在报告中说明。

### 4. 结合 git 历史（可选增强）
如果用户在意提交记录，对涉及的仓库补充 git 提交。**仓库路径可从本地库 `sessions.cwd` 精确获取**（这是跨 workspace 定位项目的可靠来源）：

```bash
sqlite3 -header -column "$DB" "SELECT DISTINCT cwd, repository FROM sessions
  WHERE date(datetime(created_at, '+8 hours')) = 'YYYY-MM-DD'
    AND cwd IS NOT NULL AND cwd != '';"
```

拿到 `cwd` 后对每个仓库执行（author 可按需加 `--author="xxx"`）：
```bash
git -C <cwd> log --since="YYYY-MM-DD 00:00" --until="YYYY-MM-DD 23:59" --pretty=format:"%h %s"
```
找不到 `cwd` 或目录不存在的就跳过，不要臆造提交。

### 5. 查看记忆（可选）
检查 `/memories/session/` 是否有当日任务记录，补充上下文；有 `repo/` 记忆时了解项目约定。

### 6. 汇总输出
按 **项目/工作流分组** 输出，格式：

```
# 📋 工作汇报（<日期>）

## 1️⃣ <项目名/工作流名>
*<时间段>*
- <具体完成事项>
- <具体完成事项>

## 2️⃣ <项目名/工作流名>
...
---
**小结**：<一两句总结>
```

要求：
- 每个会话都作为候选工作项，即使无 PR/issue/commit 也纳入；用 turns 内容判断「做了什么」。
- 按 `repository` 分组；无仓库的会话归入「其他/流程类」（如会议、面试、配置）。
- 结果用中文；时间、版本号、commit 哈希保留原样。
- 若目标日期无任何记录，如实说明，不要编造。

## 注意事项
- 涉及隐私/密钥的会话内容（如密码、token）不要写进报告正文，可用「处理凭据/配置」概括。
- 长会话只需取关键 turn，避免把每个 turn 都贴出来。
- 用户说「昨天」但数据库按 UTC 存——务必先 +8h 换算，否则会错一天。
