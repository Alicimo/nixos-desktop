#!/usr/bin/env python3
"""
Run a Nix build (or darwin-rebuild) with JSON logging enabled, capture the raw
log, and emit per-derivation build durations.

Usage examples:
  python scripts/nix_build_times.py \
    nix build .#darwinConfigurations.tiefenbacher-macbook.system

  python scripts/nix_build_times.py \
    darwin-rebuild switch --flake .

Outputs:
  /tmp/nix-build-log.json   (raw Nix JSON log, stdout+stderr)
  /tmp/nix-build-times.tsv  (seconds\t.drv, sorted desc)
"""

from __future__ import annotations

import json
import os
import sys
import subprocess
from datetime import datetime
from pathlib import Path

LOG_PATH = Path("/tmp/nix-build-log.json")
TIMES_PATH = Path("/tmp/nix-build-times.tsv")


def parse_time(ts: str) -> datetime:
    # Example: 2026-01-16T12:34:56.789Z
    return datetime.fromisoformat(ts.replace("Z", "+00:00"))


def run_build(cmd: list[str]) -> int:
    env = os.environ.copy()
    # Ensure we get JSON events; darwin-rebuild doesn't accept --log-format
    env["NIX_LOG_FORMAT"] = "internal-json"

    with LOG_PATH.open("w") as log_file:
        # Combine stdout+stderr so we capture the JSON events.
        proc = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            env=env,
        )
        assert proc.stdout is not None
        for line in proc.stdout:
            log_file.write(line)
            log_file.flush()
            # Stream build output to terminal as well
            print(line, end="")

    return proc.wait()


def analyze_log() -> None:
    starts: dict[str, datetime] = {}
    durations: list[tuple[float, str]] = []

    if not LOG_PATH.exists() or LOG_PATH.stat().st_size == 0:
        print(f"No log data found at {LOG_PATH}", file=sys.stderr)
        return

    with LOG_PATH.open() as f:
        for raw in f:
            raw = raw.strip()
            if not raw:
                continue
            try:
                ev = json.loads(raw)
            except json.JSONDecodeError:
                continue

            t = ev.get("type")
            drv = ev.get("drv")
            ts = ev.get("time")
            if not (t and drv and ts):
                continue

            if t == "startBuild":
                starts[drv] = parse_time(ts)
            elif t == "stopBuild":
                if drv in starts:
                    dur = (parse_time(ts) - starts[drv]).total_seconds()
                    durations.append((dur, drv))

    durations.sort(reverse=True)

    with TIMES_PATH.open("w") as out:
        for dur, drv in durations:
            out.write(f"{dur:.2f}\t{drv}\n")

    print(f"\nWrote {TIMES_PATH} (seconds\t.drv)")


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: nix_build_times.py <command> [args...]", file=sys.stderr)
        return 2

    cmd = sys.argv[1:]
    print(f"Running: {' '.join(cmd)}")
    print(f"Logging to: {LOG_PATH}")

    code = run_build(cmd)
    analyze_log()
    return code


if __name__ == "__main__":
    raise SystemExit(main())
