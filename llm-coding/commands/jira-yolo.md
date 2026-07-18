---
description: Implement a Jira issue with TDD, review, and a local commit
agent: build
variant: high
---

Implement a Jira issue autonomously, except when its public testing seams are unclear, its blockers are unresolved, or the repository state makes proceeding unsafe.

Input:
$ARGUMENTS

## Parse The Input

Require a Jira issue key as the first argument. Accept an optional base branch in the form `--base <branch>`.

Examples:

- `/jira-yolo MR-1234`
- `/jira-yolo MR-1234 --base feature/parent`
- `/jira-yolo MR-1234 --base current`

Reject missing values, unknown options, and additional positional arguments. Default the base branch to `main`. Resolve `--base current` to the checked-out branch before creating or switching branches.

## Read The Work

1. Read the complete Jira issue, including its acceptance criteria and available comments, using the Jira CLI.
2. Read the raw Jira response to identify its parent and issue links.
3. If the issue is a Sub-task, read its parent Task for context.
4. If the issue references a local specification, read it in full.
5. Read the root `CONTEXT.md` and relevant ADRs under `docs/adr/` if they exist. If absent, proceed silently. Use glossary vocabulary, surface conflicts with existing ADRs, and do not create or update domain documentation.
6. Inspect every `is blocked by` relationship. Read each blocking issue and stop when any blocker's Jira status category is not `Done`. Report the blocker keys and statuses without modifying the repository.

Summarize the user story, intent, scope, implementation decisions, and acceptance criteria. Treat the Jira issue and any referenced specification as the source of truth. When non-critical details are missing, choose reasonable defaults and record them.

## Confirm Testing Seams

Identify the highest stable public interfaces through which the acceptance criteria can be tested. Use seams without another question only when the Jira issue or referenced specification explicitly records that the user confirmed them.

Otherwise, propose the smallest practical set, include your recommended choice, and ask one question at a time until the user confirms them. Do not write tests against an unconfirmed seam.

## Prepare The Branch

Inspect the current branch and working tree before making changes. Stop if staged, unstaged, or untracked changes would be mixed into this implementation. Do not switch branches or implement until the unrelated work is committed, stashed by the user, or otherwise isolated outside this worktree.

Use the branch name `{ISSUE_KEY}/{short_description}`, where `short_description` is a concise lowercase underscore-separated form of the Jira title. Construct it deterministically by replacing runs of characters outside `[a-z0-9]` with one underscore and trimming leading or trailing underscores. Reject an empty result. Validate all user-provided and generated branch names with `git check-ref-format --branch`, and quote every branch or revision argument passed to Git.

1. Record the initially checked-out branch.
2. If already on a branch whose name starts with `{ISSUE_KEY}/`, continue on it.
3. Otherwise list local branches matching `{ISSUE_KEY}/*`.
4. If exactly one matching branch exists, switch to it.
5. If multiple matching branches exist, ask which one to use.
6. If none exists, create the issue branch from the resolved base.

The base option applies to both branch creation and review comparisons. When continuing an existing issue branch, default the comparison base to `main`. Reject `--base current` when the initially checked-out branch is already an issue branch because that would make the branch its own baseline.

In every path, including when continuing an existing issue branch, require the resolved base to be a local branch, reject a detached `--base current`, verify the base exists, and reject a base that resolves to the selected issue branch itself.

After selecting the issue branch, record `BASE_COMMIT` as the merge base between the resolved base branch and `HEAD`. Use this fixed commit for all later diff and review operations.

## Implement With TDD

Load and follow the `tdd` skill using the confirmed seams.

- Work in vertical slices: one failing test, one minimal implementation, then repeat.
- Run the affected test file after each cycle.
- Run the project's static analysis and typechecking regularly.
- Do not add speculative behavior beyond the Jira issue.
- Preserve the issue's user story and intent when making implementation trade-offs.

## Verify

Discover and run the repository's required checks. Run targeted tests throughout the work, then run the complete relevant test suite, static analysis, typechecking, and formatting checks once at the end.

If required checks cannot pass, stop without committing. Report the failures and leave the implementation available for inspection.

## Review

Load and follow the `code-review` skill once, using its default reviewer collection. Supply:

- The Jira issue requirements and acceptance criteria
- The confirmed testing seams
- The fixed `BASE_COMMIT`
- The paths of untracked files belonging to the implementation
- Repository guidance and relevant ADRs
- The verification commands and results

Fix every Critical and Important finding. Evaluate Suggestions without introducing unrelated churn. The build agent must make all edits; review agents remain read-only. Rerun affected checks and the complete required verification after applying fixes. Do not run a second review round. Do not commit with knowingly unresolved Critical or Important findings.

## Commit

Delegate the final commit to the `committer` agent. The worktree must contain only the reviewed implementation for this Jira issue. Let the committer inspect, stage, and commit the complete change using its normal workflow. Do not bypass hooks or amend existing history.

Return the issue key, branch, commit hash, confirmed seams, checks run, review result, and any residual risks.
