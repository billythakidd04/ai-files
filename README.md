# AI Dotfiles

Custom AI context files, agent definitions, prompts, and skills to optimize AI-assisted development workflows.

## 📁 Repository Organization

- **`agents/`**: Role-based AI agent definitions. Each agent is a specialist in a specific domain.
- **`prompts/`**: Reusable AI workflow prompts for complex or repetitive tasks.
- **`skills/`**: Specialized capabilities for AI assistants that provide modular instructions and enforce workflows.
- **`../.github/copilot-instructions.md`**: Specialized instructions for GitHub Copilot (located in the root).

## 🤖 Agents

- **GitHub Actions Expert**: Specialist in secure and efficient CI/CD workflows, focusing on security hardening, supply-chain safety, and best practices.
- **Context7-Expert**: Advanced documentation-powered agent that uses the Context7 MCP to provide 100% accurate, version-specific guidance for any programming library or framework. It is designed to check your local versions and advise on upgrades.

## 📝 Prompts

- **Address Pull Request Comments**: A structured workflow to automatically review comments on a pull request URL and systematically address the issues raised.
- **Debug GitHub Action**: A structured workflow to debug failed GitHub Action runs by analyzing logs and proposing fixes.
- **Run All Skills**: An orchestration prompt that runs all available skills in sequence to audit and prepare a workspace for a PR.

## 🚀 Getting Started

To register these prompts globally and enable CLI command support, run the setup script from the root of the repository:

```bash
./setup-prompts.sh
```

This will create symlinks in `~/.gemini/prompts/` and register TOML commands in `~/.gemini/commands/`.

## 🧠 Skills vs Prompts

This repository distinguishes between **Skills** and **Prompts** to provide different levels of automation.

### ⚡ Skills (Modular Roles)
Skills are specialized instructions that turn the AI into a specific role (e.g., a Security Analyst). They are stateless and can be activated at any time.
- **Usage**: Activate using the `activate_skill` tool in Gemini CLI:
  ```bash
  /activate_skill security-analyst
  ```
- **When to use**: When you need the AI to embody a specific persona for a series of tasks.

### 📝 Prompts (Workflows)
Prompts are managed workflows that orchestrate one or more actions (and often skills) to achieve a complex goal.
- **Usage**: Reference them by name (e.g., `/address-pr-comments`) or run them via the CLI.
- **When to use**: For structured, multi-step processes like reviewing PR comments or preparing a commit.

## 🔄 Joint Usage: `run-all-skills`

The `run-all-skills` prompt is a prime example of how prompts and skills work together. It orchestrates all 6 skills in a logical sequence to audit and prepare your workspace for a PR:

1. **security-analyst**: Scans for vulnerabilities.
2. **test-guardian**: Ensures test coverage.
3. **code-reviewer**: High-level logic/best practices audit.
4. **doc-writer**: Synchronizes documentation.
5. **atomic-commits**: Organizes changes into commits.
6. **pr-generator**: Drafts the PR description.

## ⚡ Skills List

- **`atomic-commits`**: Enforces atomic changes and conventional git history.
- **`code-reviewer`**: Performs rigorous logic and security audits.
- **`doc-writer`**: Automatically updates documentation to reflect code changes.
- **`pr-generator`**: Automates descriptive pull request creation.
- **`security-analyst`**: Provides security audits and vulnerability scanning.
- **`test-guardian`**: Ensures new changes are accompanied by robust unit and integration tests.

### GitHub Copilot
The instructions in `.github/copilot-instructions.md` are automatically used by GitHub Copilot to provide context-aware suggestions and follow the repository's coding standards.

### Other AI Assistants
The Markdown files in this directory are designed to be easily readable by any LLM. Simply provide the contents of an agent or skill file to your AI assistant to give it specialized context.
