---
name: code-review
description: Review changes from a fixed Git comparison point using independent correctness and simplification agents. Use after implementation or when the user asks for a code review.
---

# Code Review

Coordinate independent review lenses without performing the review in the calling context.

## Inputs

Establish before dispatching:

- A fixed Git comparison point such as a commit, branch, tag, or merge base
- The originating task, issue, or specification when one exists
- Confirmed testing seams and acceptance criteria when applicable
- Reported verification commands and results when available
- Any caller-requested reviewer selection

Verify that the comparison point resolves and identify untracked files before launching reviewers. The review scope includes committed, staged, and unstaged tracked changes relative to the fixed point, plus supplied untracked files. Do not paste the full diff into each prompt; give reviewers the fixed point and let them inspect the same worktree directly.

## Select Reviewers

Run these reviewers in parallel by default:

- `code-reviewer` for correctness, specification conformance, tests, security, performance, and repository standards
- `code-simplifier` for behavior-preserving reductions in avoidable complexity

Honor an explicit caller request for either reviewer alone. For documentation-only, metadata-only, or generated-only changes, the calling agent may omit `code-simplifier`; state that decision in the result. Do not invoke the debugger as a review lens. If verification is failing unexpectedly, return control to the caller for diagnosis before reviewing the change as complete.

## Dispatch

Give every selected reviewer:

- The fixed comparison point
- The paths of any untracked files that belong to the change
- The task or specification, if available
- Testing seams and acceptance criteria, if applicable
- Verification evidence, clearly identified as evidence the reviewer did not independently produce
- Relevant repository guidance that is not discoverable from the worktree

Reviewers are read-only. They inspect the diff and repository guidance themselves and return findings with exact file and line references.

## Aggregate

Keep each reviewer's findings under its own heading. Do not merge or rerank findings from different lenses.

Report:

- Each selected reviewer and why it was selected
- Each omitted reviewer and why it was omitted
- Critical and Important findings, which block completion
- Suggestions, which do not block completion
- Supplied verification evidence and any verification gap

Do not run a second review round unless the caller explicitly requests one.
