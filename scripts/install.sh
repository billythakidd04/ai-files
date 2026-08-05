#!/usr/bin/env bash
set -euo pipefail

SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
shopt -s nullglob

# Ask for confirmation and handle the else/skip logic
ask_and_run() {
  local target_name="$1"
  local ans
  read -p "Install $target_name symlinks/setup? [y/N]: " -r ans </dev/tty || true
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    return 0
  else
    echo "⏭️  Skipping $target_name setup."
    echo
    return 1
  fi
}

# Helper to link specified directories to a target base
link_dirs() {
  local target_base="$1"
  shift
  for dir in "$@"; do
    mkdir -p "$target_base/$dir"
    for f in "$SOURCE/$dir/"*; do
      ln -sfn "$f" "$target_base/$dir/"
    done
  done
}

# GitHub Copilot CLI
if ask_and_run "GitHub Copilot CLI"; then
  link_dirs "$HOME/.copilot" prompts agents skills
  echo "✅ Symlinks updated for Copilot CLI."
  echo
fi

# VS Code (user-level - available in all workspaces)
if ask_and_run "VS Code"; then
  link_dirs "$HOME/Library/Application Support/Code/User" prompts agents
  echo "✅ Symlinks updated for VS Code."
  echo
fi

# JetBrains IDEs (macOS path)
JB_BASE="$HOME/Library/Application Support/JetBrains"
if [ -d "$JB_BASE" ] && ask_and_run "JetBrains IDEs"; then
  for jb_dir in "$JB_BASE"/*/; do
    jb_name=$(basename "$jb_dir")
    link_dirs "${jb_dir}plugins/github-copilot" prompts agents skills
    echo "✅ Symlinks updated for JetBrains IDE: $jb_name"
  done
  echo
fi

# Gemini (Antigravity Environment)
if ask_and_run "Gemini (Antigravity)"; then
  DEST_GEMINI_CONFIG="$HOME/.gemini/config"
  mkdir -p "$DEST_GEMINI_CONFIG"
  ln -sfn "$SOURCE/../.config/gemini/skills.json" "$DEST_GEMINI_CONFIG/skills.json"
  ln -sfn "$SOURCE/../.config/gemini/GEMINI.md" "$HOME/.gemini/GEMINI.md"
  echo "✅ Symlinks updated for Gemini (Antigravity) skills."
  echo
fi

echo "🎉 Setup complete!"
