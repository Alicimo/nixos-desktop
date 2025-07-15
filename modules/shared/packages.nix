{ pkgs, ... }:

with pkgs;
[
  # CLI tools
  bat # A cat clone with syntax highlighting and Git integration
  coreutils # GNU core utilities like ls, cp, mv, etc.
  du-dust # A more intuitive version of `du` for disk usage
  ripgrep # Fast recursive search like grep, but better
  tree # Displays directory structure in a tree-like format
  wget # Non-interactive network downloader
  difftastic # Syntax-aware diff tool
  eza # Modern replacement for `ls` with more features
  fd # Simple, fast and user-friendly alternative to `find`
  pciutils # Tools for inspecting and configuring PCI devices
  flyctl # CLI for managing apps on the Fly.io platform
  nixfmt-tree # treefmt combined w/ nix-fmt for linting/formating of .nix

  # Monitors
  btop # Resource monitor with a modern UI
  iotop # Monitor disk I/O usage by processes
  nload # Real-time network traffic monitor

  # File-related packages
  pandoc # Universal document converter
  imagemagick # Toolset for editing and converting images
  ffmpeg # Command-line tool for processing video and audio
  rsync # Efficiently sync files and directories over network or locally

  # Dev
  R # Language and environment for statistical computing
  sqlite # Lightweight, self-contained SQL database engine
  devenv # Tool for reproducible, shareable developer environments
  git # Distributed version control system
  repomix # Tool for managing monorepos (multi-package repositories)
  claude-code # CLI interface for Anthropic’s Claude AI for code assistance
  podman # Container runtime for building and running Docker containers
  nodejs_24 # Nodejs is required to run mcp servers

  (python312.withPackages (
    ps: with ps; [
      polars # Fast DataFrame library in Rust with Python bindings
      pandas # Powerful data analysis and manipulation library
      numpy # Core library for numerical computing in Python
      plotly # Interactive plotting library
      aider-chat # AI pair programming in your terminal using GPT-based models
      uv # Ultra-fast Python package manager and environment manager
      ruff # Fast Python linter, formatter, and import sorter
    ]
  ))
]
