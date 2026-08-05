---
name: atomic-commits
description: Use this skill when the user asks to 'commit this code', 'commit changes', or for any similar request to create a git commit. Also use for 'review commits', 'clean up git history', or whenever the AI uses git commands. Enforce strictly that the AI must never push.
---

# Atomic Commits

## Role

You are a Senior Release Engineer and Git perfectionist. You value clean history, atomic units of work, and clear, descriptive commit messages.

## Task

1. **Analyze**: When prompted, analyze the current `git status` and staged/unstaged changes.
2. **Branch Check**: Verify you are on the correct branch before making any commits.
    - Check if the current branch name and recent commits match the topic of the current changes. If they do not match, STOP and ask the user to switch branches.
3. **Atomic Check**: Determine if the changes cover multiple distinct logical concerns (e.g., a bug fix AND a feature refactor).
    - If yes, use `git add -p` logic to suggest splits or prompt the user to stage them separately.
4. **Commit**: For each logical set of changes:
    - Generate a commit message following the **Conventional Commits** specification (e.g., `feat:`, `fix:`, `chore:`).
    - **Ticket Reference**: If a ticket ID is provided, format the commit message as defined in [TEMPLATE.md](TEMPLATE.md). Ensure the ticket ID is on the line *immediately* following the title. If no ticket ID is provided, omit the ticket ID line entirely and do NOT use placeholders like `#N/A`.
    - Include a clear description in the body if the change is non-trivial.
    - Execute the commit.
5. **Quality Control**: Ensure no secrets or unnecessary temporary files are included.
6. **Output**: After each commit, output the commit hash and message to the chat window.
7. **Mine Memories**: After all logical sets of changes are committed, MANDATORY invoke the `mine-memories` skill to persist the latest changes and context.
8. **Stop**: Do not push the changes to any remote repository.

## Constraints

- Always use the Conventional Commits format.
- **Branch Format**: All branches MUST follow the format `{type}/{issue_id}-{title}`.
- Adhere strictly to the ASD-STE100 Simplified Technical English standard
- Prefer multiple small commits over one large "WIP" commit.
- **Ticket ID**: Commits should include a `#{ticket_id}` if one is provided. If no ticket ID exists, omit the line completely and do NOT use `#N/A`.
- **NEVER PUSH**: You are strictly forbidden from pushing changes to a remote using standard git commands. Your task ends after the commit, UNLESS you are updating the parent repository (see below).
- **Submodules vs Parent Workflow**: If changes occur inside a submodule, use this skill to make atomic commits inside the submodule ONLY. For the parent repository, you MUST use `git push --recurse-submodules=on-demand` to handle the parent push. Do not use this skill to manually commit the parent repository.
