#!/usr/bin/env bash
# 一键安装本仓库所有技能到各主流 Agent 平台的用户技能目录
# 使用软链接：后续 git pull 更新后立即生效
#
# 用法：
#   ./install.sh               安装到 ~/.copilot/skills（VS Code Copilot）
#   ./install.sh --claude      安装到 ~/.claude/skills（Claude Code；Cursor/OpenCode 兼容加载）
#   ./install.sh --cursor      安装到 ~/.cursor/skills（Cursor）
#   ./install.sh --opencode    安装到 ~/.config/opencode/skills（OpenCode）
#   ./install.sh --codex       安装到 ~/.codex/skills（OpenAI Codex CLI）
#   ./install.sh --agents      安装到 ~/.agents/skills（跨平台兼容目录）
#   ./install.sh --all         安装到以上全部平台
#   ./install.sh --uninstall   移除已安装的软链接
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/skills"

# 平台标识 -> 用户技能目录（Agent Skills 开放标准）
ALL_PLATFORMS=(copilot claude cursor opencode codex agents)

platform_dir() {
  case "$1" in
    copilot)  echo "$HOME/.copilot/skills" ;;
    claude)   echo "$HOME/.claude/skills" ;;
    cursor)   echo "$HOME/.cursor/skills" ;;
    opencode) echo "$HOME/.config/opencode/skills" ;;
    codex)    echo "$HOME/.codex/skills" ;;
    agents)   echo "$HOME/.agents/skills" ;;
  esac
}

usage() {
  cat <<'EOF'
用法: ./install.sh [选项]

  默认安装到 ~/.copilot/skills（VS Code Copilot）
  --claude     安装到 ~/.claude/skills（Claude Code；Cursor/OpenCode 兼容加载）
  --cursor     安装到 ~/.cursor/skills（Cursor）
  --opencode   安装到 ~/.config/opencode/skills（OpenCode）
  --codex      安装到 ~/.codex/skills（OpenAI Codex CLI）
  --agents     安装到 ~/.agents/skills（跨平台兼容目录）
  --all        安装到以上全部平台
  --uninstall  移除已安装的软链接
  -h, --help   显示本帮助
EOF
}

UNINSTALL=0
SELECTED=()
for arg in "$@"; do
  case "$arg" in
    --all)
      SELECTED+=("${ALL_PLATFORMS[@]}") ;;
    --claude|--cursor|--opencode|--codex|--agents)
      SELECTED+=("${arg#--}") ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help)   usage; exit 0 ;;
    *)
      echo "❌ 未知参数: $arg（可用 --help 查看用法）" >&2
      exit 1 ;;
  esac
done

# 未指定平台时，默认仅安装到 VS Code Copilot
if [ "${#SELECTED[@]}" -eq 0 ]; then
  SELECTED+=(copilot)
fi

if [ ! -d "$SRC_DIR" ]; then
  echo "❌ 未找到 skills/ 目录，请确认在仓库根目录运行" >&2
  exit 1
fi

ops=0
for platform in "${SELECTED[@]}"; do
  dest="$(platform_dir "$platform")"
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
  echo "重启对应工具后，在聊天输入 / 即可看到技能。"
fi
