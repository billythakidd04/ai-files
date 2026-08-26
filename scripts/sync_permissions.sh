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

process_permissions() {
    local decision="$1"
    local cmds
    cmds=$(jq -r ".permissions.${decision}[]? // empty" "$SETTINGS_JSON")

    if [ -z "$cmds" ]; then
        return 0
    fi

    echo "$cmds" | while read -r line; do
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
            if ! grep -B 4 "commandPrefix = $toml_array" "$TARGET_TOML" 2>/dev/null | grep -q "decision = \"$decision\""; then
                cat << EOF >> "$TARGET_TOML"
[[rule]]
decision = "$decision"
priority = 950
toolName = "run_shell_command"
commandPrefix = $toml_array
modes = [ "default", "autoEdit", "yolo" ]

EOF
                echo "Added $decision rule for $cmd to auto-saved.toml"
            fi
        fi
    done
}

process_permissions "allow"
process_permissions "deny"

echo "✅ Synced permissions to $TARGET_TOML"
