---
name: jira-create-issue
description: Create Jira Task issues with the configured fields, labels, sprint, and assignee. Use when drafting and creating a Jira issue from user input, conversation context, or repository changes.
---

# Create A Jira Issue

Use the supplied context to draft and create a Jira Task for later follow-up. Focus on the general feature intent without over-specific implementation details, and write as if the work has not yet occurred.

## Draft The Issue

Prepare:

- A concise title
- A description containing a user story and a clear description of the requested change
- Testable acceptance criteria

Use British English spelling.

## Select The Sprint

List active sprints and select the one whose name contains `@JIRA_ACTIVE_SPRINT_NAME_CONTAINS@`. If one is found, ask whether the issue should be added to it. Name the sprint in the question and suggest adding it.

If no matching active sprint is found, do not ask about sprint assignment. Continue creating and assigning the issue without adding it to a sprint.

## Create The Issue

After resolving sprint assignment, create the issue, assign it to yourself, optionally add it to the selected sprint, and return its URL. Run the commands in the same Bash/POSIX shell so the variables are preserved. Do not use Fish syntax.

Use shell variables and quoted heredocs so generated content is passed safely to the Jira CLI:

```bash
TITLE=$(cat <<'EOF'
{TITLE}
EOF
)
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

Set `{ADD_TO_CURRENT_SPRINT}` to `yes` only when the user confirms sprint assignment. Otherwise set it to `no`.

## Handle Jira Fields

- Use responsible squad field `@JIRA_RESPONSIBLE_SQUAD_FIELD@` with value `@JIRA_RESPONSIBLE_SQUAD@`.
- Use acceptance criteria field `@JIRA_ACCEPTANCE_CRITERIA_FIELD@`.
- Jira CLI derives custom keys from field names by lowercasing and replacing spaces with hyphens.
- If the Jira CLI config is refreshed, re-check the custom keys. Duplicate field names can collide. If `acceptance-criteria` maps to the wrong field, rename the intended local config entry to a unique name such as `MR Acceptance criteria` and use the derived key `mr-acceptance-criteria`.
- If the responsible squad field is not configured, stop and report that the Jira CLI custom-field config must be refreshed or fixed. Do not create an unlabeled workaround issue.
- If Jira rejects the acceptance criteria field because it is not on the create screen, include the acceptance criteria in the description body and retry once without that custom field. Report the field limitation.
