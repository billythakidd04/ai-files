# ai-dotfiles-webpros

Custom AI configuration files for GitHub Copilot, including Agents, Skills, and Prompts. These resources are designed to enhance the development workflow by providing specialized AI capabilities.

## Usage

To use these resources across all your projects, you can symlink them into your global Copilot directory (e.g., `~/.copilot`).

### Installation

1.  Clone this repository:
    ```bash
    git clone https://github.com/william-caffery_webpros/ai-dotfiles-webpros.git ~/workspace/ai-dotfiles-webpros
    ```

2.  Symlink the desired skills, agents, or prompts to your global configuration:

    ```bash
    # Example: Symlink all skills
    mkdir -p ~/.copilot/skills
    ln -s ~/workspace/ai-dotfiles-webpros/skills/* ~/.copilot/skills/
    
    # Example: Symlink agents
    mkdir -p ~/.copilot/agents
    ln -s ~/workspace/ai-dotfiles-webpros/agents/* ~/.copilot/agents/
    ```

Alternatively, you can symlink specific resources into a single repository's `.github` directory for project-specific usage.

## Agents

Agents are specialized AI personas with specific tools and system prompts.

- **[Context7 Expert](agents/context7.agent.md)** (`@context7`)
    - **Description**: Expert in latest library versions, best practices, and correct syntax using up-to-date documentation via the Context7 MCP server.
    - **Capabilities**: Can resolve library IDs, fetch documentation, and implement solutions using current best practices.

- **[GitHub Actions Expert](agents/github-actions-expert.agent.md)** (`@github-actions-expert`)
    - **Description**: Specialist focused on secure CI/CD workflows, action pinning, OIDC authentication, and supply-chain security.
    - **Capabilities**: Designs and optimizes GitHub Actions workflows, prioritizing security and reliability.

## Skills

Skills are domain-specific capabilities that the AI can adopt to perform complex tasks.

- **[Atomic Commits](skills/atomic-commits/SKILL.md)**
    - **Description**: Enforces clean git history by creating atomic, descriptive commits following the Conventional Commits specification.
    - **Usage**: Automatically invoked when you ask to "commit changes". It analyzes staged changes, ensures logical separation, and writes formatted commit messages.

- **[PR Generator](skills/pr-generator/SKILL.md)**
    - **Description**: Automates the creation of detailed Pull Request descriptions.
    - **Usage**: Analyzes the difference between the current branch and the target, summarizing features, fixes, and extraction ticket references.

- **[Security Analyst](skills/security-analyst/SKILL.md)**
    - **Description**: Performs security auditing, vulnerability scanning, and secret detection.
    - **Usage**: Can be asked to "audit this file" or "check for security issues". It looks for common vulnerabilities (OWASP Top 10) and checks dependencies.

- **[Test Guardian](skills/test-guardian/SKILL.md)**
    - **Description**: Ensures code quality by mandating robust unit and integration tests for new functionality.
    - **Usage**: detailed verification of new code, suggesting or generating `npm test` or `go test` commands to ensure coverage.

- **[Watch Docs](skills/watch-docs/SKILL.md)**
    - **Description**: Keeps documentation in sync with source code changes.
    - **Usage**: Scans for changes in source files and automatically updates corresponding documentation to reflect logic or signature changes.

## Prompts

Reusable prompt templates for common tasks.

- **[Address Pull Request Comments](prompts/address-pr-comments.prompt.md)**
    - **Description**: A prompt to review comments on a specific Pull Request URL and create a plan to address them.
    - **Usage**: `/Address-Pull-Request <url>`
