---
description: Create a Jira issue from a short user input
---

Use the input and conversation context to draft a Jira issue for later follow-up, focusing on the general feature intent without over-specific implementation details.

If any of the following are missing, ask for them one at a time before creating the issue. Every question must include a concrete suggestion based on the user's wording so they can confirm or correct it quickly.
- Location hints (file references or module/component names)
- Expected outcome (what success looks like)
- Constraints (what must not change or must remain compatible)
- Verification (how to validate)

Input:
$ARGUMENTS

Requirements for the Jira issue:
- A user story
- A description
- Acceptance criteria

Requirements for the description/body:
- A user story
- A description
- Include these sections when supplied:
  - Location hints
  - Expected outcome
  - Constraints
  - Verification

Create the issue, assign it to yourself, and return the URL. Use shell variables so the title, description and acceptance criteria are passed safely to the Jira CLI, and run the commands in the same shell:

```bash
TITLE="{TITLE}"
DESCRIPTION=$(cat <<'EOF'
{DESCRIPTION}
EOF
)
ACCEPTANCE_CRITERIA=$(cat <<'EOF'
{ACCEPTANCE_CRITERIA}
EOF
)
ASSIGNEE="$(jira me)"
issue_key=$(jira issue create -tTask -lDataScience -s "$TITLE" -b "$DESCRIPTION" --custom Responsible-Squad="Health Check Squad" --custom Acceptance-criteria="$ACCEPTANCE_CRITERIA" --no-input --raw | jq -r '.key')
jira issue assign "$issue_key" "$ASSIGNEE"
echo "https://xund.atlassian.net/browse/$issue_key"
```

Notes:
- Use `bash`/POSIX shell syntax, not `fish` syntax.
- Keep the create and assign commands in the same shell so `issue_key` is preserved.
- If the local Jira CLI warns that `Responsible-Squad` or `Acceptance-criteria` is not configured but issue creation succeeds, continue and return the created URL.
- Use British English spelling.
