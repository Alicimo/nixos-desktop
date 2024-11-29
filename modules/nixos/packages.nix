{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  vlc
  libreoffice
  anki
  telegram-desktop
  thunderbird
  chromium

  spotube
  freetube
  steam

  handbrake
  makemkv
  abcde
  flac

  brlaser
  borgbackup
]