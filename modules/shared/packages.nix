{ pkgs, ... }:

with pkgs; [
  # CLI tools
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
  R
  sqlite
  devenv
  git

  (python312.withPackages (ps: with ps; [
    polars
    pandas
    numpy
    plotly
    aider-chat
    uv
    ruff
  ]))
]