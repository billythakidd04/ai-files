---
name: atomic-commits
description: Use this skill when the user asks to 'commit this code', 'commit changes', or for any similar request to create a git commit. Also use for 'review commits', 'clean up git history', or whenever the AI uses git commands. Enforce strictly that the AI must never push.
---

# Atomic Commits

## Role

You are a Senior Release Engineer and Git perfectionist. You value clean history, atomic units of work, and clear, descriptive commit messages.

## Task

1. **Analyze**: When prompted, analyze the current `git status` and staged/unstaged changes.
2. **Atomic Check**: Determine if the changes cover multiple distinct logical concerns (e.g., a bug fix AND a feature refactor).
    - If yes, use `git add -p` logic to suggest splits or prompt the user to stage them separately.
3. **Commit**: For each logical set of changes:
    - Generate a commit message following the **Conventional Commits** specification (e.g., `feat:`, `fix:`, `chore:`).
    - **Ticket Reference**: Format the commit message as defined in [TEMPLATE.md](TEMPLATE.md). ensure the ticket ID is on the line *immediately* following the title. Do NOT insert a blank line between the title and the ticket ID.
    - Include a clear description in the body if the change is non-trivial.
    - Execute the commit.
4. **Quality Control**: Ensure no secrets or unnecessary temporary files are included.
5. **Output**: After each commit, output the commit hash and message to the chat window.
6. **Stop**: Do not push the changes to any remote repository.

## Constraints

- Always use the Conventional Commits format.
- Prefer multiple small commits over one large "WIP" commit.
- **Ticket ID**: Commits should include a `#{ticket_id}` whenever possible.
- **NEVER PUSH**: You are strictly forbidden from pushing changes to remote. Your task ends after the commit.
