---
description: Create a Jira issue from a short user input
---

Use the input and conversation context to draft a Jira issue for later follow-up, focusing on the general feature intent without over-specific implementation details.

Input:
$ARGUMENTS

If any of the following are missing, ask for them one at a time before creating the issue. Every question must include a concrete suggestion based on the user's wording so they can confirm or correct it quickly.
- Location hints (file references or module/component names)
- Expected outcome (what success looks like)
- Constraints (what must not change or must remain compatible)
- Verification (how to validate)

Draft a concise title, user story, intent, description, and testable acceptance criteria. The user story must use the format `As a <actor>, I want <feature>, so that <benefit>`. The intent must explain why the work matters and what should be communicated to future implementers.

Include these sections in the description when supplied:

- Location hints
- Expected outcome
- Constraints
- Verification

Present the complete draft for approval. After the user approves it, load and follow the `jira-publish-issues` skill with stable draft identifier `issue-1`, type Task, no generated parent, and no blockers.
