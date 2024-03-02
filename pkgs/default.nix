{ config, pkgs, ... }:
{
  imports = [
    ./chromium.nix
  ];
  environment.systemPackages = with pkgs; [
     gnome.gnome-tweaks
     cifs-utils
     (python311.withPackages (ps: with ps; [ pandas numpy ]))
     R
     borgbackup
  ];
}