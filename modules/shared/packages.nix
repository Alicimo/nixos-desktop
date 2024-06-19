{ pkgs, ... }:

with pkgs; [
  # General packages for development and system management
  act
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  difftastic
  du-dust
  gcc
  git-filter-repo
  killall
  neofetch
  openssh
  pandoc
  sqlite
  wget
  zip

  # Encryption and security tools
  _1password
  age
  age-plugin-yubikey
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  # docker
  # docker-compose
  # awscli2 - marked broken Mar 22
  flyctl
  google-cloud-sdk
  go
  gopls
  ngrok
  ssm-session-manager-plugin
  terraform
  terraform-ls
  tflint

  # Media-related packages
  emacs-all-the-icons-fonts
  imagemagick
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  glow
  hack-font
  jpegoptim
  meslo-lgs-nf
  noto-fonts
  noto-fonts-emoji
  pngquant

  # Source code management, Git, GitHub tools
  git

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jetbrains.phpstorm
  jq
  ripgrep
  slack
  tree
  unzip

  # Python packages
  python311
  python311Packages.virtualenv
  ruff

  R
]