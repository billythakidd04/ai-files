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
