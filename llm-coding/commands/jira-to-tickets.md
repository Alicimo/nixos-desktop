---
description: Break a conversation or specification into linked Jira tickets
agent: build
variant: high
---

Turn the current conversation into an approved graph of Jira tickets. Use any additional input supplied with the command:

$ARGUMENTS

If the input names an existing local specification, read it in full and use it together with the conversation context. Otherwise, treat the input as additional guidance. Do not interpret the input as a Jira issue key.

## Gather Context

Explore the relevant parts of the repository if needed. Use the project's domain glossary vocabulary and respect applicable ADRs. Look for prefactoring that would make the requested change easier before implementing it.

## Draft The Ticket Graph

Break the work into tracer-bullet vertical slices:

- Each Task must deliver a narrow but complete path through every relevant layer.
- Each Task must be independently demonstrable or verifiable.
- Each Task must fit within one fresh agent context.
- Prefer a small number of deep, stable interfaces over many shallow seams.
- Put necessary prefactoring before the work it enables.

For a wide mechanical refactor that cannot remain green as vertical slices, use expand-contract Tasks instead: add the new form, migrate callers in independently safe batches, then remove the old form.

Use a Sub-task only when work cannot stand alone and belongs to exactly one generated Task. Do not create an umbrella Task merely to contain the other tickets. Do not use Sub-tasks for horizontal layers such as database work, API work, or tests.

Give every ticket its blocking edges. Parent-child structure expresses ownership; `Blocks` links express execution order. They are separate relationships.

## Get Approval

Present the complete proposed graph before creating anything. For every ticket show:

- **Type**: Task or Sub-task
- **Title**: concise and descriptive
- **Parent**: generated parent Task title, for a Sub-task
- **Blocked by**: generated ticket titles, or None
- **User story**: actor, requested capability, and benefit
- **Intent**: why the ticket exists and what future implementers must understand
- **What it delivers**: observable end-to-end behavior
- **Acceptance criteria**: testable outcomes

Ask whether the granularity, parent-child structure, and blocking edges are correct and whether any tickets should be merged or split. Iterate until the user explicitly approves the graph. Do not create Jira issues before approval.

## Publish

After approval, load and follow the `jira-publish-issues` skill with the complete graph. Use the source specification path in ticket descriptions when one was supplied.

After publication, return every created ticket key and URL. Identify the initial frontier: all tickets with no unresolved blockers.
