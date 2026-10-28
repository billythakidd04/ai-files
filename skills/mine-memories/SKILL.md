---
name: mine-memories
description: >
  MANDATORY: Run this skill immediately when a plan is accepted before any implementation work begins, and after every commit, group of commits, or push. Also use when the user asks to "mine memories", "update mempalace", or whenever a major milestone/decision is reached. This ensures the AI's long-term memory is updated with accepted plans, workspace context, architectural decisions, and conversation history.
---

# Mine Memories

## Role

You are a Digital Archivist and Memory Architect. Your goal is to ensure that every significant insight, decision, and piece of context is properly ingested into the MemPalace to provide high-fidelity long-term memory without causing server timeouts or database bloat.

## Task

1. **Server Verification**:
    - **Daemon Start Check**: Ensure the background daemon is running before invoking tools:
      `uv run mempalace daemon status || uv run mempalace daemon start`
    - **Single-Writer Lock Awareness**: When the MCP server (`mempalace-mcp`) is active, it holds `mine_palace_lock` for its lifetime. All mutating operations must route through MCP tools (`mempalace_diary_write`, `mempalace_kg_add`, `mempalace_delete_by_source`) rather than CLI write commands (`mempalace mine`, `mempalace sync`).
    - **Status Check**: Call `mempalace_status` (or CLI `uv run mempalace status`) to confirm palace health.

2. **Pre-Execution Plan Ingestion (When a Plan is Accepted)**:
    - **Trigger**: Run this step immediately after the user accepts an implementation plan and before executing code changes or terminal commands.
    - **Record Accepted Plan**: Use `mempalace_diary_write` to store the plan summary, objectives, and acceptance criteria:
      `mempalace_diary_write(entry="[Plan Accepted] Goal: <summary>. Scope: <deliverables>. Key Decisions: <decisions>")`
    - **Record Entities**: Add planned components, dependencies, or architectural targets to the knowledge graph with `mempalace_kg_add`.
    - **Store Plan Artifact**: If a plan artifact exists (such as a markdown plan file), read the plan and store it with `mempalace_add_drawer(wing="<workspace-name>", room="plans", content=..., source_file=...)`.

3. **Session Continuity & Decisions (Post-Commit / Progress)**:
    - Capture concise, high-signal continuity using `mempalace_diary_write`:
      `mempalace_diary_write(entry="<milestone, architectural decision, bugs fixed, current status>")`
    - Update entity facts or relationships using `mempalace_kg_add` or `mempalace_kg_supersede`.
    - **Why**: Diary and knowledge graph updates are instantaneous, high-signal, and do not trigger slow vector chunking.

4. **High-Signal Documentation & File Ingestion**:
    - **Directory Requirement for `mempalace_mine`**: In `mode="projects"`, `mempalace_mine` requires a directory path (`os.path.isdir`), not a single file. Passing a file path returns `source not found`.
    - **Single File Content**: To ingest an individual documentation file (e.g., `GEMINI.md`), read the file content and call `mempalace_add_drawer(wing="<workspace-name>", room="documentation", content=..., source_file=...)`.
    - **STRICT PROHIBITION**: NEVER pass `source="."` or entire unconstrained codebase trees to `mempalace_mine`. Dumping full source trees through MCP causes 3-minute timeouts, desynchronizes the JSON-RPC pipe, and floods the palace with low-value syntax noise.

5. **Conversation Logs Mining (CLI Only)**:
    - Session transcript logs contain rich conversation context, but full JSONL transcripts are large and will timeout over MCP.
    - **Run via CLI ONLY**, never via MCP:
      `uv run mempalace mine <appDataDir>/brain/<conversation-id>/.system_generated/logs --mode convos --wing <workspace-name>`
    - **CRITICAL**: Always pass the logs directory path, not individual file paths.

6. **Validation**:
    - Call `mempalace_status` or run `uv run mempalace status` to verify drawer counts.

## Constraints

- **No Raw SQLite Deletions**: NEVER execute raw `DELETE` SQL commands against `chroma.sqlite3`. Raw deletions bypass ChromaDB's binary HNSW vector index (`data_level0.bin`, `header.bin`), resulting in index divergence and slow FTS5 trigram rebuild lockups. Always use native tools (`mempalace_delete_by_source` or `mempalace sync`).
- **Session-ID Scoping Only**: All conversation and log operations must be strictly bounded by Session ID (UUID), never by generic file names (`transcript.jsonl`, `models.json`). Generic file names exist across all sessions and codebases.
- **Signal over Noise**: Focus strictly on the "why", architectural designs, bug root causes, and user preferences. Never index binary files, dependencies, build caches, or raw source trees.
- **No Heavy / Bulk Mining over MCP**: The MCP tool interface has a hard 3-minute timeout. Any batch directory indexing (like conversation logs or multi-file folders) MUST be executed through the CLI (`uv run mempalace mine ...`).
- **No Routine Antigravity Dumps**: Do not re-index `~/.gemini/antigravity/` during routine post-commit mining. That is an initial bootstrapping operation only.
- **Privacy**: Never mine sensitive credentials, passwords, or personal API tokens.
- **Wings**: Always set `--wing` (or `wing="..."`) to the active workspace name to keep memories isolated.
