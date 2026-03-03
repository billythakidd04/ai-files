---
name: debug-github-actions
description: Debug a specific github action failure based on a given url
---
Based on the following GitHub Actions workflow run URL, identify the failure and suggest a fix: {{url}}
Utilize the GitHub API (or mcp if configured) to fetch the logs and details of the failed workflow run. Analyze the logs to determine the root cause of the failure, and provide a step-by-step guide on how to resolve the issue.
Utilize the context7 mcp if avaliable to ensure you have the most up-to-date information about referenced actions.