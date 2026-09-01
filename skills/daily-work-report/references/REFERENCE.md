# 参考文档：数据源与环境细节

> 本文件集中存放 `daily-work-report` 的环境特定细节（路径、schema、SQL、时区）。
> 换设备 / 换时区时，只需调整本文件即可，主流程 `../SKILL.md` 无需改动。

## 1. 本地会话库（参考源之一，最完整）

### 路径（macOS）

```
~/Library/Application Support/Code/User/globalStorage/github.copilot-chat/session-store.db
```

### Schema（本地 SQLite，以实际 `.schema` 为准）

- `sessions(id, cwd, repository, host_type, branch, summary, agent_name, agent_description, created_at, updated_at)`
- `turns(id, session_id, turn_index, user_message, assistant_response, timestamp)`
- `session_files(id, session_id, file_path, tool_name, turn_index, first_seen_at)`

### 时区

库内 `created_at` / `updated_at` / `timestamp` 均为 **UTC**，需换算到目标时区再按天分组。
示例（中国时区，+8h）：`datetime(created_at, '+8 hours')`。
若设备在其他时区，把 `'+8 hours'` 改为对应偏移。

### 常用 SQL

**按日期过滤会话列表（日期区间用 `[start, end)`，避免漏掉跨午夜会话）：**

```bash
DB="$HOME/Library/Application Support/Code/User/globalStorage/github.copilot-chat/session-store.db"
sqlite3 -header -column "$DB" "SELECT id, agent_name, repository, branch,
  datetime(created_at, '+8 hours') AS local_created,
  substr(summary,1,120) AS summary
  FROM sessions
  WHERE date(datetime(created_at, '+8 hours')) >= 'YYYY-MM-DD'
    AND date(datetime(created_at, '+8 hours')) <  'YYYY-MM-DD'
  ORDER BY local_created;"
```

**读取某个会话的对话（用户消息 + 助手回复，用于判断实际做了什么）：**

```bash
sqlite3 -header -column "$DB" "SELECT turn_index,
  substr(replace(replace(user_message,char(10),' '),char(13),' '),1,200) AS user_msg,
  substr(replace(replace(assistant_response,char(10),' '),char(13),' '),1,200) AS asst_msg
  FROM turns WHERE session_id = '<SESSION_ID>' ORDER BY turn_index;"
```

**获取会话涉及的文件/组件：**

```bash
sqlite3 -header -column "$DB" "SELECT DISTINCT file_path, tool_name
  FROM session_files WHERE session_id = '<SESSION_ID>' ORDER BY turn_index;"
```

**定位目标日期内涉及的项目目录（用 `cwd` 跨 workspace 精确定位仓库）：**

```bash
sqlite3 -header -column "$DB" "SELECT DISTINCT cwd, repository FROM sessions
  WHERE date(datetime(created_at, '+8 hours')) >= 'YYYY-MM-DD'
    AND date(datetime(created_at, '+8 hours')) <  'YYYY-MM-DD'
    AND cwd IS NOT NULL AND cwd != '';"
```

> 已核实：`sessions` 表含 `cwd` 列（另含 `host_type`）。

## 2. 云端会话存储（参考源）

用 `session_store_sql` 工具查询（DuckDB 语法），与本地库互为参考源：

```sql
SELECT session_id, repository, branch,
  created_at + INTERVAL '8 hours' AS local_created, substr(summary,1,150) AS summary
FROM sessions
WHERE (created_at + INTERVAL '8 hours') >= 'YYYY-MM-DD 00:00'
  AND (created_at + INTERVAL '8 hours') <  'YYYY-MM-DD 00:00'
ORDER BY local_created;
```

### 云端 Schema（DuckDB，与本地 SQLite 不同，字段不可混用）

- `sessions(session_id, repository, branch, summary, agent_name, ...)`
- `turns(session_id, turn_index, user_message, assistant_response)`

> 云端覆盖跨设备会话，可能包含本地缺失的部分；与本地库结果合并去重，
> 不一致时以信息更完整的一方为准。

## 3. git 历史（可选增强）

拿到 `cwd` 后对每个仓库执行（author 可按需加 `--author="xxx"`）：

```bash
git -C <cwd> log --since="YYYY-MM-DD 00:00" --until="YYYY-MM-DD 23:59" --pretty=format:"%h %s"
```

找不到 `cwd` 或目录不存在的就跳过，不要臆造提交。

## 4. 其他平台数据源（非 VS Code Copilot 的降级方案）

在 Claude Code / Cursor / OpenCode / Codex CLI 等平台没有 `session-store.db`，改用以下数据源降级汇总（能拿到多全面就汇总多全面，缺失部分如实说明，不要编造）：

### Claude Code 会话记录

- 位置：`~/.claude/projects/<项目路径编码>/` 下的 `.jsonl` 会话日志（内含 user/assistant 消息，可 grep 按日期/关键词过滤）
- 定位：`find ~/.claude -name '*.jsonl'`；路径随版本变化，以实际为准

### 通用数据源（所有平台可用）

| 数据源 | 方法 |
| --- | --- |
| git 历史 | 见上文第 3 节：`git log --since= --until=` |
| shell 历史 | `grep '<日期>' ~/.zsh_history` 或 `~/.bash_history` |
| 文件系统最近修改 | `find <项目目录> -newermt 'YYYY-MM-DD' -type f -not -path '*/node_modules/*' -not -path '*/.git/*'` |
| 项目文档/约定 | `CLAUDE.md`、`AGENTS.md`、`README.md` 等记录的工作内容 |

### 汇总裁决
- 数据源按可用性从高到低取用；跨平台时以「会话记录 > git 历史 > 文件系统改动」为序
- 目标日期无任何记录时，如实说明，不要编造
