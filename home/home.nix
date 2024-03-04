{ config, pkgs, lib, ... }:
 let
   my-llama = ((pkgs.llama-cpp.overrideAttrs (finalAttrs: previousAttrs: {
     cmakeFlags = (previousAttrs.cmakeFlags ++ [ "-DAMDGPU_TARGETS=gfx1030" ]);
     })).override { rocmSupport = true; blasSupport=false; });
 in
{ 
  imports = [
    ./antuin.nix
    ./bash.nix
    ./chromium.nix
    ./git.nix
    ./gnome.nix
    ./vim.nix
    ./vscode.nix
  ];
  home.username = "alistair";
  home.homeDirectory = "/home/alistair";
  home.packages = with pkgs; [
      thunderbird
      vlc
      libreoffice
      rstudio
      anki
      # ((ollama.overrideAttrs (finalAttrs: previousAttrs: {
      #   ldflags = (previousAttrs.ldflags ++ [ "-tags rocm" ]);
      # })).override { llama-cpp = my-llama; })
      # doesn't work due to the rocm tag needing to be including at generate
      my-llama

      htop
      atop
      iotop
      unzip
      wget
      curl
      imagemagick
      tree
      cifs-utils

      handbrake
      makemkv
      (abcde.overrideAttrs (oldAttrs: { buildInputs = oldAttrs.buildInputs ++ [ pkgs.perlPackages.IOSocketSSL ]; }))
      flac
  ];
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}