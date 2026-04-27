---
name: debug-github-action
description: Debugs a specific GitHub Actions workflow run using the provided URL.
---

# Debug GitHub Action Run

Debug the GitHub Actions workflow run at {{url}}.

To accomplish this:
1. **Fetch workflow run details**: Use the GitHub MCP or `gh run view` to get the status, conclusion, and basic information about the run.
2. **Retrieve logs**: Use the GitHub MCP or `gh run view --log` to pull the logs for the failed jobs/steps.
3. **Analyze failures**: Identify the specific step that failed and the error messages in the logs.
4. **Research context**: If the error is related to project code, examine the relevant files in the workspace. If it's a tool or environment error, use the **Context7** MCP to retrieve documentation or code examples. If Context7 doesn't provide the answer, fall back to a **Google Search**.
5. **Propose and implement fixes**: Based on the analysis, suggest the necessary changes to the codebase or workflow file to resolve the issue.

Please provide the URL of the GitHub Actions run you want to debug.
