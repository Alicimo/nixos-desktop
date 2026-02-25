---
description: Create a Jira issue from the diff against main
---

1. Collect all changes (committed, staged, and unstaged) scoped to `main` and summarize the overall change

Committed diff vs main:
!`git diff main...HEAD`

Staged diff vs main:
!`git diff --cached main`

Unstaged diff vs main:
!`git diff main`

2. Use the diff summary and the conversation context to draft the title and description
3. Write the ticket as if the work has not yet occurred (pre-change), focusing on the general feature intent without over-specific implementation details
4. Ensure the description includes:
   - A user story
   - A description
   - Acceptance criteria
5. Create the issue using the Jira CLI, capture the issue key, assign it, and return the URL (run in the same shell):

```bash
set issue_key (jira issue create -tTask -lDataScience -s"{TITLE}" -b"{DESCRIPTION}" --custom Responsible-Squad="Health Check Squad" --no-input --raw | jq -r '.key')
jira issue assign "$issue_key" (jira me)
echo "https://xund.atlassian.net/browse/$issue_key"
```
