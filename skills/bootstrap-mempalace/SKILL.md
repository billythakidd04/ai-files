---
name: bootstrap-mempalace
description: Procedures for bootstrapping, updating, and maintaining MemPalace memory using the 'uv' package manager. Use when initializing new projects into the palace, updating MemPalace from source, or troubleshooting x86_64 macOS compatibility issues.
---

# MemPalace UV Workflow

This skill provides verified procedures for managing MemPalace with `uv`, specifically tailored for macOS environments and non-interactive agent sessions.

## Core Operations

### 1. Installation & Environment Setup

MemPalace requires `chromadb`, which can have compatibility issues with Python 3.14 on x86_64 macOS due to `onnxruntime` wheel availability.

**Mac x86_64 Fix (Prerequisite):**
```bash
uv python install 3.12 && uv python pin 3.12
```

**Editable Installation:**
From the `mempalace` source directory:
```bash
uv pip install -e .
```

### 2. Bootstrapping a New Project (Headless)

Initializing a project is typically interactive. To run it headlessly and accept defaults (recommended for agents):

```bash
# Initialize Wing and Rooms
echo "" | uv run mempalace init /path/to/project --yes

# Initial Mining of files
uv run mempalace mine /path/to/project
```

### 3. Updating MemPalace from Source

To update the MemPalace application while preserving local compatibility fixes:

```bash
# 1. Reset local pyproject.toml and remove lockfile to avoid conflicts
git checkout pyproject.toml && rm uv.lock

# 2. Pull latest and sync
git pull && uv lock --upgrade && uv sync

# 3. Re-apply onnxruntime compatibility fix if on x86_64 macOS
uv add "onnxruntime<1.20"
```

### 4. Search & Session Context

**Manual Search:**
```bash
uv run mempalace search "query string" --wing project-name
```

**Generating Session Context (Wake-up):**
Use this to quickly see the L1 (Essential Story) for the current project.
```bash
uv run mempalace wake-up
```

## Maintenance Workflows

### Mining Updates
Always mine after completing a major task or fixing a recurring bug to ensure the "fix" is durable.
```bash
uv run mempalace mine /path/to/project
```

### Entity Anchoring & entities.json
MemPalace uses `entities.json` in the project root to anchor knowledge. Auto-detection may catch generic terms (e.g., "Update", "Invalid") as projects.
- **Action:** Manually review and clean `entities.json` after `init`.
- **Tip:** Add your name to the `"people"` array so the agent knows who you are in the history.
- **Benefit:** Distinguishes generic words from specific entities and enables "Tunnels" (cross-wing links) between projects sharing infrastructure patterns.

### Cleaning Redundant Wings
If duplicate wings are created (e.g., `project` vs `project-repo`), you must decide on a name and clean up the database. The `status` command shows current counts:
```bash
uv run mempalace status
```

## Configuration (GEMINI.md)

The following rules should be in the global `~/.gemini/gemini.md` to ensure consistent agent use:

```markdown
- ALWAYS use MemPalace as your primary source of truth for architectural decisions, project history, and user preferences.
- If you encounter an error or a recurring issue, search MemPalace (using 'uv run mempalace search') before attempting a fix.
- When a task is complete or a major decision is made, "mine" the memory into the palace to ensure persistence.
```

## Pitfalls & Troubleshooting

- **Interactive Prompts:** If `mempalace` hangs, it is likely waiting for user input. Always use `echo ""` pipes for `init`.
- **Duplicate Wings:** Newer versions of MemPalace have stronger project identity detection and may suggest more specific names (e.g., from Docker images).
- **Python Version:** Always verify Python version if `onnxruntime` fails to install. Pin to 3.12 for safest results.
