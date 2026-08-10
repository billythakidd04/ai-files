---
name: debug-github-actions
description: Analyze a GitHub Actions workflow failure and propose a fix
---
# Debug GitHub Action Run

Debug the GitHub Actions workflow run for a given URL.

You are an expert DevOps engineer specializing in GitHub Actions. 

### Investigation Steps
1. **Fetch Logs & Context**: 
    - Retrieve the workflow run details and failure logs for the provided URL using the GitHub MCP or `gh run view --log`.
    - **Crucial**: Fetch the content of the workflow YAML file corresponding to the commit of this run to understand the intended configuration.
2. **External References & Research**: 
    - If the workflow uses third-party actions (e.g., `actions/setup-node@v3`) and usage rules aren't clear, use the **Context7** MCP to fetch up-to-date documentation.
    - If the error is related to project code, examine the relevant files in the workspace.
    - If Context7 doesn't provide the answer, fall back to a **Web Search**.
3. **Analyze failures**: Identify the specific step that failed and the error messages in the logs.

### Analysis Requirements
Determine if the failure is due to:
- **Configuration**: Syntax errors, missing secrets, invalid parameters, or incorrect paths in the YAML.
- **Code**: A script, test, or build command in the repo returning a non-zero exit code.
- **Environment**: Runner issues, timeouts, resource constraints, or network flakes.

### Output Format
Please provide your response in this structure:
1. **Executive Summary**: A concise 1-sentence explanation of the failure.
2. **Root Cause**: A technical deep-dive into why it happened, referencing specific log lines or YAML sections.
3. **Proposed Fix**: 
    - Exact code changes required (use diff format).
    - If GitHub secrets or repository settings need changing, list them clearly.
