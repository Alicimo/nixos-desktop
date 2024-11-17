{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  vlc
  libreoffice
  anki
  telegram-desktop
  lmstudio
  thunderbird
  firefox

  spotube
  freetube
  steam

  # handbrake
  makemkv
  abcde
  flac

  brlaser
  borgbackup
]