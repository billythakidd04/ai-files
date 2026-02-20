# Copilot Instructions for Skills Repository

This repository hosts AI "Skills" definitions used to extend Copilot's capabilities. Each skill is self-contained in its own directory.

## Project Structure

- **Structure**: Each skill resides in a dedicated directory: `./<skill-name>/SKILL.md`.
- **Naming**: Directory names should be kebab-case (e.g., `atomic-commits`).
- **File**: The definition file MUST be named `SKILL.md`.

## Skill Definition Format (`SKILL.md`)

Every `SKILL.md` must start with YAML frontmatter followed by a markdown body defining the agent's behavior.

### 1. Frontmatter
Required fields:
- `name`: Must match the directory name.
- `description`: A short summary of when to use this skill.

```yaml
---
name: my-skill-name
description: Brief description of what this skill achieves.
---
```

### 2. Body Structure
Follow this standard structure for the markdown content:
- **Title**: `# Human Readable Title`
- **Role**: `## Role` - Define the persona (e.g., "Senior Git Engineer").
- **Task**: `## Task` - numbered list of steps the agent performs.
- **Constraints**: `## Constraints` - Bullet points of strict rules (e.g., formatting, forbidden actions).

## Development Workflow

- **New Skills**: To add a skill, create `<name>/SKILL.md` with the required frontmatter.
