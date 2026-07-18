---
name: jira-publish-issues
description: Publish one or more approved Jira Task or Sub-task drafts with configured fields, labels, dependencies, sprint, and assignee. Use after the user has approved a Jira issue or ticket graph.
---

# Publish Jira Issues

Publish approved issue drafts without redesigning their scope. Use British English spelling. Do not create any issue until the user has approved every draft and relationship.

Each draft must provide:

- A stable draft identifier
- Type: Task or Sub-task
- A concise title
- A generated parent Task identifier for each Sub-task
- Blocking draft identifiers, if any
- A user story in the format `As a <actor>, I want <feature>, so that <benefit>`
- The intent explaining why the work matters and what future implementers must understand
- What the ticket delivers
- Testable acceptance criteria
- An optional source specification path

Reject cycles, missing parents, Sub-tasks whose parent is not a Task, and dependencies on unknown drafts before publishing.

## Prepare Jira Content

Create issues in an order where every generated parent and blocker already has a Jira key. Use this description shape:

```markdown
## Source

`docs/specs/example.md`

## User story

As a user, I want a capability, so that I receive a concrete benefit.

## Intent

Explain why this issue exists and the outcome it is intended to enable.

## What to build

The independently observable behavior this ticket delivers.

## Blocked by

- MR-123: Blocking ticket title
```

Omit `Source` when there is no source specification. Always include `User story` and `Intent`, including on Sub-tasks; a Sub-task may retain its parent Task's actor and benefit while expressing its own narrower intent. Use `None` under `Blocked by` when the ticket has no blockers. Put acceptance criteria in the configured Jira acceptance criteria field rather than duplicating them in the description unless the field is unavailable.

## Select The Sprint Once

Before creating the first issue, list active sprints and select the one whose name contains `@JIRA_ACTIVE_SPRINT_NAME_CONTAINS@`. If one is found, ask once whether the whole batch should be added to it. Name the sprint in the question and suggest adding the batch.

If no matching active sprint is found, do not ask about sprint assignment. Continue without adding any issue to a sprint. Apply the one decision consistently to every issue in the batch.

## Create The Issues

Run creation commands in the same Bash/POSIX shell so variables and generated Jira keys are preserved. Do not use Fish syntax. Create parents and blockers before the issues that reference them.

Fetch sprint data separately so a Jira, authentication, or network failure is not mistaken for an empty result. Use literal substring matching. Initialize shared values once:

```bash
if ! ACTIVE_SPRINTS=$(jira sprint list --state active --plain --columns id,name,state --no-headers); then
  # Stop and report that sprint lookup failed.
  exit 1
fi
CURRENT_SPRINT_ID=$(printf '%s\n' "$ACTIVE_SPRINTS" | grep -F -m 1 '@JIRA_ACTIVE_SPRINT_NAME_CONTAINS@' | cut -f1)
ADD_TO_CURRENT_SPRINT="{ADD_TO_CURRENT_SPRINT}"
RESPONSIBLE_SQUAD_FIELD="@JIRA_RESPONSIBLE_SQUAD_FIELD@"
RESPONSIBLE_SQUAD="@JIRA_RESPONSIBLE_SQUAD@"
ACCEPTANCE_CRITERIA_FIELD="@JIRA_ACCEPTANCE_CRITERIA_FIELD@"
if ! ASSIGNEE=$(jira me); then
  # Stop and report that the current Jira user could not be resolved.
  exit 1
fi
```

For each issue, generate its title, description, and acceptance criteria with quoted heredocs. Use a different descriptive delimiter for every value and first verify that the delimiter does not occur as a standalone line in that value. Never use a fixed delimiter such as `EOF` for generated content.

Serialize custom fields using Python's CSV writer because Jira CLI parses each `--custom` argument as CSV. This preserves commas, quotes, equals signs, and multiline values:

```bash
TITLE=$(cat <<'JIRA_TITLE_DRAFT_01'
{TITLE}
JIRA_TITLE_DRAFT_01
)
DESCRIPTION=$(cat <<'JIRA_DESCRIPTION_DRAFT_01'
{DESCRIPTION}
JIRA_DESCRIPTION_DRAFT_01
)
ACCEPTANCE_CRITERIA=$(cat <<'JIRA_ACCEPTANCE_DRAFT_01'
{ACCEPTANCE_CRITERIA}
JIRA_ACCEPTANCE_DRAFT_01
)
jira_custom_arg() {
  python - "$1" "$2" <<'PYTHON_CSV'
import csv
import sys

csv.writer(sys.stdout, lineterminator="").writerow([f"{sys.argv[1]}={sys.argv[2]}"])
PYTHON_CSV
}
RESPONSIBLE_SQUAD_ARG=$(jira_custom_arg "$RESPONSIBLE_SQUAD_FIELD" "$RESPONSIBLE_SQUAD")
ACCEPTANCE_CRITERIA_ARG=$(jira_custom_arg "$ACCEPTANCE_CRITERIA_FIELD" "$ACCEPTANCE_CRITERIA")
```

For a Task, capture creation output before parsing it. Stop if creation fails or the JSON does not contain a non-empty key:

```bash
if ! CREATE_OUTPUT=$(jira issue create -tTask @JIRA_LABEL_ARGS@ -s "$TITLE" -b "$DESCRIPTION" --custom "$RESPONSIBLE_SQUAD_ARG" --custom "$ACCEPTANCE_CRITERIA_ARG" --no-input --raw); then
  # Stop and report the failed draft without retrying the batch.
  exit 1
fi
if ! ISSUE_KEY=$(printf '%s' "$CREATE_OUTPUT" | python -c 'import json, sys; key = json.load(sys.stdin).get("key"); isinstance(key, str) and key or sys.exit(1); print(key)'); then
  # The issue may exist. Stop, preserve CREATE_OUTPUT, and do not retry creation.
  exit 1
fi
```

For a Sub-task, resolve its generated parent identifier to the previously created Task key and use the same checked capture pattern with this creation command:

```bash
jira issue create -tSub-task -P "$PARENT_KEY" @JIRA_LABEL_ARGS@ -s "$TITLE" -b "$DESCRIPTION" --custom "$RESPONSIBLE_SQUAD_ARG" --custom "$ACCEPTANCE_CRITERIA_ARG" --no-input --raw
```

After either issue type is created and its key is validated, assign it and apply the shared sprint decision:

```bash
jira issue assign "$ISSUE_KEY" "$ASSIGNEE"
if [ -n "$CURRENT_SPRINT_ID" ] && [ "$ADD_TO_CURRENT_SPRINT" = "yes" ]; then
  jira sprint add "$CURRENT_SPRINT_ID" "$ISSUE_KEY"
fi
```

Store every generated key in a distinct shell variable so later descriptions, parent arguments, and links use real Jira keys. Also retain a draft-to-key mapping and the completion state of assignment, sprint, and link operations so a partial run can resume safely. Set `{ADD_TO_CURRENT_SPRINT}` to `yes` only when the user confirms sprint assignment; otherwise set it to `no`.

After all issues exist, create each approved blocking relationship exactly once:

```bash
# For the Blocks link type, Jira CLI takes the blocked (inward) issue first.
jira issue link "$BLOCKED_KEY" "$BLOCKER_KEY" Blocks
```

Parent-child relationships express ownership. `Blocks` links express execution order. Create both when both relationships were approved.

## Handle Failures

- If creation fails partway through, stop. Report every created key, the failed draft, and all drafts not attempted. Do not retry the whole batch or create duplicates.
- If Jira rejects the acceptance criteria field because it is not on the create screen, append an `## Acceptance criteria` section to that issue's description and retry that issue once without the acceptance criteria custom field. Report the limitation.
- If the responsible squad field is unavailable, stop and report that the Jira CLI custom-field configuration must be refreshed or fixed. Do not create an unlabeled workaround issue.
- If assignment, sprint addition, or link creation fails after an issue exists, report the issue key and failed operation before continuing only when retrying cannot create duplicate issues.

## Handle Jira Fields

- Use responsible squad field `@JIRA_RESPONSIBLE_SQUAD_FIELD@` with value `@JIRA_RESPONSIBLE_SQUAD@`.
- Use acceptance criteria field `@JIRA_ACCEPTANCE_CRITERIA_FIELD@`.
- Jira CLI derives custom keys from field names by lowercasing and replacing spaces with hyphens.
- If the Jira CLI config is refreshed, re-check the custom keys. Duplicate field names can collide. If `acceptance-criteria` maps to the wrong field, rename the intended local config entry to a unique name such as `MR Acceptance criteria` and use the derived key `mr-acceptance-criteria`.

Return every created issue key and its `https://xund.atlassian.net/browse/{ISSUE_KEY}` URL, followed by any incomplete post-creation operations.
