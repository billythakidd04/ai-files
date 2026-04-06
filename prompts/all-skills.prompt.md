---
name: all-skills
description: Run all relevant skills to address the current state of the workspace and changes.
---
Analyze all changes on the current branch, then systematically use each relevant agent and skill (such as the `context7` and `github-actions-expert` agents, and skills like `watch-docs`, `atomic-commits`, etc.) to address issues in their respective domains. Execute all applicable agents and skills to ensure comprehensive coverage.
Ensure the `atomic-commit` skill is invoked last to prevent it from creating commits before all other skills have had a chance to make changes. This prevents multiple update commits if issues are found.