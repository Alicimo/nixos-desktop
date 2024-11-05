{ pkgs, ... }:

with pkgs; [
  # General packages for development and system management
  bat
  btop
  coreutils
  killall
  # openssh
  pandoc
  sqlite
  wget
  zip
  devenv
  direnv

  # Media-related packages
  imagemagick
  ffmpeg
  fd
  pngquant
  jpegoptim

  # Text and terminal utilities
  iftop
  iotop
  ripgrep
  tree
  unzip
  git

  # Programming
  (python312.withPackages (ps: with ps; [ polars pandas numpy ipykernel jupyter requests]))
  R
  ruff
]