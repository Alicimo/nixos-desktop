{ pkgs, ... }:

with pkgs; [
  # CLI tools
  # ghostty
  bat
  coreutils
  du-dust
  killall
  ripgrep
  tree
  unzip
  wget
  curl
  zip
  difftastic
  eza
  fd
  pciutils
  flyctl

  # Monitors
  btop
  iotop
  nload

  # File-related packages
  pandoc
  imagemagick
  ffmpeg
  rsync

  # Dev
  (python312.withPackages (ps: with ps; [ polars pandas numpy ]))
  R
  # ruff
  sqlite
  devenv
  git
]