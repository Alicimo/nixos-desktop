---
description: Create a Jira issue from a short user input
---

Use the input and conversation context to draft a Jira issue for later follow-up, focusing on the general feature intent without over-specific implementation details.

If any of the following are missing, ask for them one at a time before creating the issue. Every question must include a concrete suggestion based on the user's wording so they can confirm or correct it quickly.
- Location hints (file references or module/component names)
- Expected outcome (what success looks like)
- Constraints (what must not change or must remain compatible)
- Verification (how to validate)

Include these sections in the description when supplied:

- Location hints
- Expected outcome
- Constraints
- Verification

Load and follow the `jira-create-issue` skill to draft and create the issue.
