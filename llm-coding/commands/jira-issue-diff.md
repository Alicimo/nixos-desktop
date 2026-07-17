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
3. Load and follow the `jira-create-issue` skill using the diff summary and conversation context.
