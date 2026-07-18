---
name: resolving-merge-conflicts
description: Use when you need to resolve an in-progress Git merge or rebase conflict.
---

Complete the active merge or rebase and leave `git status` clean. Invocation authorises staging, continuing, and commits required by the operation.

1. Inspect the operation, history, status, and conflicts. Preserve unrelated pre-existing changes.

2. Establish both intents from the code, history, and linked context. If the resolution remains ambiguous, ask rather than guessing or aborting.

3. Preserve both intents where possible. Otherwise follow the operation's goal, report the trade-off, and do not invent behaviour.

4. Run relevant repository checks and fix failures caused by the resolution.

5. Stage only the resolution and continue to completion. Verify the result and clean status. If unrelated pre-existing changes prevent a clean status, preserve and report them; do not include, stash, or discard them.
