---
description: Create a Jira issue from a short user input
---

Use the input and conversation context to draft a Jira issue for later follow-up, focusing on the general feature intent without over-specific implementation details.

If any of the following are missing, ask for them one at a time before creating the issue:
- Location hints (file references or module/component names)
- Expected outcome (what success looks like)
- Constraints (what must not change or must remain compatible)
- Verification (how to validate)

Input:
$ARGUMENTS

Requirements for the description:
- A user story
- A description
- Acceptance criteria
 - Include these sections when supplied:
   - Location hints
   - Expected outcome
   - Constraints
   - Verification

Create the issue, assign it to yourself, and return the URL (run in the same shell):

```bash
set issue_key (jira issue create -tTask -lDataScience -s"{TITLE}" -b"{DESCRIPTION}" --custom Responsible-Squad="Health Check Squad" --no-input --raw | jq -r '.key')
jira issue assign "$issue_key" (jira me)
echo "https://xund.atlassian.net/browse/$issue_key"
```
