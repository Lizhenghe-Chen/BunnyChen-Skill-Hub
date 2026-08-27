#!/usr/bin/env bash
# 一键安装本仓库所有技能到 ~/.copilot/skills/
# 使用软链接：后续 git pull 更新后立即生效
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/skills"
DEST_DIR="$HOME/.copilot/skills"

if [ ! -d "$SRC_DIR" ]; then
  echo "❌ 未找到 skills/ 目录，请确认在仓库根目录运行" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

installed=0
for skill_dir in "$SRC_DIR"/*/; do
  [ -d "$skill_dir" ] || continue
  name="$(basename "$skill_dir")"
  target="$DEST_DIR/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "⚠️  $name 已存在且不是软链接（保留原目录，跳过）"
    continue
  fi

  ln -sfn "$skill_dir" "$target"
  echo "✅ 已安装技能: $name -> $target"
  installed=$((installed + 1))
done

echo
echo "完成：共安装 $installed 个技能到 $DEST_DIR"
echo "重启 VS Code 后，在聊天输入 / 即可看到技能。"
