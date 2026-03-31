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

# VS Code (user-level - available in all workspaces)
mkdir -p "$VSCODE_USER/prompts" "$VSCODE_USER/agents"
for f in "$SOURCE/prompts/"*; do ln -sfn "$f" "$VSCODE_USER/prompts/"; done
for f in "$SOURCE/agents/"*; do ln -sfn "$f" "$VSCODE_USER/agents/"; done

echo "Symlinks updated for Copilot CLI and VS Code."
