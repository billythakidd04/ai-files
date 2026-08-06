#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") <settings.json>"
    echo
    echo "Synchronizes CLI permissions from the Antigravity settings.json file"
    echo "and appends them to the Antigravity IDE auto-saved.toml policy file."
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    exit 0
}

if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
    usage
fi

if [ "$#" -lt 1 ]; then
    echo "Error: Invalid number of arguments." >&2
    usage
fi

SETTINGS_JSON="$1"
TARGET_TOML="$HOME/.gemini/policies/auto-saved.toml"

if [ ! -f "$SETTINGS_JSON" ]; then
    echo "Error: Settings file $SETTINGS_JSON not found."
    exit 1
fi

mkdir -p "$(dirname "$TARGET_TOML")"
touch "$TARGET_TOML"

# Extract allow commands, ignore empty or null
allow_cmds=$(jq -r '.permissions.allow[]? // empty' "$SETTINGS_JSON")

if [ -z "$allow_cmds" ]; then
    exit 0
fi

echo "$allow_cmds" | while read -r line; do
    if [[ "$line" =~ command\((.*)\) ]]; then
        cmd="${BASH_REMATCH[1]}"
        
        # Strip trailing * wildcards 
        cmd="${cmd% \*}"
        cmd="${cmd%\*}"
        
        # Split into a TOML array format
        IFS=' ' read -r -a parts <<< "$cmd"
        
        toml_array="["
        for i in "${!parts[@]}"; do
            toml_array+=" \"${parts[$i]}\""
            if [ $i -lt $((${#parts[@]} - 1)) ]; then
                toml_array+=","
            fi
        done
        toml_array+=" ]"
        
        # Check if the rule already exists for run_shell_command
        if ! grep -A 2 'toolName = "run_shell_command"' "$TARGET_TOML" | grep -q "commandPrefix = $toml_array"; then
            cat << EOF >> "$TARGET_TOML"
[[rule]]
decision = "allow"
priority = 950
toolName = "run_shell_command"
commandPrefix = $toml_array
modes = [ "default", "autoEdit", "yolo" ]

EOF
            echo "Added $cmd to auto-saved.toml"
        fi
    fi
done

echo "✅ Synced permissions to $TARGET_TOML"
