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
  
  # Media-related packages
  imagemagick
  ffmpeg
  fd
  pngquant
  jpegoptim
  fira-code
  fira-code-symbols

  # Source code management, Git, GitHub tools
  git

  # Text and terminal utilities
  iftop
  iotop
  ripgrep
  tree
  unzip

  # Python packages
  python311
  python311Packages.virtualenv
  ruff

  R
]