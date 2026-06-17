---
name: pre-commit-polish
description: Run all relevant skills to polish branch changes before committing.
---

Compare current branch against base (main/master). If no branch-level changes exist at all, exit early with a message. Otherwise proceed regardless of whether changes are staged, unstaged, or committed.

## Step 1 - Identify changed files

Run `git diff <base>...HEAD --name-only` and `git status` for unstaged changes. Categorize by type:

- GitHub Actions (`.github/workflows/*.yml`) → `github-actions-expert` agent
- Docs/Markdown (`.md`) → `watch-docs`
- Any code changes → always run `security-analyst` and `code-review`

Also check `.claude/`, `.copilot/`, and `.github/` for project-specific skills and include any discovered there.

## Step 2 - Run skills in order

Execute applicable skills in this sequence. Skip file-type-specific skills if no matching files changed. `security-analyst` and `code-review` always run.

1. `github-actions-expert` agent (workflow YAML changes)
2. `security-analyst` skill (always)
3. `code-review` skill (always)
4. `watch-docs` skill (any source file changes)
5. `test-guardian` skill (logic/feature changes)
6. Any additional project-specific skills

Skills should auto-fix issues where possible.

## Step 3 - Gate on blocking issues

If any skill reports a blocking issue it cannot resolve automatically, halt and surface it. Do not proceed to commit until resolved.

## Step 4 - Commit

Invoke `atomic-commits` only after all other skills complete with no unresolved blocking issues.

## Step 5 - Mine memories

Run `mine-memories` skill. If mempalace is not installed, fall back to native file-based memory to capture key decisions and architectural context from this session.
