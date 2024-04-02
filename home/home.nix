{ config, pkgs, lib, ... }:{
  imports = [
    ./antuin.nix
    ./bash.nix
    ./chromium.nix
    ./git.nix
    ./gnome.nix
    ./vim.nix
    ./vscode.nix
    ./guake.nix
  ];
  home.username = "alistair";
  home.homeDirectory = "/home/alistair";
  home.packages = with pkgs; [
    thunderbird
    vlc
    libreoffice
    rstudio
    anki
    telegram-desktop

    htop
    atop
    iotop
    unzip
    wget
    curl
    imagemagick
    tree
    cifs-utils
    pkgs.unstable.llama-cpp

    handbrake
    makemkv
    (abcde.overrideAttrs (oldAttrs: { buildInputs = oldAttrs.buildInputs ++ [ pkgs.perlPackages.IOSocketSSL ]; }))
    flac
  ];
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
