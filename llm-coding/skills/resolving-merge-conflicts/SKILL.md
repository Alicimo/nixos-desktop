---
name: resolving-merge-conflicts
description: Use when you need to resolve an in-progress Git merge or rebase conflict.
---

1. **See the current state** of the merge or rebase. Check Git history, the working tree, and the conflicting files. Identify unrelated pre-existing changes and preserve them.

2. **Find the primary sources** for each conflict. Understand deeply why each change was made and what the original intent was. Read the commit messages, check the pull requests, and check original issues or tickets where available.

3. **Resolve each hunk.** Preserve both intents where possible. Where they are incompatible, pick the resolution matching the merge's stated goal and note the trade-off. Do **not** invent new behavior. Always resolve; never `--abort`.

4. Discover the project's **automated checks** and run them - typically static analysis, then tests, then formatting. Fix anything the merge broke.

5. **Finish the merge or rebase.** Inspect the status and resulting diff, stage only the intended conflict resolutions, and preserve unrelated changes. Commit the merge when required. If rebasing, continue the rebase process until all commits are rebased.
