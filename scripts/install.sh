#!/usr/bin/env bash
set -euo pipefail

# Resolve repository root from this script's location.
SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COPILOT_HOME="$HOME/.copilot"
VSCODE_USER="$HOME/Library/Application Support/Code/User"

shopt -s nullglob

# GitHub Copilot CLI
mkdir -p "$COPILOT_HOME/prompts" "$COPILOT_HOME/agents" "$COPILOT_HOME/skills"
for f in "$SOURCE/prompts/"*; do ln -sfn "$f" "$COPILOT_HOME/prompts/"; done
for f in "$SOURCE/agents/"*; do ln -sfn "$f" "$COPILOT_HOME/agents/"; done
for f in "$SOURCE/skills/"*; do ln -sfn "$f" "$COPILOT_HOME/skills/"; done
echo "Symlinks updated for Copilot CLI."

# VS Code (user-level - available in all workspaces)
mkdir -p "$VSCODE_USER/prompts" "$VSCODE_USER/agents"
for f in "$SOURCE/prompts/"*; do ln -sfn "$f" "$VSCODE_USER/prompts/"; done
for f in "$SOURCE/agents/"*; do ln -sfn "$f" "$VSCODE_USER/agents/"; done
echo "Symlinks updated for VS Code."

# JetBrains IDEs (macOS path)
JB_BASE="$HOME/Library/Application Support/JetBrains"
if [ -d "$JB_BASE" ]; then
  # Loop through all JetBrains IDE versions (e.g., PhpStorm2024.1)
  for jb_dir in "$JB_BASE"/*/; do
    JB_TARGET="${jb_dir}plugins/github-copilot"
    mkdir -p "$JB_TARGET/prompts" "$JB_TARGET/agents" "$JB_TARGET/skills"
    for f in "$SOURCE/prompts/"*; do ln -sfn "$f" "$JB_TARGET/prompts/"; done
    for f in "$SOURCE/agents/"*; do ln -sfn "$f" "$JB_TARGET/agents/"; done
    for f in "$SOURCE/skills/"*; do ln -sfn "$f" "$JB_TARGET/skills/"; done
    
    jb_name=$(basename "$jb_dir")
    echo "Symlinks updated for JetBrains IDE: $jb_name"
  done
fi
