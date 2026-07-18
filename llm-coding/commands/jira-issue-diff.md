---
description: Create a Jira issue from the diff against main
---

1. Collect all changes (committed, staged, and unstaged) scoped to `main` and summarize the overall change

Committed diff vs main:
!`git diff main...HEAD`

Staged diff vs HEAD:
!`git diff --cached HEAD`

Unstaged diff vs the index:
!`git diff`

Untracked files:
!`git ls-files --others --exclude-standard`

2. Read the relevant untracked files, then summarize the overall change. If a critical detail is missing from the diff summary and conversation context, ask for it one question at a time before drafting the issue. Every question must include a concrete suggestion based on the available context so the user can confirm or correct it quickly.
3. Draft a concise title, user story, intent, description, and testable acceptance criteria. Write the user story and intent as if the work has not yet occurred, so the issue communicates why the change should be made rather than merely summarizing the diff. Use the user story format `As a <actor>, I want <feature>, so that <benefit>`.
4. Present the complete draft for approval. After the user approves it, load and follow the `jira-publish-issues` skill with stable draft identifier `issue-1`, type Task, no generated parent, and no blockers.
