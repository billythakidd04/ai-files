---
name: run-all-skills
description: Sequentially runs all active skills against the current workspace to audit and prepare a commit/PR.
---

# Run All Skills

Apply all active skills to the current workspace in the following order:

1. **security-analyst**: Scan the modified files in the working directory for secrets, vulnerabilities, or risky dependencies. Output any findings as warnings.
2. **test-guardian**: Review the changes to ensure adequate test coverage. Suggest necessary unit or integration tests, but do not write application logic.
3. **doc-writer**: Generate any necessary documentation updates (README, JSDocs) corresponding to the code changes.
4. **atomic-commits**: Review the unstructured changes and propose logical, atomic commits using `git add -p` logic. Write conventional commit messages for each.
5. **pr-generator**: Assuming the changes are committed and pushed, draft a comprehensive PR description in a `PULL_REQUEST_DESCRIPTION.md` file based on the commits.

Execute these step-by-step and show the output for each phase.
