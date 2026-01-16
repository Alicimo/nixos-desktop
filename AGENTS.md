# Repository Guidelines

## Project Structure & Module Organization
This repo is a Nix flake for macOS (nix-darwin) and NixOS systems with Home Manager integration.
Key paths:
- `flake.nix`, `flake.lock`: entry point and pinned inputs.
- `hosts/`: host-specific configs (`darwin.nix`, `nixos.nix`).
- `modules/darwin/`, `modules/nixos/`: platform modules.
- `modules/shared/`: shared config (`packages.nix`, `all-packages.nix`, `home-manager.nix`, `user-config.nix`).
- `scripts/`: helper scripts (e.g., `scripts/nix_build_times.py`).

## Build, Test, and Development Commands
- `darwin-rebuild switch --flake .#tiefenbacher-macbook`: apply macOS config.
- `darwin-rebuild build --flake .#tiefenbacher-macbook`: build without switching.
- `sudo nixos-rebuild switch --flake .#tiefenbacher-desktop`: apply NixOS config.
- `nix build .#darwinConfigurations.tiefenbacher-macbook.system`: build Darwin output directly.
- `nix flake check`: validate flake evaluation.
- `nix flake update [input]`: update inputs.

## Coding Style & Naming Conventions
- Nix files use 2-space indentation (follow existing style in `modules/**`).
- Keep modules small and platform-specific; use `modules/shared/` for cross-platform settings.
- Prefer descriptive option blocks (e.g., `programs.fish`, `nixvim.plugins.*`).

## Testing Guidelines
- No automated test suite is defined.
- Use `nix flake check` and `darwin-rebuild build`/`nixos-rebuild build` for validation.

## Commit & Pull Request Guidelines
- No commit message convention is defined in this repo; use clear, imperative summaries.
- PRs should describe the host/OS affected and list any commands run (e.g., `nix flake check`).

## Configuration & Troubleshooting Tips
- For build profiling, run `python scripts/nix_build_times.py nix build .#darwinConfigurations.tiefenbacher-macbook.system` and inspect `/tmp/nix-build-times.tsv`.
- When diagnosing failures, re-run with `--show-trace`.
