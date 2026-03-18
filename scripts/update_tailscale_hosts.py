#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import signal
import subprocess
import sys
from pathlib import Path
from tempfile import NamedTemporaryFile

BEGIN_MARKER = "# BEGIN TAILSCALE HOSTS"
END_MARKER = "# END TAILSCALE HOSTS"
DEFAULT_HOSTS_PATH = Path("/etc/hosts")
TAILSCALE_CANDIDATES = (
    Path("/run/current-system/sw/bin/tailscale"),
    Path("/etc/profiles/per-user/root/bin/tailscale"),
    Path("/etc/profiles/per-user/tiefenbacher/bin/tailscale"),
    Path("/usr/local/bin/tailscale"),
    Path("/Applications/Tailscale.app/Contents/MacOS/Tailscale"),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--hosts-path", type=Path, default=DEFAULT_HOSTS_PATH)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--input-json", type=Path)
    parser.add_argument("--tailscale-bin", type=Path)
    return parser.parse_args()


def normalize_name(name: str) -> str:
    return re.sub(r"[^a-z0-9.-]", "-", name.rstrip(".").lower())


def find_tailscale_bin(explicit: Path | None) -> Path | None:
    if explicit is not None:
        return explicit if explicit.is_file() and os.access(explicit, os.X_OK) else None

    for candidate in TAILSCALE_CANDIDATES:
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return candidate
    return None


def load_status_json(args: argparse.Namespace) -> dict:
    if args.input_json is not None:
        return json.loads(args.input_json.read_text())

    tailscale_bin = find_tailscale_bin(args.tailscale_bin)
    if tailscale_bin is None:
        return {}

    result = subprocess.run(
        [str(tailscale_bin), "status", "--json"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return {}
    return json.loads(result.stdout)


def build_entries(data: dict) -> list[str]:
    entries: list[str] = []
    seen: set[tuple[str, tuple[str, ...]]] = set()

    for peer in data.get("Peer", {}).values():
        ips = peer.get("TailscaleIPs") or []
        ipv4 = next((ip for ip in ips if "." in ip), None)
        dns_name = (peer.get("DNSName") or "").rstrip(".")
        if ipv4 is None or not dns_name:
            continue

        names: list[str] = []
        for name in (dns_name.split(".", 1)[0], dns_name):
            normalized = normalize_name(name)
            if not normalized or normalized in {"localhost", "broadcasthost"}:
                continue
            if normalized not in names:
                names.append(normalized)

        if not names:
            continue

        key = (ipv4, tuple(names))
        if key in seen:
            continue
        seen.add(key)
        entries.append(f"{ipv4} {' '.join(names)}")

    return sorted(entries)


def render_hosts(current: str, entries: list[str]) -> str:
    block_lines = [BEGIN_MARKER, *entries, END_MARKER]
    block = "\n".join(block_lines)
    pattern = re.compile(
        rf"\n?{re.escape(BEGIN_MARKER)}\n.*?\n{re.escape(END_MARKER)}\n?",
        re.S,
    )

    if pattern.search(current):
        updated = pattern.sub("\n" + block + "\n", current)
    else:
        updated = current.rstrip("\n") + "\n\n" + block + "\n"

    return updated.rstrip("\n") + "\n"


def write_hosts(path: Path, contents: str) -> bool:
    current = path.read_text()
    if current == contents:
        return False

    with NamedTemporaryFile("w", dir=path.parent, delete=False) as temp_file:
        temp_file.write(contents)
        temp_path = Path(temp_file.name)

    temp_path.chmod(0o644)
    shutil.move(temp_path, path)
    subprocess.run(["/usr/bin/dscacheutil", "-flushcache"], check=True)
    subprocess.run(
        ["/usr/bin/killall", "-HUP", "mDNSResponder"],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return True


def main() -> int:
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)
    args = parse_args()
    data = load_status_json(args)
    entries = build_entries(data)
    current = args.hosts_path.read_text()
    updated = render_hosts(current, entries)

    if args.write:
        changed = write_hosts(args.hosts_path, updated)
        print("updated" if changed else "unchanged")
    else:
        sys.stdout.write(updated)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
