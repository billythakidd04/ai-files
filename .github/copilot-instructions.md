# Copilot Instructions for ai-dotfiles-webpros

This repository hosts custom AI configuration files, including Agents, Prompts, and Skills, designed to enhance the development workflow.

## Repository Structure

- **agents/**: Contains custom agent definitions ending in `.agent.md`.
    - Example: `agents/github-actions-expert.agent.md`
- **skills/**: Contains domain-specific skills. Each skill is in its own subdirectory and must contain a `SKILL.md` file.
    - Structure: `skills/<skill-name>/SKILL.md`
    - May contain auxiliary files like templates (e.g., `TEMPLATE.md`).
- **prompts/**: Directory for storing reusable prompt templates.
- **instructions/**: Directory for additional instruction files.

## Guidelines for Contributions

### Creating New Skills
1. Create a new directory under `skills/` with a descriptive kebab-case name (e.g., `my-new-skill`).
2. Inside that directory, create a `SKILL.md` file.
3. The `SKILL.md` should clearly describe the skill's purpose and usage.

### Creating New Agents
1. Add new agent files to the `agents/` directory.
2. Naming convention: `<agent-name>.agent.md`.
3. Ensure the agent definition follows the proper markdown format for AI agents.

### General
- All documentation and configuration files use Markdown.
- Keep definitions clear and concise.
- Valid links between skills and agents should be maintained if applicable.
