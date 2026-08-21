---
name: explain-diff-html
description: Use when the user asks for a rich, interactive HTML explanation of a code change, diff, branch, commit, or PR.
---

# Explain Diff as HTML

Create a rich, interactive explanation of the specified code change.

## Establish the Change

Resolve the exact comparison before writing:

- Use the commit, range, branch, PR, or working-tree change named by the user.
- If the target is ambiguous and cannot be inferred safely from context, ask one concise clarification question.
- Record the fixed comparison point and include staged, unstaged, and relevant untracked files when the working tree is in scope.
- Inspect the diff and broadly explore the surrounding code so the explanation covers both the changed lines and the system they affect.

Do not modify the repository while producing the explanation.

## Content

Build one continuous page with these sections:

1. **Background**: Explain the existing system relevant to the change. Start with a clearly skippable primer for beginners, then narrow to the context directly needed to understand the change.
2. **Intuition**: Explain the essence of the change before its mechanics. Use concrete examples with toy data and visual diagrams where they clarify behavior.
3. **Code**: Walk through the changes at a high level. Group and order them by concept or execution flow rather than merely following file order. Include precise file references.
4. **Quiz**: Provide exactly five medium-difficulty multiple-choice questions that test substantive understanding rather than trivia. Selecting an answer must reveal whether it is correct and explain why.

Write clear, engaging technical prose with smooth transitions. Prefer a small number of consistent visual diagram families that can be reused throughout the explanation. Useful choices include simplified UI mockups and system diagrams that show components, data flow, and representative example data.

## HTML Requirements

- Produce a single self-contained HTML file with inline CSS and JavaScript and no external assets or network dependencies.
- Use one long page with section headings and a table of contents. Do not use tabs for the top-level structure.
- Make the layout responsive and readable on desktop and mobile.
- Use semantic HTML and accessible controls. Quiz options must be keyboard-operable, show visible focus states, and expose feedback without relying on color alone.
- Use styled HTML elements for diagrams. Do not use ASCII diagrams.
- Put code in `<pre><code>` elements. Ensure the applicable CSS uses `white-space: pre` or `white-space: pre-wrap`.
- HTML-escape all repository-derived text before embedding it, including code, paths, commit messages, and user-provided labels. Do not interpolate untrusted text into executable JavaScript.
- Use callouts for key concepts, definitions, and important edge cases.

## Output

Write the result outside the repository under `/tmp`. Name it with today's local date in the form `/tmp/YYYY-MM-DD-explanation-<short-descriptive-slug>.html`. Use a filesystem-safe lowercase slug and avoid overwriting an unrelated existing file.

Before reporting completion, verify that:

- the file exists outside the repository and opens as a standalone HTML document;
- all four required sections and exactly five quiz questions are present;
- every code block preserves whitespace;
- the page contains no external asset or network references; and
- the repository worktree was not changed by generating the explanation.

Return the absolute output path and a one-sentence description of the comparison explained.
