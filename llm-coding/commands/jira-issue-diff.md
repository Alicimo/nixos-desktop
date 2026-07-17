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

2. If a critical detail is missing from the diff summary and conversation context, ask for it one question at a time before creating the issue. Every question must include a concrete suggestion based on the available context so the user can confirm or correct it quickly.
3. Use the diff summary and the conversation context to draft the title, description, and acceptance criteria.
4. Write the ticket as if the work has not yet occurred (pre-change), focusing on the general feature intent without over-specific implementation details.
5. Ensure the Jira issue uses:
   - A user story in the description/body
   - A description in the description/body
   - Acceptance criteria in the dedicated Jira acceptance-criteria field where Jira allows it; otherwise include them in the description/body and report the field limitation
6. Determine the current sprint from the configured Jira board before creating the issue. If an active `@JIRA_ACTIVE_SPRINT_NAME_CONTAINS@` is found, ask the user whether the ticket should be added to that sprint, naming the sprint in the question and suggesting that it should be added. Then create the issue using the Jira CLI, capture the issue key, assign it, optionally add it to that sprint, and return the URL. Use shell variables so the title, description, and acceptance criteria are passed safely, and run the commands in the same shell:

```bash
TITLE="{TITLE}"
CURRENT_SPRINT_ID="$(jira sprint list --state active --plain --columns id,name,state --no-headers | grep -m 1 '@JIRA_ACTIVE_SPRINT_NAME_CONTAINS@' | cut -f1)"
ADD_TO_CURRENT_SPRINT="{ADD_TO_CURRENT_SPRINT}"
RESPONSIBLE_SQUAD_FIELD="@JIRA_RESPONSIBLE_SQUAD_FIELD@"
RESPONSIBLE_SQUAD="@JIRA_RESPONSIBLE_SQUAD@"
ACCEPTANCE_CRITERIA_FIELD="@JIRA_ACCEPTANCE_CRITERIA_FIELD@"
DESCRIPTION=$(cat <<'EOF'
{DESCRIPTION}
EOF
)
ACCEPTANCE_CRITERIA=$(cat <<'EOF'
{ACCEPTANCE_CRITERIA}
EOF
)
ASSIGNEE="$(jira me)"
issue_key=$(jira issue create -tTask @JIRA_LABEL_ARGS@ -s "$TITLE" -b "$DESCRIPTION" --custom "$RESPONSIBLE_SQUAD_FIELD=$RESPONSIBLE_SQUAD" --custom "$ACCEPTANCE_CRITERIA_FIELD=$ACCEPTANCE_CRITERIA" --no-input --raw | jq -r '.key')
jira issue assign "$issue_key" "$ASSIGNEE"
if [ -n "$CURRENT_SPRINT_ID" ] && [ "$ADD_TO_CURRENT_SPRINT" = "yes" ]; then
  jira sprint add "$CURRENT_SPRINT_ID" "$issue_key"
fi
echo "https://xund.atlassian.net/browse/$issue_key"
```

Notes:
- Use `bash`/POSIX shell syntax, not `fish` syntax.
- Keep the create and assign commands in the same shell so `issue_key` is preserved.
- Select the active sprint whose name contains `@JIRA_ACTIVE_SPRINT_NAME_CONTAINS@`.
- If an active `@JIRA_ACTIVE_SPRINT_NAME_CONTAINS@` is found, ask the user whether to assign the ticket to it before creating the issue.
- If no active sprint is found, do not ask about sprint assignment; still create and assign the issue, then return the URL without adding a sprint.
- Set `{ADD_TO_CURRENT_SPRINT}` to `yes` only when the user confirms sprint assignment. Otherwise set it to `no`.
- Use the configured Jira CLI custom keys: responsible squad field `@JIRA_RESPONSIBLE_SQUAD_FIELD@` and acceptance criteria field `@JIRA_ACCEPTANCE_CRITERIA_FIELD@`. Jira CLI derives these keys from custom field names by lowercasing and replacing spaces with hyphens.
- If the Jira CLI config is refreshed, re-check these custom keys. Duplicate Jira field names can collide; if `acceptance-criteria` maps to the wrong field, rename the intended local config entry to a unique name such as `MR Acceptance criteria` and use the derived key `mr-acceptance-criteria`.
- If the local Jira CLI warns that the responsible squad field is not configured, stop and report that the Jira CLI custom-field config must be refreshed or fixed; do not create an unlabeled workaround ticket.
- If Jira rejects the acceptance criteria field because it is not on the create screen, retry once without that custom field only if the acceptance criteria are also included in the description body.
- Use British English spelling.
