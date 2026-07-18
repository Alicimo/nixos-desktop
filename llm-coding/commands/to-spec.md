---
description: Turn the current conversation into a repository specification
agent: build
variant: high
---

Turn the current conversation context and codebase understanding into a specification. Do not restart the requirements interview or ask the user to repeat information already provided. Use any additional guidance supplied with the command:

$ARGUMENTS

## Process

1. Before exploring, read the root `CONTEXT.md` and relevant ADRs under `docs/adr/` if they exist. If absent, proceed silently. Use glossary vocabulary throughout the specification, surface conflicts with existing ADRs, and do not create or update domain documentation. Explore the repository to understand the relevant current behavior if you have not already done so.

2. Sketch the seams at which the feature will be tested. Prefer existing seams to new ones and use the highest public seam possible. Propose as few seams as practical; ideally use one. Ask the user to confirm that the proposed seams match their expectations before writing the specification. This is the only required clarification unless proceeding would otherwise require inventing information.

3. Derive a concise kebab-case slug from the feature and write the specification to `docs/specs/<slug>.md`. Create `docs/specs/` if needed. If the target file already exists, do not overwrite it without explicit confirmation.

4. Use the template below. Add a concise document title above the template sections. Do not publish the specification to an issue tracker.

5. Return the resulting file path so it can be supplied to a later ticket-generation workflow.

## Specification Template

### Problem Statement

Describe the problem from the user's perspective.

### Solution

Describe the solution from the user's perspective.

### User Stories

Provide a comprehensive numbered list of user stories in this format:

1. As an `<actor>`, I want `<feature>`, so that `<benefit>`.

Cover all meaningful aspects of the feature without manufacturing unsupported requirements.

### Implementation Decisions

Record the implementation decisions already established in the conversation or codebase, including relevant module boundaries, public interfaces, technical clarifications, architectural decisions, schema changes, API contracts, and interactions.

Do not include specific file paths or routine code snippets because they become outdated quickly. If a prototype produced a concise snippet that expresses a decision more precisely than prose, include only the decision-rich portion and identify it as prototype output.

### Testing Decisions

Describe:

- The externally observable behavior that tests should verify
- The confirmed seams under test
- The modules or public interfaces covered by those seams
- Similar tests already present in the codebase, where relevant

Do not prescribe tests of implementation details.

### Out of Scope

State what the specification deliberately excludes.

### Further Notes

Record any relevant context that does not fit the preceding sections.
