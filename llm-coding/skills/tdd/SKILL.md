---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests.
---

# Test-Driven Development

Use vertical red -> green slices to produce tests that verify behavior and survive refactoring. Refactoring is a separate phase after the implementation loop.

Read the root `CONTEXT.md` and relevant `docs/adr/` files when present. Use their vocabulary, surface conflicts, and do not update domain documentation.

## What a good test is

Tests should read as behavioral specifications and remain valid when internal structure changes.

Read [tests.md](tests.md) when selecting or evaluating tests. Read [mocking.md](mocking.md) only when substituting an external or nondeterministic boundary.

## Seams - where tests go

A **seam** is the public boundary where behavior is observed without reaching into internals.

Test only at user-confirmed seams supplied by the caller or recorded in the task or specification. Otherwise propose the smallest practical seam set and obtain confirmation before writing tests.

## Anti-patterns

- **Implementation-coupled** - tests private methods, internal collaborator calls, or side channels and therefore breaks when internals change without a behavior change.
- **Tautological** - copies the production algorithm into the expected value. Use a simpler, independently justified oracle such as a specification, worked example, invariant, or known-good literal.
- **Horizontal slicing** - writes all tests before all implementation, committing to imagined behavior and test structure too early. Use vertical tracer bullets that respond to each preceding cycle.

## Rules of the loop

- **Red before green.** Write one failing test, then only enough code to pass it. Do not anticipate later tests or behavior.
- **One slice at a time.** Use one seam, test, and minimal implementation per cycle.
- **Refactor separately.** Refactor after the red -> green implementation loop and before final review. The outer workflow owns review orchestration.
