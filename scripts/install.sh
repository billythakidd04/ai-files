#!/usr/bin/env bash
set -euo pipefail

SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WP_SOURCE="$(cd "$SOURCE/.." && pwd)/wp-ai-files"
COPILOT_HOME="$HOME/.copilot"
CLAUDE_HOME="$HOME/.claude"
VSCODE_USER="$HOME/Library/Application Support/Code/User"

shopt -s nullglob

SKIP_DIRS=""

# Ensure a destination directory exists, prompting to create if not.
# Returns 1 if the directory should be skipped.
ensure_dir() {
  local dir="$1"
  [ -d "$dir" ] && return 0
  case "$SKIP_DIRS" in
    *"|$dir|"*) return 1 ;;
  esac
  printf "Directory '%s' does not exist. Create it? (y/n) " "$dir"
  read -r answer </dev/tty
  case "$answer" in
    y|Y) mkdir -p "$dir" ;;
    *) SKIP_DIRS="$SKIP_DIRS|$dir|"; return 1 ;;
  esac
}

# Symlink all items from src into dest, prompting to create dest if needed.
symlink_into() {
  local src="$1" dest="$2"
  [ -d "$src" ] || return 0
  ensure_dir "$dest" || return 0
  for f in "$src"/*; do
    [ -e "$f" ] || continue
    ln -sfn "$f" "$dest/"
  done
}

# Symlink skills, agents, and prompts from a source root into a tool base dir.
install_source() {
  local src="$1" base="$2"
  symlink_into "$src/skills"  "$base/skills"
  symlink_into "$src/agents"  "$base/agents"
  symlink_into "$src/prompts" "$base/prompts"
}

# Build list of tool base directories.
TOOL_BASES=("$COPILOT_HOME" "$CLAUDE_HOME" "$VSCODE_USER")

JB_BASE="$HOME/Library/Application Support/JetBrains"
if [ -d "$JB_BASE" ]; then
  for jb_dir in "$JB_BASE"/*/; do
    TOOL_BASES+=("${jb_dir}plugins/github-copilot")
  done
fi

for base in "${TOOL_BASES[@]}"; do
  install_source "$SOURCE"    "$base"
  install_source "$WP_SOURCE" "$base"
  echo "Symlinks updated: $base"
done

# Antigravity & Gemini CLI
install_antigravity() {
  local workflows="$HOME/.gemini/antigravity/global_workflows"
  local commands="$HOME/.gemini/commands"

  ensure_dir "$workflows" || return 0
  ensure_dir "$commands"  || return 0

  write_toml() {
    local file="$1" name="$2" default_desc="$3" out_dir="$4" link_dir="$5"
    local description prompt_content
    ln -sfn "$file" "$link_dir/$name.md"
    description=$(grep -m 1 "^description:" "$file" | sed 's/^description: //;s/^"//;s/"$//;s/"/\\"/g')
    [ -z "$description" ] && description="$default_desc"
    prompt_content=$(sed 's/\\/\\\\/g;s/"/\\"/g;s/$/\\n/g' "$file" | tr -d '\n')
    cat <<EOF > "$out_dir/$name.toml"
prompt = "$prompt_content"
description = "$description"
EOF
  }

  for prompt_file in "$SOURCE/prompts/"*.prompt.md; do
    [ -e "$prompt_file" ] || continue
    local filename="${prompt_file##*/}"
    local base_name="${filename%.prompt.md}"
    write_toml "$prompt_file" "$base_name" "Run the $base_name workflow" "$commands" "$workflows"
  done

  for skill_dir in "$SOURCE/skills/"*/; do
    [ -d "$skill_dir" ] || continue
    local skill_name="${skill_dir%/}"
    skill_name="${skill_name##*/}"
    local skill_file="$skill_dir/SKILL.md"
    [ -e "$skill_file" ] || continue
    write_toml "$skill_file" "$skill_name" "Activate the $skill_name skill" "$commands" "$workflows"
  done

  echo "Symlinks updated: Antigravity / Gemini CLI"
}

install_antigravity

echo "Setup complete."
