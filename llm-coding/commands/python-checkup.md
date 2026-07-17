---
description: Run formatting, linting, and testing checks for a Python project
---

1. Execute the following checks in order:

   * `uv run ruff format .` –  Code formating using Ruff
   * `uv run ruff check .` – Static analysis and linting using Ruff
   * `uv run pytest` –  Test suite with `pytest`

2. If **any command fails**:

   * Applies necessary changes (e.g., formatting)
   * Reruns the affected check(s)
   * If an earlier step (e.g., linting or formatting) passed **before**, it’s rerun to ensure consistency

3. Repeats this cycle until:

   * All three checks pass without any errors or fixes
   * The code is clean, styled, and test-verified
