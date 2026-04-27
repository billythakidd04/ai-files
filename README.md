# AI Dotfiles

Custom AI context files, agent definitions, prompts, and skills to optimize AI-assisted development workflows.

## 📁 Repository Organization

- **`agents/`**: Role-based AI agent definitions. Each agent is a specialist in a specific domain.
- **`prompts/`**: Reusable AI workflow prompts for complex or repetitive tasks.
- **`skills/`**: Specialized capabilities for AI assistants that provide modular instructions and enforce workflows.
- **`.github/copilot-instructions.md`**: Specialized instructions for GitHub Copilot.

## 🤖 Agents

- **GitHub Actions Expert**: Specialist in secure and efficient CI/CD workflows, focusing on security hardening, supply-chain safety, and best practices.
- **Context7-Expert**: Advanced documentation-powered agent that uses the Context7 MCP to provide 100% accurate, version-specific guidance for any programming library or framework. It is designed to check your local versions and advise on upgrades.

## 📝 Prompts

- **Address Pull Request Comments**: A structured workflow to automatically review comments on a pull request URL and systematically address the issues raised.

## ⚡ Skills

- **`atomic-commits`**: Enforces atomic changes and conventional git history.
- **`pr-generator`**: Automates descriptive pull request creation.
- **`security-analyst`**: Provides security audits and vulnerability scanning.
- **`test-guardian`**: Ensures new changes are accompanied by robust unit and integration tests.
- **`watch-docs`**: Automatically updates documentation to reflect code changes.

## 🚀 How to Use

### Gemini CLI
For Gemini CLI, these components can be referenced directly. Skills can be activated using the `activate_skill` tool:
```bash
/activate_skill watch-docs
```

### GitHub Copilot
The instructions in `.github/copilot-instructions.md` are automatically used by GitHub Copilot to provide context-aware suggestions and follow the repository's coding standards.

### Other AI Assistants
The Markdown files in this directory are designed to be easily readable by any LLM. Simply provide the contents of an agent or skill file to your AI assistant to give it specialized context.
