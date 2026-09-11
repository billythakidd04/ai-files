---
name: mine-memories
description: >
  MANDATORY: Run this skill after every commit, group of commits, or push. Also use when the user asks to "mine memories", "update mempalace", or whenever a major milestone/decision is reached. This ensures the AI's long-term memory is updated with workspace context, architectural decisions, and conversation history.
---

# Mine Memories

## Role

You are a Digital Archivist and Memory Architect. Your goal is to ensure that every significant insight, decision, and piece of context is properly ingested into the MemPalace to provide the AI with a high-fidelity long-term memory.

## Task

1. **Workspace Mining**: Ingest the current state of the codebase, documentation (specifically `GEMINI.md` files), and project notes.
    - Command: `uv run mempalace mine .`
2. **Conversation Mining (MANDATORY)**: Persist insights from the current session transcript logs.
    - Extract `<appDataDir>` and `<conversation-id>` from your system context.
    - Identify the logs directory path: `<appDataDir>/brain/<conversation-id>/.system_generated/logs`.
    - **CRITICAL**: The command requires the directory path. Do not pass a file path. A file path causes `mempalace` to process 0 files.
    - Set the `--wing` flag to the current workspace directory name.
    - Command: `uv run mempalace mine <appDataDir>/brain/<conversation-id>/.system_generated/logs --mode convos --wing <workspace-name>`
    - Verify that the command output shows processed files.
3. **Global Memory Mining**: Ensure global preferences and cross-project facts are filed.
    - Command: `uv run mempalace mine ~/.gemini/GEMINI.md`
4. **Antigravity Context Mining**: Capture broader AI system context (brains, knowledge, prompting).
    - Command: `uv run mempalace mine ~/.gemini/antigravity/ --wing antigravity`
5. **Validation**: Confirm the data has been filed.
    - Command: `uv run mempalace status`

## Constraints

- **Signal over Noise**: Focus on capturing the 'why' and architectural significance.
- **Directory Path Required**: Always pass the logs directory path to `mempalace mine --mode convos`. Passing a single file path results in 0 files processed.
- **Privacy**: Never mine sensitive credentials or secrets into the palace.
- **Wings**: Use the appropriate `--wing` flag to maintain clear boundaries between project-specific and general system context.
- **Verification**: Always run `status` to ensure ingestion success.
