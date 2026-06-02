#!/usr/bin/env bash
set -euo pipefail

# Resolve repository root from this script's location.
SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# If ai-dot-files is a submodule inside dot-files, the sibling wp-ai-files repo may exist.
WP_SOURCE="$(cd "$SOURCE/.." && pwd)/wp-ai-files"
COPILOT_HOME="$HOME/.copilot"
CLAUDE_HOME="$HOME/.claude"
VSCODE_USER="$HOME/Library/Application Support/Code/User"

shopt -s nullglob

symlink_dir() {
  local src="$1"
  local dest="$2"
  [ -d "$src" ] || return 0
  mkdir -p "$dest"
  for f in "$src"/*; do
    [ -e "$f" ] || continue
    ln -sfn "$f" "$dest/"
  done
}

# GitHub Copilot CLI
mkdir -p "$COPILOT_HOME/prompts" "$COPILOT_HOME/agents" "$COPILOT_HOME/skills"
symlink_dir "$SOURCE/prompts" "$COPILOT_HOME/prompts"
symlink_dir "$SOURCE/agents"  "$COPILOT_HOME/agents"
symlink_dir "$SOURCE/skills"  "$COPILOT_HOME/skills"
# WebPros-specific skills (only present on work machines)
symlink_dir "$WP_SOURCE/skills" "$COPILOT_HOME/skills"
echo "Symlinks updated for Copilot CLI."

# Claude Code
mkdir -p "$CLAUDE_HOME/agents" "$CLAUDE_HOME/skills" "$CLAUDE_HOME/prompts"
symlink_dir "$SOURCE/agents"  "$CLAUDE_HOME/agents"
symlink_dir "$SOURCE/skills"  "$CLAUDE_HOME/skills"
symlink_dir "$SOURCE/prompts" "$CLAUDE_HOME/prompts"
# WebPros-specific skills (only present on work machines)
symlink_dir "$WP_SOURCE/skills"  "$CLAUDE_HOME/skills"
symlink_dir "$WP_SOURCE/agents"  "$CLAUDE_HOME/agents"
symlink_dir "$WP_SOURCE/prompts" "$CLAUDE_HOME/prompts"
echo "Symlinks updated for Claude Code."

# VS Code (user-level - available in all workspaces)
mkdir -p "$VSCODE_USER/prompts" "$VSCODE_USER/agents" "$VSCODE_USER/skills"
symlink_dir "$SOURCE/prompts" "$VSCODE_USER/prompts"
symlink_dir "$SOURCE/agents"  "$VSCODE_USER/agents"
symlink_dir "$SOURCE/skills"  "$VSCODE_USER/skills"
symlink_dir "$WP_SOURCE/skills"  "$VSCODE_USER/skills"
symlink_dir "$WP_SOURCE/agents"  "$VSCODE_USER/agents"
symlink_dir "$WP_SOURCE/prompts" "$VSCODE_USER/prompts"
echo "Symlinks updated for VS Code."

# JetBrains IDEs (macOS path)
JB_BASE="$HOME/Library/Application Support/JetBrains"
if [ -d "$JB_BASE" ]; then
  for jb_dir in "$JB_BASE"/*/; do
    JB_TARGET="${jb_dir}plugins/github-copilot"
    mkdir -p "$JB_TARGET/prompts" "$JB_TARGET/agents" "$JB_TARGET/skills"
    symlink_dir "$SOURCE/prompts" "$JB_TARGET/prompts"
    symlink_dir "$SOURCE/agents"  "$JB_TARGET/agents"
    symlink_dir "$SOURCE/skills"  "$JB_TARGET/skills"
    symlink_dir "$WP_SOURCE/skills"  "$JB_TARGET/skills"
    symlink_dir "$WP_SOURCE/agents"  "$JB_TARGET/agents"
    symlink_dir "$WP_SOURCE/prompts" "$JB_TARGET/prompts"
    jb_name=$(basename "$jb_dir")
    echo "Symlinks updated for JetBrains IDE: $jb_name"
  done
fi

# Antigravity & Gemini CLI (Antigravity Environment)
DEST_GEMINI_GLOBAL_WORKFLOWS="$HOME/.gemini/antigravity/global_workflows"
DEST_GEMINI_COMMANDS="$HOME/.gemini/commands"

mkdir -p "$DEST_GEMINI_GLOBAL_WORKFLOWS" "$DEST_GEMINI_COMMANDS"

# Process Prompts
for prompt_file in "$SOURCE/prompts/"*.prompt.md; do
  [ -e "$prompt_file" ] || continue
  
  filename=$(basename "$prompt_file")
  base_name="${filename%.prompt.md}"
  
  echo "Processing Antigravity command (prompt): $base_name..."
  
  # Global Symlink (.md extension for general Antigravity use)
  ln -sfn "$prompt_file" "$DEST_GEMINI_GLOBAL_WORKFLOWS/$base_name.md"
  
  # Extract description from YAML frontmatter
  description=$(grep -m 1 "^description:" "$prompt_file" | sed 's/^description: //')
  if [ -z "$description" ]; then
    description="Run the $base_name workflow"
  else
    # Strip leading/trailing quotes and escape internal quotes for TOML
    description=$(echo "$description" | sed 's/^"//;s/"$//' | sed 's/"/\\"/g')
  fi
  
  # TOML command for Gemini CLI
  prompt_content=$(cat "$prompt_file" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed 's/$/\\n/g' | tr -d '\n')
  
  cat <<EOF > "$DEST_GEMINI_COMMANDS/$base_name.toml"
prompt = "$prompt_content"
description = "$description"
EOF
  echo "✅ Created Gemini CLI TOML command: $DEST_GEMINI_COMMANDS/$base_name.toml"
done

# Process Skills
for skill_dir in "$SOURCE/skills/"*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  skill_file="$skill_dir/SKILL.md"
  [ -e "$skill_file" ] || continue
  
  echo "Processing Antigravity command (skill): $skill_name..."
  
  # Global Symlink
  ln -sfn "$skill_file" "$DEST_GEMINI_GLOBAL_WORKFLOWS/$skill_name.md"
  
  # Extract description from YAML frontmatter
  description=$(grep -m 1 "^description:" "$skill_file" | sed 's/^description: //')
  if [ -z "$description" ]; then
    description="Activate the $skill_name skill"
  else
    # Strip leading/trailing quotes and escape internal quotes for TOML
    description=$(echo "$description" | sed 's/^"//;s/"$//' | sed 's/"/\\"/g')
  fi
  
  # TOML command for Gemini CLI
  prompt_content=$(cat "$skill_file" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed 's/$/\\n/g' | tr -d '\n')
  
  cat <<EOF > "$DEST_GEMINI_COMMANDS/$skill_name.toml"
prompt = "$prompt_content"
description = "$description"
EOF
  echo "✅ Created Gemini CLI TOML command: $DEST_GEMINI_COMMANDS/$skill_name.toml"
done

echo "🎉 Setup complete! You can now use the prompts and skills globally."
