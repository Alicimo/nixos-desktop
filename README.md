# NixOS Desktop Configuration

A Nix Flake configuration for managing both macOS (Darwin) and NixOS systems with Home Manager integration.

## System Configurations

- **Darwin**: `tiefenbacher-macbook` (aarch64-darwin)
- **NixOS**: `tiefenbacher-desktop` (x86_64-linux)

## Building Systems

### Darwin (macOS)
```bash
# Build and switch to new configuration
darwin-rebuild switch --flake .#tiefenbacher-macbook

# Build without switching (for testing)
darwin-rebuild build --flake .#tiefenbacher-macbook

# Check what would change
darwin-rebuild build --flake .#tiefenbacher-macbook --show-trace
```

### NixOS (Linux)
```bash
# Build and switch to new configuration
sudo nixos-rebuild switch --flake .#tiefenbacher-desktop

# Build without switching (for testing)
sudo nixos-rebuild build --flake .#tiefenbacher-desktop

# Test configuration (temporary switch)
sudo nixos-rebuild test --flake .#tiefenbacher-desktop
```

## Common Commands

### Flake Management
```bash
# Show flake outputs and configurations
nix flake show

# Check flake for issues
nix flake check

# Update all flake inputs
nix flake update

# Update specific input
nix flake update <input-name>

# Lock file operations
nix flake lock --update-input <input-name>
```

### Building Specific Outputs
```bash
# Build Darwin configuration
nix build .#darwinConfigurations.tiefenbacher-macbook.system

# Build NixOS configuration  
nix build .#nixosConfigurations.tiefenbacher-desktop.config.system.build.toplevel

# Build Home Manager configuration
nix build .#homeConfigurations.<username>@<hostname>.activationPackage
```

### Development & Debugging
```bash
# Enter development shell
nix develop

# Build with verbose output
nix build --verbose

# Build with trace for debugging
nix build --show-trace

# Garbage collection
nix-collect-garbage -d
```

## Updating Inputs and Lock File

### Update All Inputs
```bash
# Updates all inputs to their latest versions
nix flake update
```

### Update Specific Inputs
```bash
# Update nixpkgs
nix flake update nixpkgs

# Update home-manager
nix flake update home-manager

# Update nix-darwin
nix flake update nix-darwin
```

### Lock File Management
```bash
# Regenerate lock file from scratch
rm flake.lock && nix flake lock

# Update lock file for specific input
nix flake lock --update-input nixpkgs

# Show lock file info
nix flake metadata
```

## Configuration Structure

```
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Lock file with pinned versions
├── hosts/
│   ├── darwin.nix              # Darwin system configuration
│   └── nixos.nix               # NixOS system configuration
└── modules/
    ├── darwin/                 # Darwin-specific modules
    │   ├── casks.nix          # Homebrew casks
    │   └── home-manager.nix   # Darwin Home Manager config
    ├── nixos/                  # NixOS-specific modules
    │   ├── gnome.nix          # GNOME desktop configuration
    │   └── home-manager.nix   # NixOS Home Manager config
    └── shared/                 # Shared configuration
        ├── all-packages.nix   # Platform-aware package definitions
        ├── default.nix        # Shared system configuration
        ├── home-manager.nix   # Shared Home Manager programs
        ├── packages.nix       # Base package list
        └── user-config.nix    # Centralized user configuration
```

## Key Features

- **Unified User Configuration**: Centralized user settings via `modules/shared/user-config.nix`
- **Platform-Aware Packages**: Shared package definitions that work across Darwin and NixOS
- **Home Manager Integration**: Consistent dotfiles and user environment across systems
- **Homebrew Integration**: Darwin systems use nix-homebrew for cask management
- **Firefox Overlay**: Custom Firefox builds for Darwin via nixpkgs-firefox-darwin

## Troubleshooting

### Common Issues

1. **Build Failures**: Run with `--show-trace` for detailed error information
2. **Lock File Conflicts**: Delete `flake.lock` and run `nix flake lock` to regenerate
3. **Permission Issues**: Ensure proper sudo access for NixOS builds
4. **Home Manager Issues**: Check user configuration in `modules/shared/user-config.nix`

### Getting Help

- Check system logs: `journalctl -u nixos-rebuild` (NixOS) or Console.app (Darwin)
- Verify flake syntax: `nix flake check`
- Test configuration: Use build commands without switching first