#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "python-slugify",
# ]
# ///

from __future__ import annotations

import argparse
from pathlib import Path

from slugify import slugify  # type: ignore[import-not-found]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Rename a file to a slugified name")
    parser.add_argument("path", type=Path)
    return parser.parse_args()


def split_name(name: str) -> tuple[str, str]:
    if name.startswith(".") and name.count(".") == 1:
        return name, ""
    if "." not in name:
        return name, ""

    stem, suffix = name.split(".", 1)
    return stem, f".{suffix}"


def main() -> int:
    args = parse_args()
    path = args.path

    if not path.exists():
        raise SystemExit(f"file not found: {path}")
    if path.is_dir():
        raise SystemExit(f"expected a file, got directory: {path}")

    stem, suffix = split_name(path.name)
    slug = slugify(stem)
    if not slug:
        raise SystemExit("slugify produced an empty filename")

    target = path.with_name(f"{slug}{suffix}")
    if target == path:
        print(target)
        return 0
    if target.exists():
        raise SystemExit(f"target already exists: {target}")

    path.rename(target)
    print(target)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
