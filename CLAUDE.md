# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Nix Flake configuration for managing both macOS (Darwin) and NixOS systems with Home Manager integration.

### System Configurations
- **Darwin**: `tiefenbacher-macbook` (aarch64-darwin) - configured in `hosts/darwin.nix`
- **NixOS**: `tiefenbacher-desktop` (x86_64-linux) - configured in `hosts/nixos.nix`

### Module Structure
- `modules/shared/`: Common packages and configuration shared across systems
- `modules/darwin/`: macOS-specific configuration including homebrew casks
- `modules/nixos/`: Linux-specific configuration including GNOME desktop

### Key Features
- Home Manager integration for both systems with user-specific dotfiles
- Homebrew integration on Darwin via nix-homebrew
- Shared package definitions with stable/unstable Nixpkgs channels
- Firefox overlay for Darwin from nixpkgs-firefox-darwin

## Common Commands

### Building Systems
```bash
# Build Darwin configuration
darwin-rebuild switch --flake .#tiefenbacher-macbook

# Build NixOS configuration  
nixos-rebuild switch --flake .#tiefenbacher-desktop
```

### Flake Management
```bash
# Update flake inputs
nix flake update

# Show flake info
nix flake show

# Check flake
nix flake check
```

### Package Management
Packages are defined in:
- `modules/shared/packages.nix` - shared across all systems
- `modules/darwin/packages.nix` - Darwin-specific packages
- `modules/nixos/packages.nix` - NixOS-specific packages

### Home Manager
Home Manager configurations are imported through the flake and configured per-system in the respective module directories.