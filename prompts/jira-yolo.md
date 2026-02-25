---
description: Read a Jira issue and implement it
---

Use the issue key from the input and the conversation context to implement the task in a single pass without asking the user for additional context. When details are missing, choose reasonable defaults and proceed.

Input:
$ARGUMENTS

1. Read the Jira issue details using the Jira CLI:

```bash
jira issue view "$ARGUMENTS" --raw
```

2. Summarize the task and restate acceptance criteria from the issue.
3. Create a new branch from `main` before making any changes. The branch name must be `{ISSUE_KEY}/{short_description}` (e.g., `MR-1234/foo_bar`).
4. Implement the changes, following the issue requirements.
5. Run or otherwise validate against the acceptance criteria until they pass.
6. Provide a brief status update and suggest any additional validation steps if needed.
