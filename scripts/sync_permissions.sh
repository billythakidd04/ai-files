#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") <settings.json> <target.toml>"
    echo
    echo "Synchronizes CLI permissions from the Antigravity settings.json file"
    echo "and generates a TOML policy file for the Antigravity IDE."
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    exit 0
}

if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
    usage
fi

if [ "$#" -ne 2 ]; then
    echo "Error: Invalid number of arguments." >&2
    usage
fi

SETTINGS_JSON="$1"
TARGET_TOML="$2"

if [ ! -f "$SETTINGS_JSON" ]; then
    echo "Error: Settings file $SETTINGS_JSON not found."
    exit 1
fi

mkdir -p "$(dirname "$TARGET_TOML")"

cat << 'EOF' > "$TARGET_TOML"
# AUTO-GENERATED from settings.json
# Do not edit manually.

EOF

# Extract allow commands, ignore empty or null
allow_cmds=$(jq -r '.permissions.allow[]? // empty' "$SETTINGS_JSON")

if [ -z "$allow_cmds" ]; then
    exit 0
fi

echo "$allow_cmds" | while read -r line; do
    # Match strings like command(ls) or command(npx playwright test *)
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
        
        cat << EOF >> "$TARGET_TOML"
[[rule]]
decision = "allow"
priority = 950
toolName = "run_command"
commandPrefix = $toml_array
modes = [ "default", "autoEdit", "yolo" ]

EOF
    fi
done

echo "✅ Generated $TARGET_TOML from $SETTINGS_JSON"
