#!/usr/bin/env bash
# 一键安装本仓库所有技能与指令到 ~/.copilot/{skills,instructions}/
# 使用软链接：后续 git pull 更新后立即生效
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_skills() {
  local src="$SCRIPT_DIR/skills"
  local dest="$HOME/.copilot/skills"
  [ -d "$src" ] || { echo "⚠️ 未找到 skills/ 目录，跳过"; return; }
  mkdir -p "$dest"
  local n=0 name target
  for d in "$src"/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    target="$dest/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "⚠️ 技能 $name 已存在且不是软链接（保留原目录，跳过）"
      continue
    fi
    ln -sfn "$d" "$target"
    echo "✅ 技能: $name"
    n=$((n + 1))
  done
  echo "  共 $n 个技能 -> $dest"
}

install_instructions() {
  local src="$SCRIPT_DIR/instructions"
  local dest="$HOME/.copilot/instructions"
  [ -d "$src" ] || { echo "⚠️ 未找到 instructions/ 目录，跳过"; return; }
  mkdir -p "$dest"
  local n=0 name target
  for f in "$src"/*.instructions.md; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    target="$dest/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "⚠️ 指令 $name 已存在且不是软链接（保留原文件，跳过）"
      continue
    fi
    ln -sfn "$f" "$target"
    echo "✅ 指令: $name"
    n=$((n + 1))
  done
  echo "  共 $n 个指令 -> $dest"
}

echo "=== 安装技能 ==="
install_skills
echo
echo "=== 安装指令 ==="
install_instructions
echo
echo "完成 ✅ 重启 VS Code 后生效（技能在 / 菜单，指令自动应用）。"
