#!/usr/bin/env bash
# 一键安装本仓库所有技能到 Agent Skills 目录
# 使用软链接：后续 git pull 更新后立即生效
#
# 用法：
#   ./install.sh              安装到 ~/.copilot/skills（VS Code Copilot）
#   ./install.sh --claude     同时安装到 ~/.claude/skills（Claude Code）
#   ./install.sh --uninstall  移除已安装的软链接
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/skills"

# 目标目录：默认 VS Code Copilot 个人技能目录；--claude 追加 Claude Code 目录
DEST_DIRS=("$HOME/.copilot/skills")
CLAUDE_DIR="$HOME/.claude/skills"

usage() {
  cat <<'EOF'
用法: ./install.sh [选项]

  默认安装到 ~/.copilot/skills（VS Code Copilot 个人技能目录）
  --claude     同时安装到 ~/.claude/skills（Claude Code，Agent Skills 开放标准）
  --uninstall  移除已安装的软链接
  -h, --help   显示本帮助
EOF
}

UNINSTALL=0
for arg in "$@"; do
  case "$arg" in
    --claude)    DEST_DIRS+=("$CLAUDE_DIR") ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help)   usage; exit 0 ;;
    *)           echo "❌ 未知参数: $arg（可用 --help 查看用法）" >&2; exit 1 ;;
  esac
done

if [ ! -d "$SRC_DIR" ]; then
  echo "❌ 未找到 skills/ 目录，请确认在仓库根目录运行" >&2
  exit 1
fi

ops=0
for dest in "${DEST_DIRS[@]}"; do
  [ "$UNINSTALL" -eq 1 ] || mkdir -p "$dest"
  for skill_dir in "$SRC_DIR"/*/; do
    [ -d "$skill_dir" ] || continue
    name="$(basename "$skill_dir")"
    target="$dest/$name"

    if [ "$UNINSTALL" -eq 1 ]; then
      if [ -L "$target" ]; then
        rm "$target"
        echo "🗑️  已卸载: $target"
        ops=$((ops + 1))
      fi
      continue
    fi

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "⚠️  $name 已存在于 $dest 且不是软链接（保留原目录，跳过）"
      continue
    fi
    ln -sfn "$skill_dir" "$target"
    echo "✅ 已安装技能: $name -> $target"
    ops=$((ops + 1))
  done
done

echo
if [ "$UNINSTALL" -eq 1 ]; then
  echo "完成：共卸载 $ops 个技能软链接"
else
  echo "完成：共安装/更新 $ops 个技能"
  echo "重启 VS Code 后，在聊天输入 / 即可看到技能。"
fi
